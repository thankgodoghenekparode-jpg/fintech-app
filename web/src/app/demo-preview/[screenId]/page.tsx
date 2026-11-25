import { notFound } from 'next/navigation';
import Link from 'next/link';
import { DesignActionFrame } from '../DesignActionFrame';

const screenIds = new Set([
  'W-AGT-001', 'W-AGT-002', 'W-AGT-003', 'W-AJO-001',
  ...Array.from({ length: 14 }, (_, index) => `W-COOP-${String(index + 1).padStart(3, '0')}`),
  ...Array.from({ length: 8 }, (_, index) => `W-REV-${String(index + 1).padStart(3, '0')}`),
]);

export default async function DemoPreviewPage({
  params,
  searchParams,
}: {
  params: Promise<{ screenId: string }>;
  searchParams: Promise<{ from?: string }>;
}) {
  const [{ screenId }, { from }] = await Promise.all([params, searchParams]);
  if (!screenIds.has(screenId)) notFound();

  return (
    <main style={{ maxWidth: 1280, margin: '0 auto', padding: 24 }}>
      <header
        role="status"
        style={{
          marginBottom: 20,
          padding: 16,
          border: '1px solid #d99a2b',
          borderRadius: 8,
          background: '#fff8e8',
          color: '#382700',
        }}
      >
        <strong>Design demo - sample content only. Controls respond locally; financial and admin actions are not sent.</strong>
        <div>{screenId}{from ? ` - source route: ${from}` : ''}</div>
      </header>
      <p><Link href="/demo-preview">Back to all design screens</Link></p>
      <DesignActionFrame screenId={screenId} />
    </main>
  );
}
