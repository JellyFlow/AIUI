const SOURCES = ['./lottielogo.json', './watermelon.json'];
const SPEEDS = [0.5, 1, 1.75];

export default {
  data: {
    activeSrc: './lottielogo.json',
    autoplay: true,
    progress: '',
    speed: 1,
    previewStageClass: 'dark-stage',
  },
  onLoad() {
    this.syncPlaybackState();
  },
  syncPlaybackState(patch = {}) {
    const next = {
      ...this.data,
      ...patch,
    };
    const isLightArtwork = next.activeSrc.includes('lottielogo');

    this.setData({
      ...patch,
      previewStageClass: isLightArtwork ? 'dark-stage' : 'light-stage',
    });
  },
  toggleAutoplay() {
    this.syncPlaybackState({
      autoplay: !this.data.autoplay,
      progress: '',
    });
  },
  toggleProgress() {
    this.syncPlaybackState({
      progress: this.data.progress === '' ? 0.35 : '',
    });
  },
  toggleSource() {
    const currentIndex = SOURCES.indexOf(this.data.activeSrc);
    const nextIndex = (currentIndex + 1) % SOURCES.length;
    this.syncPlaybackState({
      activeSrc: SOURCES[nextIndex],
    });
  },
  cycleSpeed() {
    const currentIndex = SPEEDS.indexOf(this.data.speed);
    const nextIndex = (currentIndex + 1) % SPEEDS.length;
    this.syncPlaybackState({
      speed: SPEEDS[nextIndex],
    });
  },
};
