import wx from 'wx';

export default {
  onLoad() {
    const ctx = wx.createCanvasContext('myCanvas');
    ctx.setFillStyle('#111111');

    ctx.font = '700 22px sans-serif';
    ctx.fillText('Quarterly Report', 12, 34);

    ctx.font = '600 16px sans-serif';
    ctx.fillText('Performance overview', 12, 64);

    ctx.font = '400 14px sans-serif';
    ctx.fillText('Updated 2 minutes ago', 12, 90);

    ctx.font = '900 14px sans-serif';
    ctx.fillText('Action Needed', 12, 126);

    ctx.font = '400 13px sans-serif';
    ctx.fillText('Review the drops in conversion and reply volume.', 12, 150);

    ctx.draw();
  },
};
