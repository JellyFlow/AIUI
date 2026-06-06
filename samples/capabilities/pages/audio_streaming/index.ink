<script type="application/json" def>
{
  "navigationBarTitleText": "Audio Streaming Test"
}
</script>

<script setup>
import { AudioPlayer } from 'audio';
import pcmBlob, {
  mimeType as PCM_MIME_TYPE,
  path as PCM_PATH,
} from '../../assets/audio-streaming-test.pcm';
import opusBlob, {
  mimeType as OPUS_MIME_TYPE,
  path as OPUS_PATH,
} from '../../assets/audio-streaming-test.ogg';

const POLL_INTERVAL_MS = 250;
const PANEL_KEYS = ['pcm', 'ogg_opus'];
const OGG_PAGE_HEADER_LEN = 27;
const PANEL_CONFIG = {
  pcm: {
    title: 'PCM Streaming',
    assetPath: PCM_PATH,
    assetBlob: pcmBlob,
    assetMimeType: PCM_MIME_TYPE || 'application/octet-stream',
    chunkSize: 3840,
    appendIntervalMs: 40,
    createOptions: {
      format: 'pcm',
      sample_rate: 48000,
      number_of_channels: 1,
      sample_format: 's16',
    },
  },
  ogg_opus: {
    title: 'Ogg/Opus Streaming',
    assetPath: OPUS_PATH,
    assetBlob: opusBlob,
    assetMimeType: OPUS_MIME_TYPE || 'audio/ogg',
    chunkSize: 512,
    appendIntervalMs: 50,
    createOptions: {
      format: 'ogg_opus',
    },
  },
};

function isOggOpusKey(key) {
  return key === 'ogg_opus';
}

function matchesAscii(bytes, offset, ascii) {
  if (offset + ascii.length > bytes.length) {
    return false;
  }
  for (let index = 0; index < ascii.length; index += 1) {
    if (bytes[offset + index] !== ascii.charCodeAt(index)) {
      return false;
    }
  }
  return true;
}

function findOggOpusLoopStartOffset(bytes) {
  if (!(bytes instanceof Uint8Array) || bytes.length < OGG_PAGE_HEADER_LEN) {
    throw new Error('Ogg/Opus fixture is too short');
  }

  let offset = 0;
  let packetIndex = 0;
  let pendingPacket = [];

  while (offset + OGG_PAGE_HEADER_LEN <= bytes.length) {
    const pageStart = offset;
    if (packetIndex >= 2) {
      const headerType = bytes[pageStart + 5];
      if ((headerType & 0x01) !== 0) {
        throw new Error('Ogg/Opus loop start is not aligned to a fresh page boundary');
      }
      return pageStart;
    }

    if (!matchesAscii(bytes, pageStart, 'OggS')) {
      throw new Error('Invalid Ogg capture pattern in Ogg/Opus fixture');
    }

    const segmentCount = bytes[pageStart + 26];
    const headerLen = OGG_PAGE_HEADER_LEN + segmentCount;
    if (pageStart + headerLen > bytes.length) {
      throw new Error('Truncated Ogg page header in Ogg/Opus fixture');
    }

    const headerType = bytes[pageStart + 5];
    const isContinued = (headerType & 0x01) !== 0;
    if (isContinued && pendingPacket.length === 0) {
      throw new Error('Ogg/Opus fixture starts a continued packet without prior data');
    }
    if (!isContinued && pendingPacket.length > 0) {
      throw new Error('Ogg/Opus header packets are not aligned as expected');
    }

    let dataLen = 0;
    for (let index = pageStart + OGG_PAGE_HEADER_LEN; index < pageStart + headerLen; index += 1) {
      dataLen += bytes[index];
    }

    const totalLen = headerLen + dataLen;
    if (pageStart + totalLen > bytes.length) {
      throw new Error('Truncated Ogg page payload in Ogg/Opus fixture');
    }

    let cursor = pageStart + headerLen;
    for (let laceIndex = 0; laceIndex < segmentCount; laceIndex += 1) {
      const size = bytes[pageStart + OGG_PAGE_HEADER_LEN + laceIndex];
      const packetSlice = bytes.slice(cursor, cursor + size);
      pendingPacket.push(...packetSlice);
      cursor += size;

      if (size < 255) {
        const packet = new Uint8Array(pendingPacket);
        pendingPacket = [];

        if (packetIndex === 0 && !matchesAscii(packet, 0, 'OpusHead')) {
          throw new Error('Missing OpusHead packet in Ogg/Opus fixture');
        }
        if (packetIndex === 1 && !matchesAscii(packet, 0, 'OpusTags')) {
          throw new Error('Expected OpusTags packet after OpusHead');
        }

        packetIndex += 1;
        if (packetIndex === 2 && laceIndex !== segmentCount - 1) {
          throw new Error('Ogg/Opus loop start shares a page with header packets');
        }
      }
    }

    offset += totalLen;
  }

  throw new Error('Unable to determine Ogg/Opus loop start');
}

