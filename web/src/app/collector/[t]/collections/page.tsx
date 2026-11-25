import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="collections" title="Collections and reconciliation" description="Review payments, exceptions, and reconciliation state." detail="Collection records" />; }
