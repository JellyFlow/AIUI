export type ModuleTone = 'pass' | 'info';

export interface ModuleCase {
  title: string;
  detail: string;
  tone: ModuleTone;
}

const createCase = (title: string, detail: string, tone: ModuleTone = 'pass'): ModuleCase => ({
  title,
  detail,
  tone,
});

export const moduleCases: ModuleCase[] = [
  createCase(
    'extensionless import',
    'The page imports this file with ./cases and resolves cases.ts.',
  ),
  createCase(
    'type-only exports',
    'This helper exports interfaces and aliases that are erased before execution.',
  ),
  createCase(
    'typed helpers',
    'Annotated helper parameters and return values survive as plain JavaScript behavior.',
    'info',
  ),
];

export function summarizeCases(cases: ModuleCase[]): string {
  const readyCount = cases.filter((item: ModuleCase): boolean => item.tone === 'pass').length;
  return `${readyCount}/${cases.length} imported TypeScript module checks passed.`;
}
