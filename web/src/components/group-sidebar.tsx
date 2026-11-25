import Link from 'next/link';
import { en } from '@/i18n/en';

const navigation = [
  ['dashboard', en.cooperative.overview, true],
  ['members', en.cooperative.members, true],
  ['join-requests', en.cooperative.joinRequests, true],
  ['contributions', en.cooperative.contributions, true],
  ['loan-applications', en.cooperative.loanApplications, true],
  ['loans', en.cooperative.loans, true],
  ['shares', en.cooperative.shares, true],
  ['rules', en.cooperative.rules, true],
  ['admins', en.cooperative.admins, true],
  ['reports', en.cooperative.reports, true],
  ['withdrawals', en.cooperative.withdrawals, true],
  ['hub', en.cooperative.hub, true],
  ['audit', en.cooperative.audit, false],
  ['verification', en.cooperative.verification, false],
] as const;

export function GroupSidebar({ tenant, active }: { tenant: string; active: string }) {
  return (
    <aside className="dashboard-sidebar" aria-label={en.cooperative.menu}>
      <Link className="dashboard-brand" href="/">{en.app.title}</Link>
      <p className="sidebar-label">{en.products.cooperatives}</p>
      <nav className="dashboard-nav">
        {navigation.map(([slug, label, implemented]) => slug === active ? (
          <Link
            aria-current="page"
            className="nav-link nav-link-active"
            href={'/group/' + encodeURIComponent(tenant) + '/' + slug}
            key={slug}
          >{label}</Link>
        ) : implemented ? (
          <Link className="nav-link" href={'/group/' + encodeURIComponent(tenant) + '/' + slug} key={slug}>
            {label}
          </Link>
        ) : (
          <span aria-disabled="true" className="nav-link nav-link-disabled" key={slug}>{label}</span>
        ))}
      </nav>
    </aside>
  );
}
