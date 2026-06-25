<script setup>
  export default {
    onLoad() {
      console.log('Colors page loaded');
    },
  };
</script>

<page>
  <view class="container">
    <view class="page-header">
      <text class="page-kicker">Commerce Palette</text>
      <text class="page-title">Colors</text>
      <text class="page-subtitle">
        Color expressions shown as real ecommerce surfaces: order states, merchandising signals, and urgency levels.
      </text>
    </view>

    <card class="section-card">
      <text class="section-kicker">Order &amp; Fulfillment</text>
      <text class="section-title">Status colors that operators scan in seconds</text>
      <text class="section-note">
        These cards map color directly to payment, picking, shipping, delivery, refund, and cancellation states instead of isolated swatches.
      </text>

      <view class="card-grid">
        <card class="business-card business-card-pending">
          <view class="tone-bar tone-bar-pending"></view>
          <text class="card-label">Order State</text>
          <text class="card-title">Pending Payment</text>
          <text class="card-copy">Orders reserved for 15 minutes before inventory is released back to the campaign pool.</text>
          <text class="value-chip">#D46B08</text>
        </card>

        <card class="business-card business-card-picking">
          <view class="tone-bar tone-bar-picking"></view>
          <text class="card-label">Warehouse Queue</text>
          <text class="card-title">Picking in Progress</text>
          <text class="card-copy">A fresh blue signal shows the parcel has entered the warehouse workflow and is actively being packed.</text>
          <text class="value-chip">rgb(24, 144, 255)</text>
        </card>

        <card class="business-card business-card-transit">
          <view class="tone-bar tone-bar-transit"></view>
          <text class="card-label">Delivery Route</text>
          <text class="card-title">In Transit</text>
          <text class="card-copy">Long-haul shipments use a cooler violet accent so they stay distinct from local warehouse activity.</text>
          <text class="value-chip">hsl(262 70% 55%)</text>
        </card>

        <card class="business-card business-card-delivered">
          <view class="tone-bar tone-bar-delivered"></view>
          <text class="card-label">Customer Success</text>
          <text class="card-title">Delivered</text>
          <text class="card-copy">A soft success green keeps the delivered state positive without shouting over the rest of the dashboard.</text>
          <text class="value-chip">rgba(82, 196, 26, 0.92)</text>
        </card>

        <card class="business-card business-card-refund">
          <view class="tone-bar tone-bar-refund"></view>
          <text class="card-label">After-sales</text>
          <text class="card-title">Refund Review</text>
          <text class="card-copy">Warm named colors work well for exceptions that need human attention but are not yet hard failures.</text>
          <text class="value-chip">orangered</text>
        </card>

        <card class="business-card business-card-cancelled">
          <view class="tone-bar tone-bar-cancelled"></view>
          <text class="card-label">Order Closure</text>
          <text class="card-title">Cancelled</text>
          <text class="card-copy">Muted neutral treatments keep closed orders visible in history views without pulling focus from active work.</text>
          <text class="value-chip">灰色</text>
        </card>
      </view>
    </card>

    <card class="section-card">
      <text class="section-kicker">Growth &amp; Merchandising</text>
      <text class="section-title">Campaign colors that feel tied to real inventory and offers</text>
      <text class="section-note">
        The same parser also drives promotion cards, stock health, member perks, and budget highlights across an operating surface.
      </text>

      <view class="card-grid">
        <card class="business-card business-card-flash-sale">
          <view class="tone-bar tone-bar-flash-sale"></view>
          <text class="card-label">Campaign Heat</text>
          <text class="card-title">Flash Sale Live</text>
          <text class="card-copy">A direct named color keeps this hero state unmistakable when the team is watching minute-by-minute sell-through.</text>
          <text class="value-chip">red</text>
        </card>

        <card class="business-card business-card-low-stock">
          <view class="tone-bar tone-bar-low-stock"></view>
          <text class="card-label">Inventory Alert</text>
          <text class="card-title">Only 18 Units Left</text>
          <text class="card-copy">Scarcity sits on a red-leaning alert card, but the copy still carries the actual message instead of color alone.</text>
          <text class="value-chip">#FF4D4F</text>
        </card>

        <card class="business-card business-card-member">
          <view class="tone-bar tone-bar-member"></view>
          <text class="card-label">VIP Segment</text>
          <text class="card-title">Member Exclusive Drop</text>
          <text class="card-copy">A darker premium surface lets the highlight feel like a benefit tier instead of a system warning.</text>
          <text class="value-chip">紫色</text>
        </card>

        <card class="business-card business-card-subsidy">
          <view class="tone-bar tone-bar-subsidy"></view>
          <text class="card-label">Budget Efficiency</text>
          <text class="card-title">Platform Subsidy Active</text>
          <text class="card-copy">A semitransparent teal halo helps the subsidy module layer above neutral cards without becoming another warning state.</text>
          <text class="value-chip">hsla(187 85% 43% / 0.82)</text>
        </card>

        <card class="business-card business-card-new-user">
          <view class="tone-bar tone-bar-new-user"></view>
          <text class="card-label">Acquisition</text>
          <text class="card-title">New User Coupon</text>
          <text class="card-copy">Fresh green works well for onboarding incentives because it reads like forward progress, not just discount noise.</text>
          <text class="value-chip">绿色</text>
        </card>

        <card class="business-card business-card-restock">
          <view class="tone-bar tone-bar-restock"></view>
          <text class="card-label">Supply Signal</text>
          <text class="card-title">Restock Tonight</text>
          <text class="card-copy">Cool cyan is used for informational supply updates that should feel reassuring instead of urgent.</text>
          <text class="value-chip">cyan</text>
        </card>
      </view>
    </card>

    <card class="section-card">
      <text class="section-kicker">Equivalent Expressions</text>
      <text class="section-title">One urgent business meaning, multiple valid color strings</text>
      <text class="section-note">
        Each card below represents the same emergency restock moment, but the highlight is written with a different color expression.
      </text>

      <view class="compare-grid">
        <card class="compare-card compare-card-name">
          <text class="compare-label">Named Color</text>
          <view class="compare-accent compare-accent-name"></view>
          <text class="compare-title">Emergency Restock</text>
          <text class="compare-copy">Escalate replenishment before the livestream slot opens.</text>
          <text class="compare-chip">red</text>
        </card>

        <card class="compare-card compare-card-hex">
          <text class="compare-label">Hex</text>
          <view class="compare-accent compare-accent-hex"></view>
          <text class="compare-title">Emergency Restock</text>
          <text class="compare-copy">Escalate replenishment before the livestream slot opens.</text>
          <text class="compare-chip">#FF0000</text>
        </card>

        <card class="compare-card compare-card-rgb">
          <text class="compare-label">RGB</text>
          <view class="compare-accent compare-accent-rgb"></view>
          <text class="compare-title">Emergency Restock</text>
          <text class="compare-copy">Escalate replenishment before the livestream slot opens.</text>
          <text class="compare-chip">rgb(255, 0, 0)</text>
        </card>

        <card class="compare-card compare-card-hsl">
          <text class="compare-label">HSL</text>
          <view class="compare-accent compare-accent-hsl"></view>
          <text class="compare-title">Emergency Restock</text>
          <text class="compare-copy">Escalate replenishment before the livestream slot opens.</text>
          <text class="compare-chip">hsl(0 100% 50%)</text>
        </card>

        <card class="compare-card compare-card-zh">
          <text class="compare-label">Chinese Alias</text>
          <view class="compare-accent compare-accent-zh"></view>
          <text class="compare-title">Emergency Restock</text>
          <text class="compare-copy">Escalate replenishment before the livestream slot opens.</text>
          <text class="compare-chip">红色</text>
        </card>
      </view>
    </card>
  </view>
