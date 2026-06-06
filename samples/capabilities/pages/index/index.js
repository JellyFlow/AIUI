import wx from 'wx';

export default {
  data: {
    title: 'Ink Simple Agent',
  },

  onLoad() {
    console.log('Index Page Load');
  },

  navigateToPage(e) {
    const attributes = (e && e.currentTarget && e.currentTarget.attributes) || {};
    const path = attributes['data-path'];

    if (!path) {
      return;
    }

    wx.navigateTo({ url: path });
  },
};
