export default {
  onLaunch: function () {
    console.log('App Launch', this)
  },
  onKeyDown: function(event) {
    console.info('app keydown', event);
  },
  globalData: {
    hasLogin: false
  }
}
