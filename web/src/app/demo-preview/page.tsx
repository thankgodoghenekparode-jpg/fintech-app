import Link from 'next/link';

const screenIds = [
  'W-AGT-001', 'W-AGT-002', 'W-AGT-003', 'W-AJO-001',
  ...Array.from({ length: 14 }, (_, index) => `W-COOP-${String(index + 1).padStart(3, '0')}`),
  ...Array.from({ length: 8 }, (_, index) => `W-REV-${String(index + 1).padStart(3, '0')}`),
];

export default function DemoPreviewGalleryPage() {
  return (
    <main style={{ maxWidth: 960, margin: '0 auto', padding: 24 }}>
      <h1>Supplied design previews</h1>
      <p role="status">
        Sample content only. These read-only screenshots do not show live account data or perform actions.
      </p>
      <ul>
        {screenIds.map((screenId) => (
          <li key={screenId}>
            <Link href={`/demo-preview/${screenId}`}>{screenId}</Link>
          </li>
        ))}
      </ul>
    </main>
  );
}
