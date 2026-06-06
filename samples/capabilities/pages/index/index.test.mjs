import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const appJsonPath = path.resolve(__dirname, '../../app.json');
const pageJsonPath = path.resolve(__dirname, './index.json');
const dataModulePath = path.resolve(__dirname, './index.data.js');
const wxmlPath = path.resolve(__dirname, './index.wxml');

const expectedGroupTitles = [
  'Layout & Basic',
  'Styling',
  'Graphics & Canvas',
  'Imaging & Barcode',
  'Networking',
  'Audio',
  'AI',
  'IMU',
  'Components & Other',
  'Input & Forms',
];

const expectedGroupLabels = [
  ['Layout', 'Row / Column', 'Size Constraints', 'Position', 'Grid', 'List'],
  [
    'Font Styling',
    'Font Weight',
    'Transform',
    'Filter',
    'Box Shadow',
    'Opacity',
    'Outline',
    'Transition and Animation',
    'CSS Variables',
    'Media Query',
  ],
  ['Canvas', 'Canvas API', 'Chart', 'Lottie'],
  ['Image APIs', 'Barcode Detector'],
  ['HTTPS', 'SSE', 'WebSocket'],
  ['Audio Player', 'Sound', 'Recorder'],
  ['Speech Recognition', 'Text To Speech', 'Chat'],
  ['Accelerometer', 'Gyroscope', 'Magnetometer', 'AbsoluteOrientationSensor', 'Compass'],
  [
    'A2UI',
    'Calendar',
    'Close',
    'Error State',
    'Storage',
    'Streamdown',
    'Open',
    'ESM Import',
    'Image',
  ],
  ['Input & Textarea', 'Switch'],
];

const expectedPaths = [
  '../layout/index',
  '../row_column/index',
  '../size_constraints/index',
  '../position/index',
  '../grid/index',
  '../list/index',
  '../font_styling/index',
  '../font_weight/index',
  '../transform/index',
  '../filter/index',
  '../box_shadow/index',
  '../opacity/index',
  '../outline/index',
  '../transition_animation/index',
  '../css_vars/index',
  '../media_query/index',
  '../canvas/index',
  '../canvas_api/index',
  '../chart/index',
  '../lottie/index',
  '../image_apis/index',
  '../barcode_detector/index',
  '../network_https/index',
  '../network_sse/index',
  '../network_websocket/index',
  '../audio/index',
  '../sound/index',
  '../recorder/index',
  '../speech/index',
  '../speech/index',
  '../llm/index',
  '../accelerometer/index',
  '../gyroscope/index',
  '../magnetometer/index',
  '../absolute-orientation-sensor/index',
  '../compass/index',
  '../a2ui/index',
  '../calendar/index',
  '../close/index',
  '../error_state/index',
  '../storage/index',
  '../streamdown/index',
  '../open/index',
  '../esm/index',
  '../image/index',
  '../input_textarea/index',
  '../switch/switch',
];

function loadIndexDataModule() {
  const source = fs.readFileSync(dataModulePath, 'utf8');
  const executableSource = source
    .replace(/export const /g, 'const ')
    .replace(/export function /g, 'function ');

  return new Function(
    `${executableSource}
return {
  navigationGroups,
  flattenNavigationItems,
  toRegisteredPagePath,
  createIndexPageData,
};
`,
  )();
}

const indexData = loadIndexDataModule();
const appConfig = JSON.parse(fs.readFileSync(appJsonPath, 'utf8'));
const pageConfig = JSON.parse(fs.readFileSync(pageJsonPath, 'utf8'));
const registeredPages = new Set(appConfig.pages);

test('Task7 首页恢复旧版分组标题与页面标题', () => {
  assert.deepEqual(
    indexData.navigationGroups.map((group) => group.title),
    expectedGroupTitles,
  );

  const pageData = indexData.createIndexPageData();
  assert.equal(pageData.title, 'Ink Simple Agent');
  assert.equal(pageData.hero, undefined);
  assert.equal(pageData.status, undefined);
  assert.equal(pageData.scrollComparison, undefined);
  assert.equal(pageConfig.navigationBarTitleText, 'Index Page');
});

test('Task7 首页恢复旧版按钮文案、顺序与连续 tabindex', () => {
  assert.deepEqual(
    indexData.navigationGroups.map((group) => group.items.map((item) => item.label)),
    expectedGroupLabels,
  );

  const items = indexData.flattenNavigationItems();
  const tabindexList = items.map((item) => item.tabindex);
  assert.deepEqual(
    items.map((item) => item.path),
    expectedPaths,
  );
  assert.deepEqual(
    tabindexList,
    Array.from({ length: expectedPaths.length }, (_, index) => index),
  );
  assert.equal(new Set(tabindexList).size, items.length);
});

test('Task7 首页跳转目标全部指向已注册 demo 页面', () => {
  for (const item of indexData.flattenNavigationItems()) {
    assert.equal(
      registeredPages.has(indexData.toRegisteredPagePath(item.path)),
      true,
      `${item.path} 未在 app.json 中注册`,
    );
  }
});

test('Task7 首页模板仅保留分组 card 与按钮导航', () => {
  const wxml = fs.readFileSync(wxmlPath, 'utf8');

  assert.match(wxml, /<card/);
  assert.match(wxml, />Layout &amp; Basic</);
  assert.match(wxml, /data-path="\.\.\/layout\/index" tabindex="0">Layout</);
  assert.match(wxml, /data-path="\.\.\/switch\/switch" tabindex="46">Switch</);
  assert.match(wxml, /bindtap="navigateToPage"/);
  assert.doesNotMatch(wxml, /ink:for="\{\{navigationGroups\}\}"/);
  assert.doesNotMatch(wxml, /ink:for="\{\{group\.items\}\}"/);
  assert.doesNotMatch(wxml, /\{\{group\./);
  assert.doesNotMatch(wxml, /scroll-view/);
  assert.doesNotMatch(wxml, /hero|status|scrollComparison/);
});