</page>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: 18px;
    padding: 18px;
  }

  .page-header {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .page-kicker {
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
  }

  .page-title {
    font-size: 30px;
    font-weight: 700;
  }

  .page-subtitle {
    font-size: 14px;
    line-height: 20px;
  }

  .section-card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: 16px;
    border-radius: 18px;
    border: 1px solid #b9d9bf;
  }

  .section-kicker {
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.8px;
    text-transform: uppercase;
  }

  .section-title {
    font-size: 20px;
    font-weight: 700;
  }

  .section-note {
    font-size: 13px;
    line-height: 19px;
  }

  .card-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .business-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    min-height: 148px;
    padding: 14px;
    border-radius: 16px;
    border: 1px solid #b9d9bf;
  }

  .tone-bar {
    width: 44px;
    height: 6px;
    border-radius: 999px;
    margin-bottom: 2px;
  }

  .card-label,
  .compare-label {
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.6px;
    text-transform: uppercase;
  }

  .card-title,
  .compare-title {
    font-size: 18px;
    font-weight: 700;
    line-height: 24px;
  }

  .card-copy,
  .compare-copy {
    font-size: 13px;
    line-height: 18px;
  }

  .value-chip,
  .compare-chip {
    align-self: flex-start;
    margin-top: 10px;
    padding: 6px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
    border: 1px solid #8bc79a;
  }

  .business-card-pending {
    border-color: #b9d9bf;
  }

  .tone-bar-pending {
    background-color: #d46b08;
  }

  .business-card-picking {
    border-color: #b9d9bf;
  }

  .tone-bar-picking {
    background-color: rgb(24, 144, 255);
  }

  .business-card-transit {
    border-color: #b9d9bf;
  }

  .tone-bar-transit {
    background-color: hsl(262 70% 55%);
  }

  .business-card-delivered {
    border-color: #b9d9bf;
  }

  .tone-bar-delivered {
    background-color: rgba(82, 196, 26, 0.92);
  }

  .business-card-refund {
    border-color: #b9d9bf;
  }

  .tone-bar-refund {
    background-color: orangered;
  }

  .business-card-cancelled {
    border-color: #b9d9bf;
  }

  .tone-bar-cancelled {
    background-color: 灰色;
  }

  .business-card-flash-sale {
    border-color: #b9d9bf;
  }

  .tone-bar-flash-sale {
    background-color: red;
  }

  .business-card-low-stock {
    border-color: #b9d9bf;
  }

  .tone-bar-low-stock {
    background-color: #ff4d4f;
  }

  .business-card-member {
    border-color: #b9d9bf;
  }

  .tone-bar-member {
    background-color: 紫色;
  }

  .business-card-subsidy {
    border-color: #b9d9bf;
  }

  .tone-bar-subsidy {
    background-color: hsla(187 85% 43% / 0.82);
  }

  .business-card-new-user {
    border-color: #b9d9bf;
  }

  .tone-bar-new-user {
    background-color: 绿色;
  }

  .business-card-restock {
    border-color: #b9d9bf;
  }

  .tone-bar-restock {
    background-color: cyan;
  }

  .compare-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .compare-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    min-height: 136px;
    padding: 14px;
    border-radius: 16px;
    border: 1px solid #b9d9bf;
  }

  .compare-accent {
    width: 52px;
    height: 8px;
    border-radius: 999px;
  }

  .compare-accent-name {
    background-color: red;
  }

  .compare-accent-hex {
    background-color: #ff0000;
  }

  .compare-accent-rgb {
    background-color: rgb(255, 0, 0);
  }

  .compare-accent-hsl {
    background-color: hsl(0 100% 50%);
  }

  .compare-accent-zh {
    background-color: 红色;
  }

  @media (max-width: 480px) {
    .card-grid,
    .compare-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
