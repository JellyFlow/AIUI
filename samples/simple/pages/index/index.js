import wx from 'wx';

export default {
  data: {
    list: [
      { isHeader: true, name: 'Layout & Basic' },
      { name: 'Layout', path: '../layout/index' },
      { name: 'Row / Column', path: '../row_column/index' },
      { name: 'Size Constraints', path: '../size_constraints/index' },
      { name: 'Position', path: '../position/index' },
      { name: 'Grid', path: '../grid/index' },
      { name: 'List', path: '../list/index' },
      { isHeader: true, name: 'Styling' },
      { name: 'Font Styling', path: '../font_styling/index' },
      { name: 'Font Weight', path: '../font_weight/index' },
      { name: 'Transform', path: '../transform/index' },
      { name: 'Filter', path: '../filter/index' },
      { name: 'Box Shadow', path: '../box_shadow/index' },
      { name: 'Opacity', path: '../opacity/index' },
      { name: 'Outline', path: '../outline/index' },
      { name: 'Transition and Animation', path: '../transition_animation/index' },
      { name: 'CSS Variables', path: '../css_vars/index' },
      { name: 'Media Query', path: '../media_query/index' },
      { isHeader: true, name: 'Graphics & Canvas' },
      { name: 'Canvas', path: '../canvas/index' },
      { name: 'Canvas API', path: '../canvas_api/index' },
      { name: 'Audio', path: '../audio/index' },
      { name: 'Chart', path: '../chart/index' },
      { name: 'Lottie', path: '../lottie/index' },
      { isHeader: true, name: 'Components & Other' },
      { name: 'A2UI', path: '../a2ui/index' },
      { name: 'Calendar', path: '../calendar/index' },
      { name: 'Error State', path: '../error_state/index' },
      { name: 'Streamdown', path: '../streamdown/index' },
      { name: 'Open', path: '../open/index' },
      { name: 'Image', path: '../image/index' },
      { isHeader: true, name: 'Input & Forms' },
      { name: 'Input & Textarea', path: '../input_textarea/index' },
      { name: 'Switch', path: '../switch/switch' },
    ],
  },
  onLoad: function () {
    console.log('Index Page Load');
  },
  navigateToPage: function (e) {
    const path = e.currentTarget.attributes['data-path'];
    if (path) {
      wx.navigateTo({ url: path });
    }
  },
};
