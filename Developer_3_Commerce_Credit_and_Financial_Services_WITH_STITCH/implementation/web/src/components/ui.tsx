import type { ButtonHTMLAttributes, PropsWithChildren, ReactNode } from "react";

export type IconName =
  | "dashboard"
  | "reports"
  | "sales"
  | "fees"
  | "refund"
  | "chart"
  | "download"
  | "invoice"
  | "link"
  | "search"
  | "moon"
  | "sun"
  | "plus"
  | "chevron"
  | "calendar"
  | "close"
  | "send"
  | "clock"
  | "check"
  | "warning"
  | "retry"
  | "info"
  | "team"
  | "shield";

const paths: Record<IconName, ReactNode> = {
  dashboard: (
    <>
      <rect x="3.5" y="3.5" width="7" height="7" rx="1.2" />
      <rect x="13.5" y="3.5" width="7" height="7" rx="1.2" />
      <rect x="3.5" y="13.5" width="7" height="7" rx="1.2" />
      <rect x="13.5" y="13.5" width="7" height="7" rx="1.2" />
    </>
  ),
  reports: (
    <>
      <path d="M4 20V10m5 10V4m5 16v-7m5 7V7" />
      <path d="M3 20.5h18" />
    </>
  ),
  sales: (
    <>
      <path d="M4 17 9 12l3 3 7-8" />
      <path d="M14 7h5v5" />
    </>
  ),
  fees: (
    <>
      <path d="M19 5 5 19" />
      <circle cx="7" cy="7" r="2.5" />
      <circle cx="17" cy="17" r="2.5" />
    </>
  ),
  refund: (
    <>
      <path d="M4 8V4m0 0h4M4 4l3.2 3.2A8 8 0 1 1 4 13" />
      <path d="M12 8v4l3 2" />
    </>
  ),
  chart: (
    <>
      <path d="M4 20V12h4v8m4 0V5h4v15m4 0V9h4v11" />
      <path d="M3 20.5h18" />
    </>
  ),
  download: (
    <>
      <path d="M12 3.5v11m0 0 4-4m-4 4-4-4" />
      <path d="M4 16.5v4h16v-4" />
    </>
  ),
  invoice: (
    <>
      <path d="M7 3.75h7l4 4v12.5H6V3.75h1Z" />
      <path d="M13.5 4v4h4M9 12h6M9 15.5h6" />
    </>
  ),
  link: (
    <>
      <path d="m9.5 14.5 5-5" />
      <path d="M7.25 16.75H6a4 4 0 0 1 0-8h4M16.75 7.25H18a4 4 0 1 1 0 8h-4" />
    </>
  ),
  search: (
    <>
      <circle cx="10.8" cy="10.8" r="6.3" />
      <path d="m15.5 15.5 4 4" />
    </>
  ),
  moon: <path d="M19.2 14.2A7.8 7.8 0 0 1 9.8 4.8a8.4 8.4 0 1 0 9.4 9.4Z" />,
  sun: (
    <>
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2.5v2m0 15v2m9.5-9.5h-2m-15 0h-2m16.2-6.7-1.4 1.4M6.7 17.3l-1.4 1.4m13.4 0-1.4-1.4M6.7 6.7 5.3 5.3" />
    </>
  ),
  plus: <path d="M12 5v14m-7-7h14" />,
  chevron: <path d="m9 18 6-6-6-6" />,
  calendar: (
    <>
      <rect x="3.5" y="5" width="17" height="15" rx="2" />
      <path d="M7.5 3v4m9-4v4M4 9.5h16" />
    </>
  ),
  close: <path d="m6 6 12 12M18 6 6 18" />,
  send: (
    <>
      <path d="m3 11 18-8-8 18-2-8-8-2Z" />
      <path d="m11 13 5-5" />
    </>
  ),
  clock: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7v5l3.5 2" />
    </>
  ),
  check: <path d="m5 12.5 4.5 4.5L19 7.5" />,
  warning: (
    <>
      <path d="M12 3 2.8 19h18.4L12 3Z" />
      <path d="M12 9v4m0 3h.01" />
    </>
  ),
  retry: (
    <>
      <path d="M20 7v5h-5" />
      <path d="M19 12a7 7 0 1 0 1 3" />
    </>
  ),
  info: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 11v5m0-8h.01" />
    </>
  ),
  team: (
    <>
      <circle cx="9" cy="8" r="3" />
      <path d="M3.5 19v-1.5a5.5 5.5 0 0 1 11 0V19h-11Z" />
      <path d="M16 5.5a3 3 0 0 1 0 5.8m1 3a5 5 0 0 1 3.5 4.7V19h-3" />
    </>
  ),
  shield: <path d="M12 3 19 6v5c0 4.5-2.9 8-7 10-4.1-2-7-5.5-7-10V6l7-3Z" />,
};

