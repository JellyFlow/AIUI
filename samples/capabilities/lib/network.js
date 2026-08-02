import wx from 'wx';

const TEST_SSE_URL =
  'https://js.rokid.com/api/v1/testing/sse/events?count=999&interval=1000&event=update&prefix=ink-network-lib';

export function testRequest() {
  const startTime = performance.now();
  wx.request({
    url: 'https://www.rokid.com',
    success: (res) => {
      console.info(res);
    },
    complete: () => {
      const endTime = performance.now();
      console.info(`request completed in ${endTime - startTime}ms`);
    },
  });
}

export function testSSE() {
  const es = wx.createEventSource({
    url: TEST_SSE_URL,
  });
  es.onOpen(() => {
    console.log('SSE Open');
  });
  es.onMessage((msg) => {
    console.log('SSE Message:', msg);
  });
  es.onError((err) => {
    console.log('SSE Error:', err);
  });
}
