import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="items" title="Revenue items" description="Manage dues, levies, and collection schedules." detail="Revenue item registry" />; }
