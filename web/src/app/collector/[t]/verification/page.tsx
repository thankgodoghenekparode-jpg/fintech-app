import { CollectorPage } from '@/components/collector-page';
export default async function Page({ params }: { params: Promise<{ t: string }> }) { const { t } = await params; return <CollectorPage tenant={t} active="verification" title="Verification and team" description="Review organization verification and collector access." detail="Verification documents and team" />; }
