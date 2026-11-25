import { useEffect, useState } from "react";
import type { FormEvent } from "react";
import type { TeamVerificationCopy } from "../shared/copy";
import {
  AppButton,
  EmptyState,
  ErrorState,
  Icon,
  LoadingState,
  Modal,
  StatusChip,
  SurfaceCard,
} from "../components/ui";
import type {
  BusinessVerificationState,
  TeamInviteRole,
  TeamMemberPresentation,
  TeamVerificationAdapter,
  TeamVerificationOverview,
} from "./team_verification_types";

interface TeamVerificationPageProps {
  readonly tenantId: string;
  readonly adapter: TeamVerificationAdapter;
  readonly copy: TeamVerificationCopy;
}

const inviteRoles: readonly TeamInviteRole[] = ["MANAGER", "CASHIER", "ACCOUNTANT"];

export function TeamVerificationPage({ adapter, copy, tenantId }: TeamVerificationPageProps) {
  const [overview, setOverview] = useState<TeamVerificationOverview | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [showInvite, setShowInvite] = useState(false);
  const [phone, setPhone] = useState("");
  const [role, setRole] = useState<TeamInviteRole>("MANAGER");
  const [phoneError, setPhoneError] = useState(false);
  const [inviteError, setInviteError] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [feedback, setFeedback] = useState("");

  useEffect(() => {
    let active = true;
    setLoading(true);
    setLoadError(false);
    adapter
      .loadOverview({ tenantId })
      .then((result) => {
        if (!active) return;
        setOverview(result);
        setSelectedId((current) =>
          current && result.members.some((member) => member.id === current)
            ? current
            : (result.members[0]?.id ?? null),
        );
      })
      .catch(() => active && setLoadError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [adapter, tenantId]);

  const selectedMember = overview?.members.find((member) => member.id === selectedId) ?? null;

  async function retry() {
    setLoading(true);
    setLoadError(false);
    try {
      const result = await adapter.loadOverview({ tenantId });
      setOverview(result);
      setSelectedId(result.members[0]?.id ?? null);
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }

  async function submitInvite(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const normalizedPhone = phone.trim();
    if (!normalizedPhone) {
      setPhoneError(true);
      return;
    }
    if (submitting) return;
    setPhoneError(false);
    setInviteError(false);
    setSubmitting(true);
    try {
      await adapter.inviteMember({ tenantId, phone: normalizedPhone, role });
      setShowInvite(false);
      setPhone("");
      setFeedback(copy.inviteSuccess);
    } catch {
      setInviteError(true);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <main className="feature-page team-verification-page">
      <header className="page-heading team-page-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          leadingIcon="plus"
          onClick={() => {
            setFeedback("");
            setShowInvite(true);
          }}
          type="button"
          variant="primary"
        >
          {copy.invite}
        </AppButton>
      </header>

      {feedback ? (
        <div aria-live="polite" className="feedback-banner team-feedback">
          <Icon name="check" />
          {feedback}
        </div>
      ) : null}

      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && loadError ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void retry()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}

      {!loading && !loadError && overview ? (
        <>
          <SurfaceCard className="verification-summary-card">
            <div className="verification-summary-icon" aria-hidden="true">
              <Icon name="shield" />
            </div>
            <div className="verification-summary-content">
              <div className="verification-summary-heading">
                <div>
                  <h2>{copy.verificationTitle}</h2>
                  <p>{overview.verification.message ?? copy.verificationMessage}</p>
                </div>
                <VerificationStatus copy={copy} state={overview.verification.state} />
              </div>
              {overview.verification.state === "rejected" &&
              overview.verification.rejectedReason ? (
                <div className="verification-rejected-reason" role="status">
                  <strong>{copy.rejectedReason}</strong>
                  <p>{overview.verification.rejectedReason}</p>
                </div>
              ) : null}
            </div>
          </SurfaceCard>

          <SurfaceCard className="team-roster-card">
            <header className="team-roster-heading">
              <div>
                <h2>{copy.teamTitle}</h2>
                <p>{copy.teamDescription}</p>
              </div>
              <span className="team-count-label">
                <Icon name="team" />
                {overview.members.length}
              </span>
            </header>

            {overview.members.length === 0 ? (
              <EmptyState body={copy.emptyBody} title={copy.emptyTitle} />
            ) : (
              <div className="team-layout">
                <div className="data-table-wrap team-table-wrap">
                  <table className="data-table team-table">
                    <thead>
                      <tr>
                        <th scope="col">{copy.member}</th>
                        <th scope="col">{copy.contact}</th>
                        <th scope="col">{copy.role}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {overview.members.map((member) => (
                        <tr
                          aria-selected={selectedId === member.id}
                          className={selectedId === member.id ? "data-row is-selected" : "data-row"}
                          key={member.id}
                          onClick={() => setSelectedId(member.id)}
                        >
                          <td>
                            <button
                              className="row-link team-member-link"
                              onClick={() => setSelectedId(member.id)}
                              type="button"
                            >
                              {member.name}
                            </button>
                          </td>
                          <td>{member.contact}</td>
                          <td>
                            <span className="team-role-label">{roleLabel(member.role, copy)}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
                {selectedMember ? (
                  <MemberPermissions copy={copy} member={selectedMember} />
                ) : (
                  <div className="team-detail-empty">{copy.selectMember}</div>
                )}
              </div>
            )}
          </SurfaceCard>
        </>
      ) : null}

      {showInvite ? (
        <Modal onClose={() => !submitting && setShowInvite(false)} title={copy.inviteTitle}>
          <form className="modal-body" onSubmit={(event) => void submitInvite(event)}>
            <p className="modal-description">{copy.inviteDescription}</p>
            <label className="form-field">
              <span className="field-label">{copy.phone}</span>
              <input
                aria-invalid={phoneError}
                autoComplete="tel"
                className="app-input"
                onChange={(event) => {
                  setPhone(event.target.value);
                  setPhoneError(false);
                  setInviteError(false);
                }}
                type="tel"
                value={phone}
              />
              {phoneError ? (
                <span className="field-error" role="alert">
                  {copy.phoneRequired}
                </span>
              ) : null}
            </label>
            <label className="form-field">
              <span className="field-label">{copy.roleLabel}</span>
              <select
                className="app-input"
                onChange={(event) => setRole(event.target.value as TeamInviteRole)}
                value={role}
              >
                {inviteRoles.map((value) => (
                  <option key={value} value={value}>
                    {roleLabel(value, copy)}
                  </option>
                ))}
              </select>
            </label>
            {inviteError ? (
              <p className="field-error" role="alert">
                {copy.inviteError}
              </p>
            ) : null}
            <div className="modal-actions">
              <AppButton
                disabled={submitting}
                onClick={() => setShowInvite(false)}
                type="button"
                variant="secondary"
              >
                {copy.cancel}
              </AppButton>
              <AppButton disabled={submitting} type="submit" variant="primary">
                {submitting ? copy.submitting : copy.submitInvite}
              </AppButton>
            </div>
          </form>
        </Modal>
      ) : null}
    </main>
  );
}

function VerificationStatus({
  copy,
  state,
}: {
  readonly copy: TeamVerificationCopy;
  readonly state: BusinessVerificationState;
}) {
  const tone = state === "verified" ? "success" : state === "rejected" ? "error" : "warning";
  const label =
    state === "verified"
      ? copy.verificationVerified
      : state === "rejected"
        ? copy.verificationRejected
        : copy.verificationPending;
  return <StatusChip tone={tone}>{label}</StatusChip>;
}

function MemberPermissions({
  copy,
  member,
}: {
  readonly copy: TeamVerificationCopy;
  readonly member: TeamMemberPresentation;
}) {
  return (
    <aside aria-label={`${copy.permissions}: ${member.name}`} className="team-permission-panel">
      <div className="team-detail-heading">
        <span className="team-avatar" aria-hidden="true">
          {member.name.trim().slice(0, 1).toUpperCase() || "?"}
        </span>
        <div>
          <h3>{member.name}</h3>
          <p>{roleLabel(member.role, copy)}</p>
        </div>
      </div>
      <h4>{copy.permissions}</h4>
      {member.permissions.length ? (
        <ul className="team-permission-list">
          {member.permissions.map((permission) => (
            <li key={permission}>
              <Icon name="check" />
              <span>{permission}</span>
            </li>
          ))}
        </ul>
      ) : (
        <p className="team-no-permissions">{copy.noPermissions}</p>
      )}
    </aside>
  );
}

function roleLabel(
  role: TeamMemberPresentation["role"] | TeamInviteRole,
  copy: TeamVerificationCopy,
) {
  if (role === "OWNER") return copy.owner;
  if (role === "MANAGER") return copy.manager;
  if (role === "CASHIER") return copy.cashier;
  return copy.accountant;
}
