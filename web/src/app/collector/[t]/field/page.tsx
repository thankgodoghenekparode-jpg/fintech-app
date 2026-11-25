import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="field" title="Field collectors and cash" description="Review collector assignments and field cash submissions." detail="Field collector activity" />; }