export function Icon({
  name,
  className,
}: {
  readonly name: IconName;
  readonly className?: string;
}) {
  return (
    <svg
      aria-hidden="true"
      className={className}
      fill="none"
      height="20"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="1.7"
      viewBox="0 0 24 24"
      width="20"
    >
      {paths[name]}
    </svg>
  );
}

interface AppButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  readonly variant?: "primary" | "secondary" | "tertiary";
  readonly leadingIcon?: IconName;
}

export function AppButton({
  children,
  className = "",
  leadingIcon,
  variant = "secondary",
  ...props
}: AppButtonProps) {
  return (
    <button className={`app-button button-${variant} ${className}`.trim()} {...props}>
      {leadingIcon ? <Icon name={leadingIcon} /> : null}
      <span>{children}</span>
    </button>
  );
}

export function StatusChip({
  children,
  tone,
}: PropsWithChildren<{ readonly tone: "success" | "warning" | "error" | "neutral" }>) {
  const icon: Record<typeof tone, IconName> = {
    success: "check",
    warning: "clock",
    error: "warning",
    neutral: "info",
  };
  return (
    <span className={`status-chip status-${tone}`}>
      <Icon name={icon[tone]} />
      {children}
    </span>
  );
}

export function SurfaceCard({
  children,
  className = "",
}: PropsWithChildren<{ readonly className?: string }>) {
  return <section className={`surface-card ${className}`.trim()}>{children}</section>;
}

export function LoadingState({ label }: { readonly label: string }) {
  return (
    <div aria-label={label} aria-live="polite" className="loading-state" role="status">
      <span className="skeleton skeleton-heading" />
      <span className="skeleton skeleton-row" />
      <span className="skeleton skeleton-row" />
      <span className="skeleton skeleton-row" />
      <span className="skeleton skeleton-row" />
    </div>
  );
}

export function EmptyState({
  action,
  body,
  title,
}: {
  readonly action?: ReactNode;
  readonly body: string;
  readonly title: string;
}) {
  return (
    <div className="state-panel empty-state">
      <span className="state-icon">
        <Icon name="invoice" />
      </span>
      <h2>{title}</h2>
      <p>{body}</p>
      {action}
    </div>
  );
}

export function ErrorState({
  body,
  onRetry,
  retryLabel,
  title,
}: {
  readonly body: string;
  readonly onRetry: () => void;
  readonly retryLabel: string;
  readonly title: string;
}) {
  return (
    <div className="state-panel error-state" role="alert">
      <span className="state-icon">
        <Icon name="warning" />
      </span>
      <h2>{title}</h2>
      <p>{body}</p>
      <AppButton leadingIcon="retry" onClick={onRetry} type="button" variant="secondary">
        {retryLabel}
      </AppButton>
    </div>
  );
}

export function Modal({
  children,
  onClose,
  title,
}: PropsWithChildren<{ readonly onClose: () => void; readonly title: string }>) {
  return (
    <div
      className="modal-backdrop"
      onMouseDown={(event) => event.target === event.currentTarget && onClose()}
    >
      <section aria-labelledby="modal-title" aria-modal="true" className="modal-card" role="dialog">
        <header className="modal-header">
          <h2 id="modal-title">{title}</h2>
          <button aria-label="Close dialog" className="icon-button" onClick={onClose} type="button">
            <Icon name="close" />
          </button>
        </header>
        {children}
      </section>
    </div>
  );
}