function formatNumber(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '0.00';
  }
  return value.toFixed(2);
}

function formatBytes(value) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return '0 B';
  }
  if (value < 1024) {
    return `${value} B`;
  }
  if (value < 1024 * 1024) {
    return `${(value / 1024).toFixed(2)} KB`;
  }
  return `${(value / (1024 * 1024)).toFixed(2)} MB`;
}

function createPanelViewState(key) {
  const config = PANEL_CONFIG[key];
  return {
    key,
    title: config.title,
    actionLabel: 'Start Playback',
    format: config.createOptions.format,
    assetPath: config.assetPath,
    assetMimeType: config.assetMimeType,
    assetSize: formatBytes(config.assetBlob.size || 0),
    chunkSize: formatBytes(config.chunkSize),
    appendIntervalMs: `${config.appendIntervalMs} ms`,
    playerCreated: false,
    sourceLoaded: false,
    autoStreaming: false,
    chunksAppended: 0,
    totalChunks: 0,
    bytesAppended: '0 B',
    lastError: '',
    paused: true,
    currentTime: '0.00',
    duration: '0.00',
    buffered: '0.00',
  };
}

function createPanelRuntime() {
  return {
    player: null,
    sourceBytes: null,
    loopStartOffset: 0,
    offset: 0,
    totalChunks: 0,
    chunksAppended: 0,
    bytesAppended: 0,
    timer: null,
  };
}

function getPanelKeyFromEvent(event) {
  const attributes = (event && event.currentTarget && event.currentTarget.attributes) || {};
  return attributes['data-panel'];
}

function getErrorMessage(error) {
  if (error && error.message) {
    return error.message;
  }
  return String(error || 'Unknown error');
}

