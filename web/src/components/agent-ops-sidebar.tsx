import Link from 'next/link';
import { en } from '@/i18n/en';

const links = [
  ['/backoffice/agents', 'Agents and applications'],
  ['/backoffice/agents/float', 'Float and reconciliation'],
  ['/backoffice/agents/config', 'Commission and limits'],
] as const;

export function AgentOpsSidebar({ active }: { active: string }) {
  return (
    <aside className="dashboard-sidebar" aria-label="Agent operations menu">
      <Link className="dashboard-brand" href="/">{en.app.title}</Link>
      <p className="sidebar-label">Agent Network</p>
      <nav className="dashboard-nav">
        {links.map(([href, label]) => href === active ? (
          <Link aria-current="page" className="nav-link nav-link-active" href={href} key={href}>{label}</Link>
        ) : (
          <Link className="nav-link" href={href} key={href}>{label}</Link>
        ))}
      </nav>
    </aside>
  );
}
