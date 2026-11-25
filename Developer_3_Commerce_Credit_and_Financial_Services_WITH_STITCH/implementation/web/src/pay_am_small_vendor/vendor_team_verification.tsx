import { useCallback, useEffect, useState } from "react";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  StatusChip,
  SurfaceCard,
} from "../components/ui";

export interface PasVendorTeamMember {
  readonly id: string;
  readonly name: string;
  readonly branchLabel?: string;
  readonly roleLabel: string;
  readonly accessScopeLabel?: string;
  readonly handoverAuthorizationLabel?: string;
  readonly lastActiveLabel?: string;
  readonly statusLabel: string;
  readonly statusTone?: "success" | "warning" | "error" | "neutral";
  readonly permissions?: readonly {
    readonly label: string;
    readonly value: string;
    readonly tone?: "success" | "warning" | "error" | "neutral";
  }[];
}
export interface PasVendorVerificationDocument {
  readonly id: string;
  readonly title: string;
  readonly referenceLabel?: string;
  readonly authorityLabel?: string;
  readonly statusLabel: string;
  readonly statusTone?: "success" | "warning" | "error" | "neutral";
  readonly detail?: string;
  readonly rejectionReason?: string;
}
export interface PasVendorTeamSnapshot {
  readonly businessStatusLabel?: string;
  readonly businessStatusTone?: "success" | "warning" | "error" | "neutral";
  readonly teamMembers: readonly PasVendorTeamMember[];
  readonly verificationDocuments: readonly PasVendorVerificationDocument[];
  readonly summary?: readonly { readonly label: string; readonly value: string }[];
  readonly securityNote?: string;
}
export type PasVendorTeamResult =
  | { readonly state: "ready"; readonly snapshot: PasVendorTeamSnapshot }
  | { readonly state: "empty" | "unavailable" | "restricted" };
export interface PasVendorTeamAdapter {
  loadTeam(input: { readonly tenantId: string }): Promise<PasVendorTeamResult>;
}
export interface PasVendorTeamCopy {
  readonly title: string;
  readonly subtitle: string;
  readonly loading: string;
  readonly error: string;
  readonly retry: string;
  readonly unavailable: string;
  readonly restricted: string;
  readonly empty: string;
  readonly team: string;
  readonly verification: string;
  readonly search: string;
  readonly allMembers: string;
  readonly roles: string;
  readonly branch: string;
  readonly access: string;
  readonly authorization: string;
  readonly lastActive: string;
  readonly status: string;
  readonly details: string;
  readonly permissions: string;
  readonly noPermissions: string;
  readonly noDocuments: string;
  readonly notSupplied: string;
  readonly invite: string;
  readonly inviteUnavailable: string;
  readonly download: string;
  readonly update: string;
  readonly security: string;
  readonly rejectedReason: string;
}