export default {
  data: {
    pcmPanel: createPanelViewState('pcm'),
    opusPanel: createPanelViewState('ogg_opus'),
  },

  onLoad() {
    this.panels = {
      pcm: createPanelRuntime(),
      ogg_opus: createPanelRuntime(),
    };
    this.pollTimer = setInterval(() => {
      PANEL_KEYS.forEach((key) => this.refreshPanelState(key));
    }, POLL_INTERVAL_MS);
  },

  onUnload() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer);
      this.pollTimer = null;
    }
    PANEL_KEYS.forEach((key) => this.destroyPanelInternal(key, false));
  },

  getPanelDataKey(key) {
    return key === 'pcm' ? 'pcmPanel' : 'opusPanel';
  },

  getPanelViewState(key) {
    return this.data[this.getPanelDataKey(key)];
  },

  updatePanelViewState(key, patch) {
    const panelKey = this.getPanelDataKey(key);
    this.setData({
      [panelKey]: {
        ...this.data[panelKey],
        ...patch,
      },
    });
  },

  setPanelError(key, message) {
    this.updatePanelViewState(key, { lastError: message || 'Unknown error' });
  },

  clearPanelError(key) {
    if (this.getPanelViewState(key).lastError) {
      this.updatePanelViewState(key, { lastError: '' });
    }
  },

  snapshotPanelState(key) {
    const runtime = this.panels[key];
    const player = runtime.player;
    if (!player) {
      return {
        paused: true,
        currentTime: '0.00',
        duration: '0.00',
        buffered: '0.00',
      };
    }
    return {
      paused: !!player.paused,
      currentTime: formatNumber(player.currentTime),
      duration: formatNumber(player.duration),
      buffered: formatNumber(player.buffered),
    };
  },

  refreshPanelState(key) {
    const runtime = this.panels[key];
    const snapshot = this.snapshotPanelState(key);
    this.updatePanelViewState(key, {
      actionLabel: runtime.player ? 'Stop and Reset' : 'Start Playback',
      ...snapshot,
      playerCreated: !!runtime.player,
      sourceLoaded: !!runtime.sourceBytes,
      autoStreaming: !!runtime.timer,
      chunksAppended: runtime.chunksAppended,
      totalChunks: runtime.totalChunks,
      bytesAppended: formatBytes(runtime.bytesAppended),
    });
  },

  async ensureSourceBytes(key) {
    const runtime = this.panels[key];
    if (runtime.sourceBytes) {
      return runtime.sourceBytes;
    }

    const buffer = await PANEL_CONFIG[key].assetBlob.arrayBuffer();
    runtime.sourceBytes = new Uint8Array(buffer);
    runtime.loopStartOffset = isOggOpusKey(key)
      ? findOggOpusLoopStartOffset(runtime.sourceBytes)
      : 0;
    runtime.totalChunks = Math.ceil(runtime.sourceBytes.length / PANEL_CONFIG[key].chunkSize);
    this.updatePanelViewState(key, {
      sourceLoaded: true,
      totalChunks: runtime.totalChunks,
    });
    return runtime.sourceBytes;
  },

  createPlayerInternal(key) {
    const runtime = this.panels[key];
    if (runtime.player) {
      return runtime.player;
    }

    const player = new AudioPlayer(PANEL_CONFIG[key].createOptions);
    runtime.player = player;
    this.updatePanelViewState(key, {
      playerCreated: true,
    });
    this.clearPanelError(key);
    this.refreshPanelState(key);
    return player;
  },

  stopPanelTimer(key) {
    const runtime = this.panels[key];
    if (runtime.timer) {
      clearInterval(runtime.timer);
      runtime.timer = null;
      this.updatePanelViewState(key, { autoStreaming: false });
    }
  },

  async appendNextChunkInternal(key) {
    const runtime = this.panels[key];
    if (!runtime.player) {
      throw new Error('Create Player before append');
    }

    const sourceBytes = await this.ensureSourceBytes(key);
    if (!sourceBytes.length) {
      throw new Error('Fixture has no audio bytes');
    }
    if (runtime.offset >= sourceBytes.length) {
      runtime.offset = isOggOpusKey(key) ? runtime.loopStartOffset : 0;
      if (runtime.offset >= sourceBytes.length) {
        throw new Error('Loop start offset is outside the Ogg/Opus fixture');
      }
    }

    const chunkSize = PANEL_CONFIG[key].chunkSize;
    const nextOffset = Math.min(runtime.offset + chunkSize, sourceBytes.length);
    const chunk = sourceBytes.slice(runtime.offset, nextOffset);
    runtime.player.append(chunk);
    runtime.offset = nextOffset;
    runtime.chunksAppended += 1;
    runtime.bytesAppended += chunk.byteLength;
    this.clearPanelError(key);
    this.refreshPanelState(key);
  },

  async startStreamingInternal(key) {
    const runtime = this.panels[key];
    if (runtime.player || runtime.timer) {
      throw new Error('Streaming is already active');
    }

    const player = this.createPlayerInternal(key);
    await this.ensureSourceBytes(key);
    await this.appendNextChunkInternal(key);
    player.play();
    this.clearPanelError(key);
    this.refreshPanelState(key);

    const timer = setInterval(async () => {
      const currentRuntime = this.panels[key];
      if (currentRuntime.timer !== timer) {
        return;
      }
      try {
        await this.appendNextChunkInternal(key);
      } catch (error) {
        this.stopPanelTimer(key);
        this.setPanelError(key, getErrorMessage(error));
      }
    }, PANEL_CONFIG[key].appendIntervalMs);
    runtime.timer = timer;
    this.refreshPanelState(key);
  },

  async togglePanelAction(event) {
    const key = getPanelKeyFromEvent(event);
    const runtime = this.panels[key];
    if (runtime.player || runtime.timer) {
      this.destroyPanelInternal(key, false);
      this.clearPanelError(key);
      return;
    }

    try {
      await this.startStreamingInternal(key);
    } catch (error) {
      this.setPanelError(key, getErrorMessage(error));
      this.refreshPanelState(key);
    }
  },

  destroyPanelInternal(key, withError = true) {
    const runtime = this.panels[key];
    this.stopPanelTimer(key);
    if (runtime.player) {
      try {
        runtime.player.destroy();
      } catch (error) {
        if (withError) {
          this.setPanelError(key, getErrorMessage(error));
        }
      }
    }

    const preservedSourceBytes = runtime.sourceBytes;
    const preservedLoopStartOffset = runtime.loopStartOffset;
    const preservedTotalChunks = runtime.totalChunks;
    this.panels[key] = createPanelRuntime();
    this.panels[key].sourceBytes = preservedSourceBytes;
    this.panels[key].loopStartOffset = preservedLoopStartOffset;
    this.panels[key].totalChunks = preservedTotalChunks;

    this.updatePanelViewState(key, {
      ...createPanelViewState(key),
      sourceLoaded: !!preservedSourceBytes,
      totalChunks: preservedTotalChunks,
    });
  },
};
</script>

