# 数据流

Streams API 用于分段处理持续到达的数据。它可以让你在完整内容下载结束前就开始读取、转换或写入，适合大文件、实时文本和语音数据。

如果只需要一次读取完整结果，直接使用 `response.json()`、`response.text()` 或 `response.arrayBuffer()` 会更简单。

## 逐段读取响应

`fetch()` 的 `response.body` 是一个 `ReadableStream`：

```javascript
const response = await fetch('https://example.com/stream');
const reader = response.body.getReader();

try {
  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    console.log('收到一段数据', value);
  }
} finally {
  reader.releaseLock();
}
```

一个流同时只能被一个 reader 锁定。读取结束后调用 `releaseLock()`，其他代码才能继续获取 reader。

## 创建并转换数据流

```javascript
const source = new ReadableStream({
  start(controller) {
    controller.enqueue('hello');
    controller.enqueue('aiui');
    controller.close();
  }
});

const upperCase = new TransformStream({
  transform(chunk, controller) {
    controller.enqueue(chunk.toUpperCase());
  }
});

const reader = source.pipeThrough(upperCase).getReader();
console.log(await reader.read());
```

`ReadableStream` 可以传递字符串、对象或二进制数据，不限于网络字节。

## 写入目标

```javascript
const destination = new WritableStream({
  async write(chunk) {
    await saveChunk(chunk);
  },
  close() {
    console.log('全部写入完成');
  }
});

const writer = destination.getWriter();
await writer.write('first');
await writer.write('second');
await writer.close();
```

连续写入时应等待 `write()` 返回的 Promise，避免写入速度超过目标的处理速度。

## 当前限制

- `ReadableStream.tee()` 当前不支持，调用时会抛出异常。
- 使用 reader 或 writer 后，应在不再需要时调用 `releaseLock()`。
- `pipeTo()` 支持 `preventClose`、`preventAbort`、`preventCancel` 和 `signal` 选项。

## API Reference

### `ReadableStream`

构造函数接受可选的 `underlyingSource` 和队列策略。数据源可以实现 `start(controller)`、`pull(controller)`、`cancel(reason)`。

| 成员 | 说明 |
| --- | --- |
| `locked` | 流当前是否已被 reader 锁定。 |
| `getReader()` | 获取 reader。 |
| `cancel(reason?)` | 取消读取。 |
| `pipeThrough(transform, options?)` | 经过转换流后返回新的可读流。 |
| `pipeTo(destination, options?)` | 把数据写入目标流。 |

reader 提供 `read()`、`cancel()`、`releaseLock()` 和 `closed`。

### `WritableStream`

表示可按顺序写入数据段的目标。写入方通常通过 `getWriter()` 获得 writer，再使用 writer 处理背压和生命周期。

#### `new WritableStream(underlyingSink?, strategy?)`

创建可写流。`underlyingSink` 可实现 `start(controller)`、`write(chunk, controller)`、`close()` 和 `abort(reason)`；这些回调可返回 Promise。`strategy` 通过 `highWaterMark` 和可选的 `size(chunk)` 控制队列与背压。

```javascript
const stream = new WritableStream({
  async write(chunk) {
    await saveChunk(chunk);
  },
  close() {
    console.log('所有数据已写入');
  },
  abort(reason) {
    console.error('写入已中止', reason);
  },
});
```

#### `stream.locked`

只读的 `boolean`。当 writer 锁定流时为 `true`。同一时刻只能有一个 writer 锁定流。

#### `stream.getWriter()`

返回 `WritableStreamDefaultWriter`，并将流锁定给该 writer。流已被锁定时调用会抛出 `TypeError`。

```javascript
const writer = stream.getWriter();
try {
  await writer.write('first');
  await writer.write('second');
  await writer.close();
} finally {
  writer.releaseLock();
}
```

#### `stream.close()`

返回 `Promise<void>`，请求在已排队的写入完成后关闭流。已锁定的流应通过 `writer.close()` 关闭。

#### `stream.abort(reason?)`

返回 `Promise<void>`，中止流并将可选原因传给 underlying sink。已锁定的流应通过 `writer.abort()` 中止。

### `WritableStreamDefaultWriter`

由 `stream.getWriter()` 返回的标准 writer。它在存续期间独占流，并暴露写入背压、完成和失败状态。

#### `writer.ready`

只读的 `Promise<void>`。当流的内部队列还有容量时解析。大量连续写入前可等待它，避免无视背压。

#### `writer.closed`

只读的 `Promise<void>`。流成功关闭时解析，流出错或 writer 锁在关闭前被释放时拒绝。

#### `writer.desiredSize`

只读的 `number | null`，表示队列达到 `highWaterMark` 前的大致剩余容量。负值表示队列已超过目标容量；流出错时为 `null`。

#### `writer.write(chunk?)`

将一个数据段排入流，返回 `Promise<void>`。Promise 在 underlying sink 接受该数据段后解析，写入失败或流无法继续写入时拒绝。

```javascript
await writer.ready;
await writer.write(chunk);
```

#### `writer.close()`

返回 `Promise<void>`，请求在已排队的写入完成后关闭流。调用后不应再写入新数据。

#### `writer.abort(reason?)`

返回 `Promise<void>`，中止流、丢弃尚未处理的数据，并将可选原因传给 underlying sink。

#### `writer.releaseLock()`

释放 writer 对流的锁，使其他代码可以调用 `getWriter()`。存在未完成的 `write()` 时不应释放锁；释放后，该 writer 不能再操作流。

### `TransformStream`

构造函数接受实现 `start()`、`transform()`、`flush()` 的转换器。实例通过 `writable` 接收输入，通过 `readable` 输出转换结果。

### 队列策略

`CountQueueingStrategy` 按数据段数量计算队列大小；`ByteLengthQueueingStrategy` 按 `byteLength` 计算。两者都通过构造参数中的 `highWaterMark` 设置期望的队列容量。
