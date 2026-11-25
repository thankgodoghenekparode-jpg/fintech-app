import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="payers" title="Payers registry" description="Review payer records and import a payer list." detail="Payer registry" />; }
