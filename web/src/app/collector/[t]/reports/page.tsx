import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="reports" title="Revenue reports" description="Select a report and review its date range and format." detail="Report history" />; }
