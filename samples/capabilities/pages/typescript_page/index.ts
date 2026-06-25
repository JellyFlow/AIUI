type CheckTone = 'pass' | 'warn';

interface CheckItem {
  label: string;
  detail: string;
  tone: CheckTone;
}

interface TapEvent {
  currentTarget?: {
    attributes?: Record<string, string>;
  };
}

const buildCheck = (label: string, detail: string, ready: boolean): CheckItem => ({
  label,
  detail,
  tone: ready ? 'pass' : 'warn',
});

const initialChecks: CheckItem[] = [
  buildCheck('index.ts entry', 'Page script resolved without an index.js fallback.', true),
  buildCheck(
    'type erasure',
    'Interfaces, aliases, typed arrays, and returns were removed before QuickJS execution.',
    true,
  ),
  buildCheck(
    'runtime methods',
    'Typed event handlers still update page state through this.setData().',
    true,
  ),
];

export default {
  data: {
    title: 'TypeScript Page Entry',
    checks: initialChecks,
    selectedLabel: initialChecks[0]!.label,
    tapCount: 0,
    summary: `${initialChecks.length} TypeScript checks are ready.`,
  },

  selectCheck(e: TapEvent): void {
    const attributes = e.currentTarget?.attributes || {};
    const label = attributes['data-label'] || 'Unknown check';
    const nextCount = (this.data.tapCount as number) + 1;

    this.setData({
      selectedLabel: label,
      tapCount: nextCount,
      summary: `Selected ${label} after ${nextCount} tap(s).`,
    });
  },
};
