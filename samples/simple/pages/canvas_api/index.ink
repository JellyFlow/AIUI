<script type="application/json" def>
{
  "schema": {
    "data": {}
  }
}
</script>

<script setup>
import wx from 'wx';

export default {
  onShow() {
    try {
      this.draw();
    } catch (err) {
      console.error('failed to draw', err.message || err);
      console.error(err.stack);
    }
  },

  draw() {
    const ctx = wx.createCanvasContext('apiCanvas');
    if (!ctx) return;

    // 1. 测试 clearRect
    ctx.fillStyle = '#f0f0f0';
    ctx.fillRect(0, 0, 400, 1400);
    ctx.clearRect(50, 50, 100, 100); // 在灰色背景上清除一个方块

    // 2. 测试路径和基础样式 (strokeStyle, lineWidth, lineCap, lineJoin)
    ctx.beginPath();
    ctx.strokeStyle = 'red';
    ctx.lineWidth = 10;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'bevel';
    ctx.moveTo(20, 150);
    ctx.lineTo(100, 150);
    ctx.lineTo(100, 200);
    ctx.stroke();

    ctx.beginPath();
    ctx.strokeStyle = 'blue';
    ctx.lineWidth = 15;
    ctx.lineCap = 'square';
    ctx.lineJoin = 'round';
    ctx.moveTo(150, 150);
    ctx.lineTo(230, 150);
    ctx.lineTo(230, 200);
    ctx.stroke();

    // 3. 测试 quadraticCurveTo
    ctx.beginPath();
    ctx.strokeStyle = 'green';
    ctx.lineWidth = 5;
    ctx.moveTo(20, 250);
    ctx.quadraticCurveTo(100, 200, 180, 250);
    ctx.stroke();

    // 4. 测试 bezierCurveTo
    ctx.beginPath();
    ctx.strokeStyle = 'purple';
    ctx.moveTo(20, 350);
    ctx.bezierCurveTo(20, 300, 180, 400, 180, 350);
    ctx.stroke();

    // 5. 测试 rect() 和 fillStyle
    ctx.beginPath();
    ctx.fillStyle = 'orange';
    ctx.rect(20, 450, 100, 50);
    ctx.fill();
    ctx.strokeStyle = 'black';
    ctx.lineWidth = 2;
    ctx.stroke();

    // 6. 测试 arc() 和 closePath
    ctx.beginPath();
    ctx.fillStyle = 'cyan';
    ctx.arc(250, 475, 40, 0, Math.PI * 1.5);
    ctx.closePath(); // 闭合路径，形成扇形到圆心的连线（如果用了 moveTo 到圆心的话）
    ctx.fill();
    ctx.stroke();

    // 7. 测试多种 lineJoin
    const lineJoins = ['round', 'bevel', 'miter'];
    ctx.lineWidth = 20;
    ctx.strokeStyle = 'black';
    for (let i = 0; i < lineJoins.length; i++) {
      ctx.lineJoin = lineJoins[i];
      ctx.beginPath();
      ctx.moveTo(20, 550 + i * 50);
      ctx.lineTo(70, 600 + i * 50);
      ctx.lineTo(120, 550 + i * 50);
      ctx.stroke();
    }

    this.drawPath2DAndMatrixAPI(ctx);
  },

  drawPath2DAndMatrixAPI(ctx) {
    const sectionTop = 760;

    ctx.fillStyle = '#222';
    ctx.font = '20px Arial';
    ctx.fillText('Path2D / DOMMatrix API', 20, sectionTop);

    const badgeY = sectionTop + 30;
    const badgeHeight = 26;
    const matrixReadonly = new DOMMatrixReadOnly(1, 0, 0, 1, 12, 18);
    const matrix = new DOMMatrix(1, 0, 0, 1, 0, 0);
    const matrixArray = Array.from(matrix.toFloat32Array());
    const readonlyOk = matrix instanceof DOMMatrixReadOnly;
    const readonlyCtorOk = matrixReadonly.e === 12 && matrixReadonly.f === 18;

    matrix.translateSelf(30, 10);
    matrix.scaleSelf(1.1, 1.1);
    matrix.rotateSelf(8);

    ctx.fillStyle = readonlyOk ? '#d9f7be' : '#ffd6e7';
    ctx.fillRect(20, badgeY, 150, badgeHeight);
    ctx.fillStyle = '#222';
    ctx.font = '14px Arial';
    ctx.fillText(`instanceof readonly: ${readonlyOk}`, 28, badgeY + 18);

    ctx.fillStyle = readonlyCtorOk ? '#d9f7be' : '#ffd6e7';
    ctx.fillRect(190, badgeY, 170, badgeHeight);
    ctx.fillStyle = '#222';
    ctx.fillText(`readonly ctor: ${readonlyCtorOk}`, 198, badgeY + 18);

    const basePath = new Path2D();
    basePath.moveTo(60, sectionTop + 140);
    basePath.lineTo(95, sectionTop + 70);
    basePath.lineTo(130, sectionTop + 140);
    basePath.lineTo(40, sectionTop + 98);
    basePath.lineTo(150, sectionTop + 98);
    basePath.closePath();

    ctx.fillStyle = '#ffcc00';
    ctx.strokeStyle = '#996600';
    ctx.lineWidth = 3;
    ctx.fill(basePath);
    ctx.stroke(basePath);

    const svgPath = new Path2D('M190 860 C210 810 290 810 310 860 L285 910 L215 910 Z');
    const clonedPath = new Path2D(svgPath);

    ctx.fillStyle = '#7bdff2';
    ctx.strokeStyle = '#126782';
    ctx.fill(clonedPath);
    ctx.stroke(clonedPath);

    const compositePath = new Path2D();
    compositePath.addPath(basePath, matrix);

    ctx.strokeStyle = '#ff4d4f';
    ctx.lineWidth = 4;
    ctx.stroke(compositePath);

    const clipPath = new Path2D();
    clipPath.rect(20, sectionTop + 200, 120, 100);
    clipPath.roundRect(150, sectionTop + 200, 120, 100, 20);

    ctx.save();
    ctx.clip(clipPath);
    ctx.fillStyle = '#e6f4ff';
    ctx.fillRect(20, sectionTop + 200, 250, 100);
    ctx.strokeStyle = '#1677ff';
    ctx.lineWidth = 8;
    for (let i = 0; i < 6; i++) {
      ctx.beginPath();
      ctx.moveTo(10 + i * 50, sectionTop + 300);
      ctx.lineTo(90 + i * 50, sectionTop + 200);
      ctx.stroke();
    }
    ctx.restore();

    ctx.strokeStyle = '#444';
    ctx.lineWidth = 1;
    ctx.strokeRect(20, sectionTop + 200, 120, 100);
    ctx.strokeRect(150, sectionTop + 200, 120, 100);

    const hitFill = ctx.isPointInPath(basePath, 90, sectionTop + 105);
    const hitStroke = ctx.isPointInStroke(basePath, 95, sectionTop + 70);

    const originalTransform = ctx.getTransform();
    ctx.setTransform(new DOMMatrix(1, 0, 0, 1, 240, 1040));
    ctx.fillStyle = '#52c41a';
    ctx.fillRect(0, 0, 40, 40);
    const translatedTransform = ctx.getTransform();
    ctx.setTransform(originalTransform);

    const inverse = new DOMMatrix(
      translatedTransform.a,
      translatedTransform.b,
      translatedTransform.c,
      translatedTransform.d,
      translatedTransform.e,
      translatedTransform.f
    );
    inverse.invertSelf();

    const pathString = basePath.toString();
    const pathPreview = pathString.length > 48 ? `${pathString.slice(0, 48)}...` : pathString;

    ctx.fillStyle = '#222';
    ctx.font = '14px Arial';
    ctx.fillText(`fill hit: ${hitFill}`, 20, sectionTop + 340);
    ctx.fillText(`stroke hit: ${hitStroke}`, 120, sectionTop + 340);
    ctx.fillText(`matrix array len: ${matrixArray.length}`, 230, sectionTop + 340);
    ctx.fillText(
      `getTransform e/f: ${translatedTransform.e.toFixed(0)}, ${translatedTransform.f.toFixed(0)}`,
      20,
      sectionTop + 365
    );
    ctx.fillText(
      `inverse e/f: ${inverse.e.toFixed(2)}, ${inverse.f.toFixed(2)}`,
      20,
      sectionTop + 390
    );
    ctx.fillText(`Path2D.toString(): ${pathPreview}`, 20, sectionTop + 415);

    console.log('Path2D svg path:', pathString);
    console.log('DOMMatrix instanceof DOMMatrixReadOnly:', readonlyOk);
    console.log('DOMMatrixReadOnly ctor values:', matrixReadonly.e, matrixReadonly.f);
    console.log('isPointInPath / isPointInStroke:', hitFill, hitStroke);
    console.log(
      'translated transform:',
      translatedTransform.a,
      translatedTransform.b,
      translatedTransform.c,
      translatedTransform.d,
      translatedTransform.e,
      translatedTransform.f
    );
  }
}
</script>

<page>
  <view class="container">
    <view class="page-title">Canvas API</view>
    <view class="card">
      <canvas id="apiCanvas" width="400" height="1400" class="canvas"></canvas>
    </view>
  </view>
</page>

<style>
.container {
  --canvas-api-page-background: var(--color-background);
  --canvas-api-surface-background: var(--color-surface);
  --canvas-api-text-color: var(--color-text-primary);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: var(--canvas-api-page-background);
}

.page-title,
.title {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 20px;
  color: var(--canvas-api-text-color);
}

.card {
  background-color: var(--canvas-api-surface-background);
}

.canvas {
  width: 400px;
  height: 1400px;
  border: var(--border-width-thin, 1px) solid var(--border-color-default, #ccc);
  background-color: var(--canvas-api-surface-background);
}
</style>
