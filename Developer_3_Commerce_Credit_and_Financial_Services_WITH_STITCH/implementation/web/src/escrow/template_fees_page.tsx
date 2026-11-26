import { useCallback, useEffect, useMemo, useState, type FormEvent } from "react";
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
  EscrowTemplateConfiguration,
  EscrowTemplateSection,
  EscrowTemplateSetting,
  EscrowTemplatesFeesAdapter,
  EscrowTemplatesFeesCopy,
} from "./template_fees_types";
import "./template_fees_page.css";

interface EscrowTemplatesFeesPageProps {
  readonly adapter: EscrowTemplatesFeesAdapter;
  readonly copy: EscrowTemplatesFeesCopy;
  readonly tenantId: string;
}

type LoadState = "loading" | "ready" | "empty" | "unavailable" | "restricted" | "error";

const sectionMeta: Record<
  EscrowTemplateSection["id"],
  {
    readonly icon: "check" | "clock" | "invoice" | "fees";
    readonly copyKey: "checkpoint" | "timer" | "document" | "fees";
  }
> = {
  checkpoints: { icon: "check", copyKey: "checkpoint" },
  timers: { icon: "clock", copyKey: "timer" },
  documents: { icon: "invoice", copyKey: "document" },
  fees: { icon: "fees", copyKey: "fees" },
};

