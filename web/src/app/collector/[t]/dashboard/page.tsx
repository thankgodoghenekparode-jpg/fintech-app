import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="dashboard" title="Collector dashboard" description="Review collection performance and exceptions." detail="Collection activity" />; }