export function PasVendorTeamVerificationPage({
  adapter,
  tenantId,
  copy,
}: {
  readonly adapter: PasVendorTeamAdapter;
  readonly tenantId: string;
  readonly copy: PasVendorTeamCopy;
}) {
  const [result, setResult] = useState<PasVendorTeamResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [failed, setFailed] = useState(false);
  const [query, setQuery] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const load = useCallback(async () => {
    setLoading(true);
    setFailed(false);
    try {
      setResult(await adapter.loadTeam({ tenantId }));
    } catch {
      setFailed(true);
    } finally {
      setLoading(false);
    }
  }, [adapter, tenantId]);
  useEffect(() => {
    void load();
  }, [load]);
  const snapshot = result?.state === "ready" ? result.snapshot : undefined;
  const members = snapshot?.teamMembers ?? [];
  const filtered = members.filter((member) =>
    `${member.name} ${member.roleLabel} ${member.branchLabel ?? ""}`
      .toLocaleLowerCase()
      .includes(query.trim().toLocaleLowerCase()),
  );
  const selected = filtered.find((member) => member.id === selectedId) ?? filtered[0];
  const summary = snapshot?.summary ?? [];
  const noTeam = result?.state === "empty" || (result?.state === "ready" && members.length === 0);
  return (
    <main className="feature-page pas-vendor-page pas-team-page">
      <header className="page-heading pas-vendor-heading pas-team-heading">
        <div>
          <span className="page-eyebrow">PAY AM SMALL · GOVERNANCE</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <div className="pas-team-heading-actions">
          <AppButton disabled leadingIcon="download" title={copy.download}>
            {copy.download}
          </AppButton>
          <AppButton disabled leadingIcon="shield" title={copy.update}>
            {copy.update}
          </AppButton>
          <AppButton disabled leadingIcon="team" title={copy.inviteUnavailable}>
            {copy.invite}
          </AppButton>
        </div>
      </header>
      <div className="pas-team-status-bar">
        <span>
          <Icon name="shield" />
          <strong>{snapshot?.businessStatusLabel ?? copy.notSupplied}</strong>
        </span>
        <span>{copy.notSupplied}</span>
      </div>
      <section className="pas-team-summary" aria-label={copy.title}>
        {summary.length
          ? summary.map((item) => (
              <SurfaceCard className="pas-team-summary-card" key={item.label}>
                <span>{item.label}</span>
                <strong>{item.value}</strong>
              </SurfaceCard>
            ))
          : [copy.team, copy.authorization, copy.verification, copy.permissions].map((label) => (
              <SurfaceCard className="pas-team-summary-card" key={label}>
                <span>{label}</span>
                <strong>{copy.notSupplied}</strong>
              </SurfaceCard>
            ))}
      </section>
      <SurfaceCard className="pas-team-security">
        <Icon name="shield" />
        <div>
          <strong>{copy.security}</strong>
          <p>{snapshot?.securityNote ?? copy.notSupplied}</p>
        </div>
      </SurfaceCard>
      <div className="pas-team-columns">
        <section className="pas-team-main-column">
          <SurfaceCard className="pas-team-toolbar">
            <div className="pas-team-tabs">
              <span className="is-active">
                {copy.allMembers} ({members.length})
              </span>
              <span>{copy.roles}</span>
              <span>{copy.verification}</span>
            </div>
            <div className="pas-team-filters">
              <label className="table-search">
                <Icon name="search" />
                <span className="sr-only">{copy.search}</span>
                <input
                  aria-label={copy.search}
                  placeholder={copy.search}
                  type="search"
                  value={query}
                  onChange={(event) => setQuery(event.target.value)}
                />
              </label>
              <AppButton disabled title={copy.inviteUnavailable}>
                {copy.invite}
              </AppButton>
            </div>
          </SurfaceCard>
          {loading ? <LoadingState label={copy.loading} /> : null}
          {!loading && failed ? (
            <ErrorState
              body={copy.error}
              onRetry={() => void load()}
              retryLabel={copy.retry}
              title={copy.title}
            />
          ) : null}
          {!loading && !failed && result?.state === "unavailable" ? (
            <EmptyState body={copy.unavailable} title={copy.team} />
          ) : null}
          {!loading && !failed && result?.state === "restricted" ? (
            <EmptyState body={copy.restricted} title={copy.team} />
          ) : null}
          {!loading && !failed && noTeam ? (
            <EmptyState body={copy.empty} title={copy.team} />
          ) : null}
          {!loading &&
          !failed &&
          result?.state === "ready" &&
          filtered.length === 0 &&
          members.length > 0 ? (
            <EmptyState body={copy.empty} title={copy.team} />
          ) : null}
          {!loading && !failed && filtered.length > 0 ? (
            <SurfaceCard className="pas-team-members">
              <div className="pas-team-table-scroll">
                <table className="data-table pas-vendor-responsive-table">
                  <thead>
                    <tr>
                      <th>{copy.team}</th>
                      <th>{copy.branch}</th>
                      <th>{copy.roles}</th>
                      <th>{copy.authorization}</th>
                      <th>{copy.lastActive}</th>
                      <th>{copy.status}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.map((member) => (
                      <tr
                        className={selected?.id === member.id ? "is-selected" : ""}
                        key={member.id}
                      >
                        <td data-label={copy.team}>
                          <button
                            className="pas-vendor-row-select"
                            onClick={() => setSelectedId(member.id)}
                            type="button"
                          >
                            <strong>{member.name}</strong>
                          </button>
                        </td>
                        <td data-label={copy.branch}>{member.branchLabel ?? copy.notSupplied}</td>
                        <td data-label={copy.roles}>{member.roleLabel}</td>
                        <td data-label={copy.authorization}>
                          {member.handoverAuthorizationLabel ?? copy.notSupplied}
                        </td>
                        <td data-label={copy.lastActive}>
                          {member.lastActiveLabel ?? copy.notSupplied}
                        </td>
                        <td data-label={copy.status}>
                          <StatusChip tone={member.statusTone ?? "neutral"}>
                            {member.statusLabel}
                          </StatusChip>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </SurfaceCard>
          ) : null}
        </section>
        <aside className="pas-team-side-column">
          <SurfaceCard className="pas-team-inspector">
            <div className="pas-vendor-section-heading">
              <h2>{copy.details}</h2>
              {selected ? (
                <StatusChip tone={selected.statusTone ?? "neutral"}>
                  {selected.statusLabel}
                </StatusChip>
              ) : null}
            </div>
            {selected ? (
              <>
                <h3>{selected.name}</h3>
                <p>{selected.roleLabel}</p>
                <p>{selected.branchLabel ?? copy.notSupplied}</p>
                <h4>{copy.permissions}</h4>
                {selected.permissions?.length ? (
                  <ul className="pas-team-permissions">
                    {selected.permissions.map((permission) => (
                      <li key={permission.label}>
                        <span>{permission.label}</span>
                        <StatusChip tone={permission.tone ?? "neutral"}>
                          {permission.value}
                        </StatusChip>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p>{copy.noPermissions}</p>
                )}
              </>
            ) : (
              <p>{copy.notSupplied}</p>
            )}
          </SurfaceCard>
          <SurfaceCard className="pas-team-documents">
            <div className="pas-vendor-section-heading">
              <h2>{copy.verification}</h2>
              <StatusChip tone={snapshot?.businessStatusTone ?? "neutral"}>
                {snapshot?.businessStatusLabel ?? copy.notSupplied}
              </StatusChip>
            </div>
            {snapshot?.verificationDocuments.length ? (
              <ul className="pas-team-document-list">
                {snapshot.verificationDocuments.map((document) => (
                  <li key={document.id}>
                    <div>
                      <strong>{document.title}</strong>
                      <span>{document.referenceLabel ?? copy.notSupplied}</span>
                      {document.rejectionReason ? (
                        <small>
                          {copy.rejectedReason}: {document.rejectionReason}
                        </small>
                      ) : document.detail ? (
                        <small>{document.detail}</small>
                      ) : null}
                    </div>
                    <StatusChip tone={document.statusTone ?? "neutral"}>
                      {document.statusLabel}
                    </StatusChip>
                  </li>
                ))}
              </ul>
            ) : (
              <EmptyState body={copy.noDocuments} title={copy.verification} />
            )}
            <div className="pas-team-document-actions">
              <AppButton disabled title={copy.update}>
                {copy.update}
              </AppButton>
            </div>
          </SurfaceCard>
        </aside>
      </div>
    </main>
  );
}