export function EscrowTemplatesFeesPage({ adapter, copy, tenantId }: EscrowTemplatesFeesPageProps) {
  const [templates, setTemplates] = useState<readonly EscrowTemplateConfiguration[]>([]);
  const [state, setState] = useState<LoadState>("loading");
  const [selectedId, setSelectedId] = useState("");
  const [values, setValues] = useState<Record<string, string | boolean | null>>({});
  const [validation, setValidation] = useState<readonly string[]>([]);
  const [confirming, setConfirming] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [pendingLabel, setPendingLabel] = useState("");
  const [operationError, setOperationError] = useState(false);
  const [actionRestricted, setActionRestricted] = useState(false);

  const load = useCallback(async () => {
    setState("loading");
    setOperationError(false);
    setActionRestricted(false);
    try {
      const result = await adapter.loadConfigurations({ tenantId });
      if (result.state === "ready") {
        setTemplates(result.templates);
        setSelectedId((current) =>
          current && result.templates.some((template) => template.id === current)
            ? current
            : (result.templates[0]?.id ?? ""),
        );
        setState(result.templates.length ? "ready" : "empty");
      } else {
        setTemplates([]);
        setSelectedId("");
        setState(result.state);
      }
    } catch {
      setState("error");
    }
  }, [adapter, tenantId]);

  useEffect(() => {
    void load();
  }, [load]);

  const selected = templates.find((template) => template.id === selectedId) ?? null;
  const settings = useMemo(
    () => selected?.sections.flatMap((section) => section.settings) ?? [],
    [selected],
  );
  const changedSettings = useMemo(
    () =>
      settings.filter(
        (setting) => Object.hasOwn(values, setting.id) && values[setting.id] !== setting.value,
      ),
    [settings, values],
  );

  const changeTemplate = (id: string) => {
    setSelectedId(id);
    setValues({});
    setValidation([]);
    setPendingLabel("");
    setOperationError(false);
    setActionRestricted(false);
  };

  const changeSetting = (setting: EscrowTemplateSetting, value: string | boolean) => {
    setValues((current) => ({ ...current, [setting.id]: value }));
    setValidation([]);
    setPendingLabel("");
  };

  const reviewProposal = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!selected || !selected.canPropose || actionRestricted || pendingLabel) return;
    const issues = settings
      .filter((setting) => setting.required && setting.editable)
      .filter((setting) => {
        const value = Object.hasOwn(values, setting.id) ? values[setting.id] : setting.value;
        return value === null || value === "";
      })
      .map((setting) => copy.requiredField(setting.label));
    setValidation(issues);
    if (issues.length === 0 && changedSettings.length > 0) setConfirming(true);
  };

  const confirmProposal = async () => {
    if (
      !selected ||
      !selected.canPropose ||
      actionRestricted ||
      submitting ||
      !changedSettings.length
    )
      return;
    setSubmitting(true);
    setOperationError(false);
    try {
      const result = await adapter.proposeConfiguration({
        tenantId,
        templateId: selected.id,
        changes: changedSettings.map((setting) => ({
          settingId: setting.id,
          value: values[setting.id],
        })),
      });
      if (result.state === "pending_approval") {
        setPendingLabel(result.statusLabel ?? copy.approvalPending);
        setConfirming(false);
      } else if (result.state === "restricted") {
        setConfirming(false);
        setActionRestricted(true);
      } else {
        setConfirming(false);
        setOperationError(true);
      }
    } catch {
      setOperationError(true);
      setConfirming(false);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <main className="feature-page escrow-templates-page">
      <div className="page-heading escrow-templates-heading">
        <div>
          <span className="eyebrow">{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
      </div>

      {state === "loading" ? <LoadingState label={copy.loading} /> : null}
      {state === "error" ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {state === "unavailable" ? (
        <EmptyState body={copy.unavailableBody} title={copy.unavailableTitle} />
      ) : null}
      {state === "restricted" ? (
        <EmptyState body={copy.restrictedBody} title={copy.restrictedTitle} />
      ) : null}
      {state === "empty" ? <EmptyState body={copy.emptyBody} title={copy.emptyTitle} /> : null}

      {state === "ready" && selected ? (
        <>
          <SurfaceCard className="escrow-template-selector">
            <label>
              <span>{copy.templateLabel}</span>
              <select
                aria-label={copy.templateLabel}
                onChange={(event) => changeTemplate(event.target.value)}
                value={selectedId}
              >
                {templates.map((template) => (
                  <option key={template.id} value={template.id}>
                    {template.name}
                  </option>
                ))}
              </select>
            </label>
            <div className="escrow-template-identity">
              <div>
                <span className="eyebrow">{copy.templateSection}</span>
                <h2>{selected.name}</h2>
              </div>
              {selected.statusLabel ? (
                <StatusChip tone={selected.statusTone ?? "neutral"}>
                  {selected.statusLabel}
                </StatusChip>
              ) : null}
            </div>
          </SurfaceCard>

          <form className="escrow-template-form" onSubmit={reviewProposal}>
            <div className="escrow-template-sections">
              {selected.sections.map((section) => (
                <TemplateSectionView
                  copy={copy}
                  key={`${selected.id}-${section.id}`}
                  onChange={changeSetting}
                  pending={Boolean(pendingLabel) || actionRestricted}
                  section={section}
                  template={selected}
                  values={values}
                />
              ))}
            </div>

            <SurfaceCard className="escrow-template-approval">
              <div className="escrow-template-approval-heading">
                <Icon name="shield" />
                <div>
                  <h2>{copy.approval}</h2>
                  <p>{copy.dualControlHelp}</p>
                </div>
              </div>
              {selected.approvalStatusLabel ? (
                <StatusChip tone={selected.approvalStatusTone ?? "neutral"}>
                  {selected.approvalStatusLabel}
                </StatusChip>
              ) : null}
              {pendingLabel ? (
                <div className="escrow-template-pending" role="status">
                  <StatusChip tone="warning">{pendingLabel}</StatusChip>
                  <p>{copy.pendingBody}</p>
                </div>
              ) : null}
              {selected.restrictionMessage ? (
                <p className="escrow-template-restriction" role="note">
                  {selected.restrictionMessage}
                </p>
              ) : null}
              {actionRestricted ? (
                <p className="escrow-template-restriction" role="note">
                  {copy.restrictedAction}
                </p>
              ) : null}
              {!selected.canPropose ? (
                <p className="escrow-template-restriction" role="note">
                  {copy.restrictedAction}
                </p>
              ) : null}
              {operationError ? (
                <p className="escrow-template-error" role="alert">
                  {copy.submitErrorBody}
                </p>
              ) : null}
              {validation.map((issue) => (
                <p className="escrow-template-error" key={issue} role="alert">
                  {issue}
                </p>
              ))}
              <AppButton
                disabled={
                  !selected.canPropose ||
                  actionRestricted ||
                  !changedSettings.length ||
                  submitting ||
                  Boolean(pendingLabel)
                }
                type="submit"
                variant="primary"
              >
                {submitting ? copy.submitting : copy.submit}
              </AppButton>
            </SurfaceCard>
          </form>
        </>
      ) : null}

      {confirming ? (
        <Modal onClose={() => !submitting && setConfirming(false)} title={copy.reviewTitle}>
          <div className="escrow-template-confirm">
            <p>{copy.reviewBody}</p>
            <ul>
              {changedSettings.map((setting) => (
                <li key={setting.id}>
                  <strong>{setting.label}</strong>
                  <span>{formatValue(values[setting.id])}</span>
                </li>
              ))}
            </ul>
            <div>
              <AppButton
                disabled={submitting}
                onClick={() => setConfirming(false)}
                type="button"
                variant="secondary"
              >
                {copy.cancel}
              </AppButton>
              <AppButton
                disabled={submitting}
                onClick={() => void confirmProposal()}
                type="button"
                variant="primary"
              >
                {submitting ? copy.submitting : copy.confirmSubmit}
              </AppButton>
            </div>
          </div>
        </Modal>
      ) : null}
    </main>
  );
}

function TemplateSectionView({
  copy,
  onChange,
  pending,
  section,
  template,
  values,
}: {
  readonly copy: EscrowTemplatesFeesCopy;
  readonly onChange: (setting: EscrowTemplateSetting, value: string | boolean) => void;
  readonly pending: boolean;
  readonly section: EscrowTemplateSection;
  readonly template: EscrowTemplateConfiguration;
  readonly values: Readonly<Record<string, string | boolean | null>>;
}) {
  const meta = sectionMeta[section.id];
  const help = copy[`${meta.copyKey}Help`];
  return (
    <SurfaceCard className={`escrow-template-section escrow-template-section-${section.id}`}>
      <header>
        <span className="escrow-template-section-icon">
          <Icon name={meta.icon} />
        </span>
        <div>
          <h2>{section.title}</h2>
          <p>{section.description ?? help}</p>
        </div>
      </header>
      {section.settings.length ? (
        <div className="escrow-template-settings">
          {section.settings.map((setting) => {
            const value = Object.hasOwn(values, setting.id) ? values[setting.id] : setting.value;
            const disabled = !template.canPropose || !setting.editable || pending;
            return (
              <TemplateSetting
                key={setting.id}
                disabled={disabled}
                onChange={(next) => onChange(setting, next)}
                setting={setting}
                value={value}
                unavailable={copy.unavailableValue}
              />
            );
          })}
        </div>
      ) : (
        <p className="escrow-template-section-empty">{copy.unavailableValue}</p>
      )}
    </SurfaceCard>
  );
}

function TemplateSetting({
  disabled,
  onChange,
  setting,
  unavailable,
  value,
}: {
  readonly disabled: boolean;
  readonly onChange: (value: string | boolean) => void;
  readonly setting: EscrowTemplateSetting;
  readonly unavailable: string;
  readonly value: string | boolean | null | undefined;
}) {
  if (setting.kind === "toggle") {
    return (
      <label className="escrow-template-setting escrow-template-toggle">
        <span>
          <strong>{setting.label}</strong>
          {setting.helperText ? <small>{setting.helperText}</small> : null}
        </span>
        <input
          checked={value === true}
          disabled={disabled}
          onChange={(event) => onChange(event.target.checked)}
          type="checkbox"
        />
      </label>
    );
  }
  return (
    <label className="escrow-template-setting">
      <span>{setting.label}</span>
      <input
        disabled={disabled}
        inputMode={setting.kind === "number" ? "decimal" : undefined}
        onChange={(event) => onChange(event.target.value)}
        type="text"
        value={typeof value === "string" ? value : ""}
        placeholder={value === null ? unavailable : undefined}
      />
      {setting.helperText ? <small>{setting.helperText}</small> : null}
    </label>
  );
}

function formatValue(value: string | boolean | null | undefined): string {
  if (value === null || value === undefined || value === "") return "Not supplied by host";
  return typeof value === "boolean" ? (value ? "Enabled" : "Disabled") : value;
}
