import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="settlement" title="Settlement and fees" description="Review settlement batches, fees, and transfers." detail="Settlement history" />; }