<page>
  <view class="container">
    <view class="page-title">Audio Streaming Test</view>
    <view class="subtitle">
      Manual regression page for AudioPlayer streaming playback with local PCM and Ogg/Opus fixtures.
    </view>

    <card class="panel-card">
      <text class="section-title">{{pcmPanel.title}}</text>
      <text class="meta-line">Asset: {{pcmPanel.assetPath}}</text>
      <text class="meta-line">MIME / Size: {{pcmPanel.assetMimeType}} / {{pcmPanel.assetSize}}</text>
      <text class="meta-line">Format: {{pcmPanel.format}} · Chunk: {{pcmPanel.chunkSize}} · Interval: {{pcmPanel.appendIntervalMs}}</text>
      <text class="meta-line">Player Created: {{pcmPanel.playerCreated}} · Source Loaded: {{pcmPanel.sourceLoaded}} · Auto Streaming: {{pcmPanel.autoStreaming}}</text>
      <text class="meta-line">Chunks: {{pcmPanel.chunksAppended}} / {{pcmPanel.totalChunks}} · Bytes: {{pcmPanel.bytesAppended}}</text>
      <text class="meta-line">Paused: {{pcmPanel.paused}} · Current Time: {{pcmPanel.currentTime}} · Duration: {{pcmPanel.duration}} · Buffered: {{pcmPanel.buffered}}</text>
      <text class="meta-line">Last Error: {{pcmPanel.lastError || 'None'}}</text>
      <view class="action-row" role="navigation">
        <button bindtap="togglePanelAction" data-panel="pcm">{{pcmPanel.actionLabel}}</button>
      </view>
    </card>

    <card class="panel-card" style="margin-bottom: 20px;">
      <text class="section-title">{{opusPanel.title}}</text>
      <text class="meta-line">Asset: {{opusPanel.assetPath}}</text>
      <text class="meta-line">MIME / Size: {{opusPanel.assetMimeType}} / {{opusPanel.assetSize}}</text>
      <text class="meta-line">Format: {{opusPanel.format}} · Chunk: {{opusPanel.chunkSize}} · Interval: {{opusPanel.appendIntervalMs}}</text>
      <text class="meta-line">Player Created: {{opusPanel.playerCreated}} · Source Loaded: {{opusPanel.sourceLoaded}} · Auto Streaming: {{opusPanel.autoStreaming}}</text>
      <text class="meta-line">Chunks: {{opusPanel.chunksAppended}} / {{opusPanel.totalChunks}} · Bytes: {{opusPanel.bytesAppended}}</text>
      <text class="meta-line">Paused: {{opusPanel.paused}} · Current Time: {{opusPanel.currentTime}} · Duration: {{opusPanel.duration}} · Buffered: {{opusPanel.buffered}}</text>
      <text class="meta-line">Last Error: {{opusPanel.lastError || 'None'}}</text>
      <view class="action-row" role="navigation">
        <button bindtap="togglePanelAction" data-panel="ogg_opus">{{opusPanel.actionLabel}}</button>
      </view>
    </card>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    padding: 24px;
    gap: 16px;
    background-color: var(--color-background);
  }

  .page-title {
    font-size: 28px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .subtitle {
    font-size: 14px;
    color: var(--color-text-secondary);
  }

  .panel-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 16px;
    border-radius: var(--radius-md, 12px);
    background-color: var(--color-surface);
    border: var(--border-width-thin, 1px) solid var(--border-color-default, #d1d5db);
  }
  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: var(--color-text-primary);
  }

  .meta-line {
    font-size: 14px;
    color: var(--color-text-primary);
    font-family: monospace;
  }

  .action-row {
    display: flex;
    flex-direction: row;
    gap: 12px;
  }
</style>
