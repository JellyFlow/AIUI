import { AudioPlayer } from 'audio';
const AUDIO_SRC = '../../assets/mixkit-arcade-retro-game-over-213.wav';

export default {
  data: {
    audioSrc: AUDIO_SRC,
    statusText: 'Ready to play',
    isPlaying: false,
    isSupported: true,
  },
  onLoad() {
    console.log('Audio test page loaded');

    if (typeof AudioPlayer === 'undefined') {
      this.setData({
        isSupported: false,
        statusText: 'AudioPlayer is not available in this runtime',
      });
      return;
    }

    this.player = new AudioPlayer();
    this.player.src = AUDIO_SRC;
    this.player.autoplay = false;
    this.player.loop = false;

    this.handleCanPlay = () => {
      this.setData({
        statusText: 'Audio is ready',
      });
    };

    this.handlePlay = () => {
      this.setData({
        isPlaying: true,
        statusText: 'Playing',
      });
    };

    this.handlePause = () => {
      this.setData({
        isPlaying: false,
        statusText: 'Paused',
      });
    };

    this.handleEnded = () => {
      this.setData({
        isPlaying: false,
        statusText: 'Playback finished',
      });
    };

    this.handleError = () => {
      this.setData({
        isPlaying: false,
        statusText: 'Failed to load audio',
      });
    };

    this.player.onCanplay(this.handleCanPlay);
    this.player.onPlay(this.handlePlay);
    this.player.onPause(this.handlePause);
    this.player.onEnded(this.handleEnded);
    this.player.onError(this.handleError);
  },
  startPlayback(fromBeginning = false) {
    if (!this.player) {
      return;
    }

    if (fromBeginning) {
      this.player.seek(0);
    }

    try {
      this.player.play();
    } catch (error) {
      console.error('Audio playback failed', error);
      this.setData({
        isPlaying: false,
        statusText: 'Playback failed to start',
      });
    }
  },
  playAudio() {
    this.startPlayback(false);
  },
  pauseAudio() {
    if (!this.player) {
      return;
    }
    this.player.pause();
  },
  replayAudio() {
    this.startPlayback(true);
  },
  onUnload() {
    if (!this.player) {
      return;
    }

    this.player.pause();
    this.player.offCanplay();
    this.player.offPlay();
    this.player.offPause();
    this.player.offEnded();
    this.player.offError();
    this.player.destroy();
    this.player = null;
  },
};
