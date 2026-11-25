import { useCallback, useEffect, useMemo, useState, type FormEvent, type ReactNode } from "react";
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
import { formatKobo } from "../shared/format";
import type { PasVendorProductsCopy } from "./vendor_copy";
import type {
  PasVendorCatalogAdapter,
  PasVendorCatalogResult,
  PasVendorCreateProductRequest,
  PasVendorProduct,
} from "./vendor_types";

interface PasVendorProductsPageProps {
  readonly tenantId: string;
  readonly adapter: PasVendorCatalogAdapter;
  readonly copy: PasVendorProductsCopy;
}

interface ProductDraft {
  readonly title: string;
  readonly price: string;
  readonly stock: string;
  readonly deliveryDays: string;
  readonly lockDaysMax: string;
  readonly modes: readonly string[];
}

const emptyDraft: ProductDraft = {
  title: "",
  price: "",
  stock: "",
  deliveryDays: "",
  lockDaysMax: "",
  modes: [],
};

export function PasVendorProductsPage({ adapter, copy, tenantId }: PasVendorProductsPageProps) {
  const [result, setResult] = useState<PasVendorCatalogResult | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);
  const [query, setQuery] = useState("");
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [createOpen, setCreateOpen] = useState(false);
  const [draft, setDraft] = useState<ProductDraft>(emptyDraft);
  const [attempted, setAttempted] = useState(false);
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState(false);
  const [saveSuccess, setSaveSuccess] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setLoadError(false);
    try {
      const next = await adapter.loadCatalog({ tenantId });
      setResult(next);
      if (next.state === "ready") {
        setSelectedId((current) =>
          current && next.catalog.products.some((product) => product.id === current)
            ? current
            : (next.catalog.products[0]?.id ?? null),
        );
      } else {
        setSelectedId(null);
      }
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }, [adapter, tenantId]);

  useEffect(() => {
    let active = true;
    setLoading(true);
    setLoadError(false);
    adapter
      .loadCatalog({ tenantId })
      .then((next) => {
        if (!active) return;
        setResult(next);
        if (next.state === "ready") setSelectedId(next.catalog.products[0]?.id ?? null);
      })
      .catch(() => active && setLoadError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [adapter, tenantId]);

  useEffect(() => {
    if (!createOpen) return;
    const root = document.documentElement;
    const previousRootOverflow = root.style.overflow;
    const previousBodyOverflow = document.body.style.overflow;
    root.style.overflow = "hidden";
    document.body.style.overflow = "hidden";
    return () => {
      root.style.overflow = previousRootOverflow;
      document.body.style.overflow = previousBodyOverflow;
    };
  }, [createOpen]);

  const catalog = result?.state === "ready" ? result.catalog : null;
  const products = catalog?.products ?? [];
  const modeOptions =
    catalog?.createModeOptions ?? (result?.state === "empty" ? result.createModeOptions : []);
  const categories = useMemo(
    () => [
      ...new Set(
        products
          .map((product) => product.categoryLabel)
          .filter((value): value is string => Boolean(value)),
      ),
    ],
    [products],
  );
  const [category, setCategory] = useState("");
  const filtered = useMemo(() => {
    const normalized = query.trim().toLocaleLowerCase();
    return products.filter((product) => {
      const matchesQuery =
        !normalized ||
        [product.title, product.skuLabel, product.categoryLabel].some((value) =>
          value?.toLocaleLowerCase().includes(normalized),
        );
      return matchesQuery && (!category || product.categoryLabel === category);
    });
  }, [category, products, query]);
  const selected = filtered.find((product) => product.id === selectedId) ?? filtered[0] ?? null;
  const hasProducts = result?.state === "ready" && products.length > 0;

  function closeCreate() {
    if (saving) return;
    setCreateOpen(false);
    setDraft(emptyDraft);
    setAttempted(false);
    setSaveError(false);
  }

  function validationErrors(): Partial<Record<keyof ProductDraft, string>> {
    const errors: Partial<Record<keyof ProductDraft, string>> = {};
    if (!draft.title.trim()) errors.title = copy.required;
    if (parseKobo(draft.price) === null) errors.price = copy.priceInvalid;
    if (!isInteger(draft.stock)) errors.stock = copy.integerInvalid;
    if (!draft.modes.length) errors.modes = copy.required;
    if (!isInteger(draft.deliveryDays)) errors.deliveryDays = copy.integerInvalid;
    if (draft.lockDaysMax.trim() && !isInteger(draft.lockDaysMax))
      errors.lockDaysMax = copy.integerInvalid;
    return errors;
  }

  async function submitCreate(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setAttempted(true);
    setSaveError(false);
    const errors = validationErrors();
    if (Object.keys(errors).length || modeOptions.length === 0) return;
    const request: PasVendorCreateProductRequest = {
      title: draft.title.trim(),
      priceKobo: parseKobo(draft.price)!,
      stock: Number(draft.stock),
      modes: [...draft.modes],
      deliveryDays: Number(draft.deliveryDays),
      ...(draft.lockDaysMax.trim() ? { lockDaysMax: Number(draft.lockDaysMax) } : {}),
    };
    setSaving(true);
    try {
      await adapter.createProduct({ tenantId, request });
      setSaveSuccess(true);
      setCreateOpen(false);
      setDraft(emptyDraft);
      setAttempted(false);
      await load();
    } catch {
      setSaveError(true);
    } finally {
      setSaving(false);
    }
  }

  return (
    <main className="feature-page pas-vendor-page pas-vendor-products">
      <header className="page-heading pas-vendor-heading">
        <div>
          <p className="eyebrow">{copy.eyebrow}</p>
          <h1>{copy.title}</h1>
          <p className="page-subtitle">{copy.subtitle}</p>
        </div>
        <AppButton
          leadingIcon="plus"
          onClick={() => {
            setCreateOpen(true);
            setSaveSuccess(false);
          }}
          type="button"
          variant="primary"
        >
          {copy.addProduct}
        </AppButton>
      </header>

      <SurfaceCard className="pas-vendor-lock-notice">
        <span className="pas-vendor-notice-icon">
          <Icon name="shield" />
        </span>
        <div>
          <strong>{copy.lockNoticeTitle}</strong>
          <p>{copy.lockNoticeBody}</p>
        </div>
      </SurfaceCard>

      {saveSuccess ? (
        <div className="feedback-banner" role="status">
          <Icon name="check" />
          {copy.createSuccess}
        </div>
      ) : null}
      {loading ? <LoadingState label={copy.loading} /> : null}
      {!loading && loadError ? (
        <ErrorState
          body={copy.errorBody}
          onRetry={() => void load()}
          retryLabel={copy.retry}
          title={copy.errorTitle}
        />
      ) : null}
      {!loading && !loadError && result?.state === "restricted" ? (
        <div className="pas-vendor-unavailable" role="status">
          <Icon name="warning" />
          <div>
            <strong>{copy.restrictedTitle}</strong>
            <p>{copy.restrictedBody}</p>
          </div>
        </div>
      ) : null}
      {!loading && !loadError && result?.state === "unavailable" ? (
        <div className="pas-vendor-unavailable" role="status">
          <Icon name="info" />
          <div>
            <strong>{copy.unavailableTitle}</strong>
            <p>{copy.unavailableBody}</p>
          </div>
        </div>
      ) : null}
      {!loading && !loadError && result?.state === "empty" ? (
        <SurfaceCard>
          <EmptyState body={copy.emptyBody} title={copy.emptyTitle} />
        </SurfaceCard>
      ) : null}

      {!loading && !loadError && hasProducts ? (
        <>
          <div className="pas-vendor-catalog-toolbar">
            <label className="table-search pas-vendor-search">
              <Icon name="search" />
              <span className="sr-only">{copy.search}</span>
              <input
                aria-label={copy.search}
                onChange={(event) => setQuery(event.target.value)}
                placeholder={copy.searchPlaceholder}
                value={query}
              />
            </label>
            {categories.length ? (
              <label className="pas-vendor-filter">
                <span>{copy.category}</span>
                <select
                  aria-label={copy.category}
                  onChange={(event) => setCategory(event.target.value)}
                  value={category}
                >
                  <option value="">{copy.category}</option>
                  {categories.map((item) => (
                    <option key={item} value={item}>
                      {item}
                    </option>
                  ))}
                </select>
              </label>
            ) : null}
            <span className="pas-vendor-record-count">
              {filtered.length} / {products.length}
            </span>
          </div>

          <div className="pas-vendor-products-layout">
            <SurfaceCard className="pas-vendor-product-table-card">
              {filtered.length ? (
                <div className="data-table-wrap pas-vendor-product-table-wrap">
                  <table className="data-table pas-vendor-product-table">
                    <thead>
                      <tr>
                        <th scope="col">{copy.product}</th>
                        <th scope="col">{copy.category}</th>
                        <th className="align-right" scope="col">
                          {copy.price}
                        </th>
                        <th className="align-right" scope="col">
                          {copy.stock}
                        </th>
                        <th scope="col">{copy.modes}</th>
                        <th scope="col">{copy.status}</th>
                        <th scope="col">
                          <span className="sr-only">{copy.detailTitle}</span>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {filtered.map((product) => (
                        <ProductRow
                          copy={copy}
                          key={product.id}
                          onSelect={() => setSelectedId(product.id)}
                          product={product}
                          selected={selectedId === product.id}
                        />
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <EmptyState body={copy.noResultsBody} title={copy.noResultsTitle} />
              )}
            </SurfaceCard>
            <ProductDetail copy={copy} product={selected} />
          </div>
        </>
      ) : null}

      {createOpen ? (
        <Modal onClose={closeCreate} title={copy.createTitle}>
          <form
            className="modal-body pas-vendor-create-form"
            noValidate
            onSubmit={(event) => void submitCreate(event)}
          >
            <p className="modal-description">{copy.createDescription}</p>
            <Field
              label={copy.titleField}
              error={attempted && !draft.title.trim() ? copy.required : undefined}
            >
              <input
                aria-label={copy.titleField}
                autoFocus
                className="app-input"
                onChange={(event) => setDraft({ ...draft, title: event.target.value })}
                value={draft.title}
              />
            </Field>
            <Field
              label={copy.priceField}
              error={attempted && parseKobo(draft.price) === null ? copy.priceInvalid : undefined}
            >
              <input
                aria-label={copy.priceField}
                className="app-input"
                inputMode="decimal"
                onChange={(event) => setDraft({ ...draft, price: event.target.value })}
                value={draft.price}
              />
            </Field>
            <div className="pas-vendor-form-grid">
              <Field
                label={copy.stockField}
                error={attempted && !isInteger(draft.stock) ? copy.integerInvalid : undefined}
              >
                <input
                  aria-label={copy.stockField}
                  className="app-input"
                  inputMode="numeric"
                  onChange={(event) => setDraft({ ...draft, stock: event.target.value })}
                  value={draft.stock}
                />
              </Field>
              <Field
                label={copy.deliveryField}
                error={
                  attempted && !isInteger(draft.deliveryDays) ? copy.integerInvalid : undefined
                }
              >
                <input
                  aria-label={copy.deliveryField}
                  className="app-input"
                  inputMode="numeric"
                  onChange={(event) => setDraft({ ...draft, deliveryDays: event.target.value })}
                  value={draft.deliveryDays}
                />
              </Field>
            </div>
            <fieldset className="choice-fieldset">
              <legend className="field-label">{copy.modeField}</legend>
              {modeOptions.length ? (
                <div className="choice-group">
                  {modeOptions.map((option) => (
                    <label
                      className={
                        draft.modes.includes(option.value)
                          ? "choice-option is-selected"
                          : "choice-option"
                      }
                      key={option.value}
                    >
                      <input
                        checked={draft.modes.includes(option.value)}
                        onChange={(event) =>
                          setDraft({
                            ...draft,
                            modes: event.target.checked
                              ? [...draft.modes, option.value]
                              : draft.modes.filter((mode) => mode !== option.value),
                          })
                        }
                        type="checkbox"
                      />
                      {option.label}
                    </label>
                  ))}
                </div>
              ) : (
                <p className="pas-vendor-contract-gap" role="status">
                  {copy.modesUnavailable}
                </p>
              )}
              {attempted && !draft.modes.length ? (
                <p className="field-error" role="alert">
                  {copy.required}
                </p>
              ) : null}
            </fieldset>
            <Field
              label={copy.lockDaysField}
              error={
                attempted && draft.lockDaysMax.trim() && !isInteger(draft.lockDaysMax)
                  ? copy.integerInvalid
                  : undefined
              }
            >
              <input
                aria-label={copy.lockDaysField}
                className="app-input"
                inputMode="numeric"
                onChange={(event) => setDraft({ ...draft, lockDaysMax: event.target.value })}
                value={draft.lockDaysMax}
              />
            </Field>
            {saveError ? (
              <p className="field-error" role="alert">
                {copy.createError}
              </p>
            ) : null}
            <div className="modal-actions">
              <AppButton disabled={saving} onClick={closeCreate} type="button" variant="secondary">
                {copy.cancel}
              </AppButton>
              <AppButton
                disabled={saving || modeOptions.length === 0}
                leadingIcon="check"
                type="submit"
                variant="primary"
              >
                {saving ? copy.saving : copy.save}
              </AppButton>
            </div>
          </form>
        </Modal>
      ) : null}
    </main>
  );
}

function ProductRow({
  copy,
  onSelect,
  product,
  selected,
}: {
  readonly copy: PasVendorProductsCopy;
  readonly product: PasVendorProduct;
  readonly selected: boolean;
  readonly onSelect: () => void;
}) {
  return (
    <tr aria-selected={selected} className={selected ? "data-row is-selected" : "data-row"}>
      <td>
        <div className="pas-vendor-product-name">
          <span aria-hidden="true" className="pas-vendor-product-icon">
            <Icon name="invoice" />
          </span>
          <span>
            <strong>{product.title}</strong>
            <small>{product.skuLabel ?? copy.synthetic}</small>
          </span>
        </div>
      </td>
      <td>{product.categoryLabel ?? copy.synthetic}</td>
      <td className="amount-cell">
        {product.priceKobo === undefined ? copy.notSupplied : formatKobo(product.priceKobo)}
      </td>
      <td className="align-right">{product.stock ?? copy.notSupplied}</td>
      <td>{product.modeLabels?.length ? product.modeLabels.join(", ") : copy.notSupplied}</td>
      <td>
        {product.priceChangeBlockedByActivePlans === true ? (
          <StatusChip tone="warning">{copy.lockedPrice}</StatusChip>
        ) : product.priceChangeBlockedByActivePlans === false ? (
          <StatusChip tone="neutral">{copy.lockStatusUnavailable}</StatusChip>
        ) : (
          <StatusChip tone="neutral">{copy.lockStatusUnavailable}</StatusChip>
        )}
      </td>
      <td>
        <button
          aria-label={`${copy.detailTitle}: ${product.title}`}
          className="row-link"
          onClick={onSelect}
          type="button"
        >
          {copy.detailTitle}
        </button>
      </td>
    </tr>
  );
}

function ProductDetail({
  copy,
  product,
}: {
  readonly copy: PasVendorProductsCopy;
  readonly product: PasVendorProduct | null;
}) {
  return (
    <aside aria-label={copy.detailTitle} className="detail-panel pas-vendor-product-detail">
      <div className="detail-heading">
        <div className="pas-vendor-detail-title">
          <span className="pas-vendor-product-icon">
            <Icon name="invoice" />
          </span>
          <h2>{copy.detailTitle}</h2>
        </div>
        {product ? <StatusChip tone="neutral">{copy.synthetic}</StatusChip> : null}
      </div>
      {product ? (
        <>
          <h3>{product.title}</h3>
          <dl className="detail-list">
            <DetailRow label={copy.category} value={product.categoryLabel ?? copy.notSupplied} />
            <DetailRow
              label={copy.price}
              value={
                product.priceKobo === undefined ? copy.notSupplied : formatKobo(product.priceKobo)
              }
            />
            <DetailRow label={copy.stock} value={product.stock ?? copy.notSupplied} />
            <DetailRow
              label={copy.modes}
              value={product.modeLabels?.join(", ") || copy.notSupplied}
            />
            <DetailRow label={copy.deliveryDays} value={product.deliveryDays ?? copy.notSupplied} />
            <DetailRow label={copy.lockDays} value={product.lockDaysMax ?? copy.notSupplied} />
          </dl>
          <p className="detail-note">
            <Icon name="info" />
            {product.priceChangeBlockedByActivePlans === true
              ? copy.lockedPrice
              : copy.lockStatusUnavailable}
          </p>
        </>
      ) : (
        <p>{copy.notSupplied}</p>
      )}
    </aside>
  );
}

function DetailRow({ label, value }: { readonly label: string; readonly value: string | number }) {
  return (
    <div>
      <dt>{label}</dt>
      <dd>{value}</dd>
    </div>
  );
}

function Field({
  children,
  error,
  label,
}: {
  readonly children: ReactNode;
  readonly error?: string;
  readonly label: string;
}) {
  return (
    <label className="form-field">
      <span className="field-label">{label}</span>
      {children}
      {error ? (
        <span className="field-error" role="alert">
          {error}
        </span>
      ) : null}
    </label>
  );
}

function parseKobo(value: string): number | null {
  const normalized = value.trim();
  const match = /^(-?)(\d+)(?:\.(\d{1,2}))?$/.exec(normalized);
  if (!match) return null;
  const sign = match[1] === "-" ? -1n : 1n;
  const whole = BigInt(match[2]);
  const fraction = BigInt((match[3] ?? "").padEnd(2, "0"));
  const valueKobo = sign * (whole * 100n + fraction);
  if (valueKobo > BigInt(Number.MAX_SAFE_INTEGER) || valueKobo < BigInt(Number.MIN_SAFE_INTEGER))
    return null;
  return Number(valueKobo);
}

function isInteger(value: string): boolean {
  return /^-?\d+$/.test(value.trim()) && Number.isSafeInteger(Number(value));
}
