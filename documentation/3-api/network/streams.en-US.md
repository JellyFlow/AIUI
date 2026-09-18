# Streams

Use the Streams API to process data as it arrives. It lets an application read, transform, or write chunks before the complete content is available, which is useful for large files, live text, and audio data.

When the whole result is small and needed at once, `response.json()`, `response.text()`, or `response.arrayBuffer()` is simpler.

## Read a Response in Chunks

The `body` of a `fetch()` response is a `ReadableStream`:

```javascript
const response = await fetch('https://example.com/stream');
const reader = response.body.getReader();

try {
  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    console.log('Received a chunk', value);
  }
} finally {
  reader.releaseLock();
}
```

Only one reader can lock a stream at a time. Call `releaseLock()` when reading is complete before other code obtains a reader.

## Create and Transform a Stream

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

A `ReadableStream` can carry strings, objects, or binary values; it is not limited to network bytes.

## Write to a Destination

```javascript
const destination = new WritableStream({
  async write(chunk) {
    await saveChunk(chunk);
  },
  close() {
    console.log('All chunks saved');
  }
});

const writer = destination.getWriter();
await writer.write('first');
await writer.write('second');
await writer.close();
```

Await the Promise returned by `write()` so the destination has time to process each chunk.

## Current Limitations

- `ReadableStream.tee()` is not supported and throws when called.
- Call `releaseLock()` when a reader or writer is no longer needed.
- `pipeTo()` supports `preventClose`, `preventAbort`, `preventCancel`, and `signal` options.

## API Reference

### `ReadableStream`

The constructor accepts an optional `underlyingSource` and queuing strategy. A source can implement `start(controller)`, `pull(controller)`, and `cancel(reason)`.

| Member | Description |
| --- | --- |
| `locked` | Whether a reader currently locks the stream. |
| `getReader()` | Obtains a reader. |
| `cancel(reason?)` | Cancels reading. |
| `pipeThrough(transform, options?)` | Returns a readable stream passing through a transform. |
| `pipeTo(destination, options?)` | Writes the data to a destination stream. |

A reader provides `read()`, `cancel()`, `releaseLock()`, and `closed`.

### `WritableStream`

Represents a destination that accepts chunks in order. Writers normally call `getWriter()` and use the returned writer to manage backpressure and lifecycle.

#### `new WritableStream(underlyingSink?, strategy?)`

Creates a writable stream. `underlyingSink` can implement `start(controller)`, `write(chunk, controller)`, `close()`, and `abort(reason)`; these callbacks may return Promises. `strategy` controls queuing and backpressure through `highWaterMark` and an optional `size(chunk)` function.

```javascript
const stream = new WritableStream({
  async write(chunk) {
    await saveChunk(chunk);
  },
  close() {
    console.log('All chunks written');
  },
  abort(reason) {
    console.error('Writing aborted', reason);
  },
});
```

#### `stream.locked`

A read-only `boolean` that is `true` while a writer locks the stream. Only one writer can lock a stream at a time.

#### `stream.getWriter()`

Returns a `WritableStreamDefaultWriter` and locks the stream to that writer. Calling it while the stream is already locked throws `TypeError`.

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

Returns `Promise<void>` and requests that the stream close after queued writes finish. Close a locked stream through `writer.close()`.

#### `stream.abort(reason?)`

Returns `Promise<void>`, aborts the stream, and passes the optional reason to the underlying sink. Abort a locked stream through `writer.abort()`.

### `WritableStreamDefaultWriter`

The standard writer returned by `stream.getWriter()`. It exclusively locks the stream until released and exposes write backpressure, completion, and failure state.

#### `writer.ready`

A read-only `Promise<void>` that resolves when the stream's internal queue has capacity. Await it before sustained writes to avoid ignoring backpressure.

#### `writer.closed`

A read-only `Promise<void>` that resolves when the stream closes successfully. It rejects if the stream errors or the writer releases its lock before the stream closes.

#### `writer.desiredSize`

A read-only `number | null` estimating the capacity remaining before the queue reaches its `highWaterMark`. A negative value means the queue exceeds its target capacity; it is `null` when the stream has errored.

#### `writer.write(chunk?)`

Queues one chunk and returns `Promise<void>`. The Promise resolves when the underlying sink accepts the chunk and rejects if writing fails or the stream can no longer accept writes.

```javascript
await writer.ready;
await writer.write(chunk);
```

#### `writer.close()`

Returns `Promise<void>` and requests that the stream close after queued writes finish. Do not write additional chunks after calling it.

#### `writer.abort(reason?)`

Returns `Promise<void>`, aborts the stream, discards unprocessed chunks, and passes the optional reason to the underlying sink.

#### `writer.releaseLock()`

Releases the writer's lock so other code can call `getWriter()`. Do not release the lock while a `write()` is pending. The writer can no longer operate on the stream after release.

### `TransformStream`

The constructor accepts a transformer implementing `start()`, `transform()`, and `flush()`. The instance receives input through `writable` and emits transformed output through `readable`.

### Queuing Strategies

`CountQueueingStrategy` measures the queue by chunk count. `ByteLengthQueueingStrategy` uses `byteLength`. Both accept a `highWaterMark` in their constructor options.
