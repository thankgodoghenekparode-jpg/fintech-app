'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useRef } from 'react';

export function DesignActionFrame({ screenId }: { screenId: string }) {
  const [source, setSource] = useState<string>();
  const [error, setError] = useState(false);
  const router = useRouter();
  const frameRef = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    function handleMessage(event: MessageEvent) {
      if (event.source !== frameRef.current?.contentWindow) return;
      if (typeof event.data !== 'string' || !event.data.startsWith('design-demo-navigation:')) return;
      const destination = event.data.slice('design-demo-navigation:'.length);
      if (destination === 'back') {
        router.back();
      } else if (destination.startsWith('/')) {
        router.push(destination);
      } else if (destination === 'paid-history') {
        router.push('/demo-preview/W-REV-004?from=paid-history');
      } else if (destination === 'cancel-float-top-up') {
        router.push('/demo-preview/W-AGT-001?from=cancel-float-top-up');
      } else if (destination === 'more') {
        router.push('/demo-preview');
      }
    }
    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, [router]);

  useEffect(() => {
    let cancelled = false;
    Promise.all([
      fetch(`/design_html/${screenId}.html`).then((response) => {
        if (!response.ok) throw new Error('Could not load design');
        return response.text();
      }),
      fetch('/demo-actions.js').then((response) => {
        if (!response.ok) throw new Error('Could not load demo interactions');
        return response.text();
      }),
    ]).then(([html, runtime]) => {
      if (cancelled) return;
      const responsive = screenId.startsWith('W-')
        ? '<style>html,body{max-width:100%;overflow-x:auto!important}img,video,canvas,svg{max-width:100%;height:auto}@media(max-width:900px){body{min-width:960px!important;overflow-x:visible!important}}</style>'
        : '';
      const tag = `${responsive}<script>window.__designDemoScreenId=${JSON.stringify(screenId)};</script><script>${runtime.replace(/<\/script/gi, '<\\/script')}</script>`;
      const bodyEnd = html.toLowerCase().lastIndexOf('</body>');
      setSource(bodyEnd < 0 ? `${html}${tag}` : `${html.slice(0, bodyEnd)}${tag}${html.slice(bodyEnd)}`);
    }).catch(() => {
      if (!cancelled) setError(true);
    });
    return () => { cancelled = true; };
  }, [screenId]);

  if (error) return <p role="alert">Could not load this supplied design preview. Refresh and try again.</p>;
  if (!source) return <p role="status">Loading supplied design…</p>;

  return (
    <iframe
      ref={frameRef}
      title={`${screenId} supplied design screen`}
      srcDoc={source}
      sandbox="allow-scripts allow-forms"
      style={{ width: '100%', height: 'calc(100dvh - 190px)', minHeight: 'min(480px, calc(100dvh - 190px))', border: 0, background: '#fff', pointerEvents: 'auto', touchAction: 'manipulation' }}
    />
  );
}
