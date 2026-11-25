import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { PasVendorProductsPage } from "./vendor_products_page";
import type { PasVendorProductsCopy } from "./vendor_copy";
import type { PasVendorCatalogAdapter, PasVendorCatalogResult } from "./vendor_types";

const copy: PasVendorProductsCopy = {
  eyebrow: "PAY AM SMALL · CATALOGUE",
  title: "Products & Prices",
  subtitle: "Host supplied products.",
  loading: "Loading vendor catalogue",
  retry: "Retry",
  errorTitle: "Catalogue unavailable",
  errorBody: "Try again.",
  restrictedTitle: "Catalogue access restricted",
  restrictedBody: "Host restricted.",
  unavailableTitle: "Catalogue data is not connected",
  unavailableBody: "No product-list endpoint.",
  emptyTitle: "No products supplied",
  emptyBody: "No host products.",
  search: "Search products",
  searchPlaceholder: "Search catalogue",
  addProduct: "Add product",
  tableTitle: "Product catalogue",
  product: "Product",
  category: "Category",
  price: "Retail price",
  stock: "Stock",
  modes: "Plan options",
  deliveryDays: "Delivery days",
  lockDays: "Max lock days",
  status: "Price status",
  synthetic: "Synthetic preview item",
  notSupplied: "Not supplied",
  noResultsTitle: "No matching products",
  noResultsBody: "Try another search.",
  lockNoticeTitle: "Locked-price commitment",
  lockNoticeBody: "The host-supplied commitment applies to an active plan.",
  lockedPrice: "Price change blocked · active plans",
  lockStatusUnavailable: "Lock status unavailable",
  detailTitle: "Product details",
  createTitle: "Add product",
  createDescription: "Documented product fields only.",
  titleField: "Product name",
  priceField: "Retail price (NGN)",
  stockField: "Stock quantity",
  modeField: "Plan options",
  deliveryField: "Committed delivery days",
  lockDaysField: "Maximum lock days (optional)",
  modesUnavailable: "Approved mode values were not supplied.",
  required: "Complete this required field.",
  integerInvalid: "Enter a whole-number value.",
  priceInvalid: "Enter a naira amount with up to two decimal places.",
  retryAction: "Retry",
  cancel: "Cancel",
  save: "Submit product request",
  saving: "Submitting…",
  createSuccess: "Host adapter accepted the request.",
  createError: "Product request failed.",
};

const readyCatalog: PasVendorCatalogResult = {
  state: "ready",
  catalog: {
    products: [
      {
        id: "synthetic-a",
        title: "Synthetic preview product A",
        categoryLabel: "Preview category",
      },
      {
        id: "host-b",
        title: "Host product B",
        categoryLabel: "Host category",
        priceKobo: 12345,
        stock: 4,
        modeLabels: ["Host mode"],
        deliveryDays: 3,
        lockDaysMax: 14,
        priceChangeBlockedByActivePlans: true,
      },
    ],
    createModeOptions: [{ value: "HOST_APPROVED_MODE", label: "Host-approved mode" }],
  },
};

function makeAdapter(
  loadCatalog: PasVendorCatalogAdapter["loadCatalog"] = vi.fn(async () => readyCatalog),
  createProduct: PasVendorCatalogAdapter["createProduct"] = vi.fn(async () => undefined),
): PasVendorCatalogAdapter {
  return { loadCatalog, createProduct };
}

describe("W-PAS-002 Products & Prices", () => {
  it("shows a supplied product catalogue and filters only supplied rows", async () => {
    const user = userEvent.setup();
    render(<PasVendorProductsPage adapter={makeAdapter()} copy={copy} tenantId="tenant" />);
    expect(await screen.findAllByText("Synthetic preview product A")).toHaveLength(2);
    expect(screen.getAllByText("Not supplied").length).toBeGreaterThan(0);
    expect(screen.getByText("Locked-price commitment")).toBeInTheDocument();
    await user.type(screen.getByRole("textbox", { name: "Search products" }), "Host product");
    expect(await screen.findAllByText("Host product B")).toHaveLength(2);
    expect(
      screen.queryByRole("button", { name: "Product details: Synthetic preview product A" }),
    ).not.toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Product details: Host product B" }));
    expect(screen.getByRole("heading", { name: "Host product B" })).toBeInTheDocument();
    expect(screen.getAllByText("Price change blocked · active plans")).toHaveLength(2);
  });

  it("validates required documented fields and sends only documented create properties", async () => {
    const user = userEvent.setup();
    const createProduct = vi.fn(async () => undefined);
    const adapter = makeAdapter(undefined, createProduct);
    render(<PasVendorProductsPage adapter={adapter} copy={copy} tenantId="tenant-1" />);
    await screen.findAllByText("Synthetic preview product A");
    await user.click(screen.getByRole("button", { name: "Add product" }));
    const dialog = screen.getByRole("dialog");
    const submit = within(dialog).getByRole("button", { name: "Submit product request" });
    expect(submit).toBeEnabled();
    await user.click(submit);
    expect(within(dialog).getAllByText("Complete this required field.")).toHaveLength(2);
    expect(createProduct).not.toHaveBeenCalled();

    await user.type(within(dialog).getByLabelText("Product name"), "Host entered product");
    await user.type(within(dialog).getByLabelText("Retail price (NGN)"), "125.50");
    await user.type(within(dialog).getByLabelText("Stock quantity"), "7");
    await user.type(within(dialog).getByLabelText("Committed delivery days"), "5");
    await user.click(within(dialog).getByLabelText("Host-approved mode"));
    await user.click(submit);

    await waitFor(() =>
      expect(createProduct).toHaveBeenCalledWith({
        tenantId: "tenant-1",
        request: {
          title: "Host entered product",
          priceKobo: 12550,
          stock: 7,
          modes: ["HOST_APPROVED_MODE"],
          deliveryDays: 5,
        },
      }),
    );
    expect(await screen.findByText("Host adapter accepted the request.")).toBeInTheDocument();
  });

  it("keeps creation unavailable without host-approved plan mode values", async () => {
    const noModes: PasVendorCatalogResult = { state: "empty", createModeOptions: [] };
    render(
      <PasVendorProductsPage
        adapter={makeAdapter(vi.fn(async () => noModes))}
        copy={copy}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("No products supplied")).toBeInTheDocument();
    await userEvent.setup().click(screen.getByRole("button", { name: "Add product" }));
    expect(screen.getByText("Approved mode values were not supplied.")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Submit product request" })).toBeDisabled();
  });

  it("locks background scrolling while the create dialog is open and restores it on close", async () => {
    const previousRootOverflow = document.documentElement.style.overflow;
    const previousBodyOverflow = document.body.style.overflow;
    const user = userEvent.setup();
    render(<PasVendorProductsPage adapter={makeAdapter()} copy={copy} tenantId="tenant" />);
    await screen.findAllByText("Synthetic preview product A");

    await user.click(screen.getByRole("button", { name: "Add product" }));
    expect(document.documentElement.style.overflow).toBe("hidden");
    expect(document.body.style.overflow).toBe("hidden");

    await user.click(screen.getByRole("button", { name: "Close dialog" }));
    expect(document.documentElement.style.overflow).toBe(previousRootOverflow);
    expect(document.body.style.overflow).toBe(previousBodyOverflow);
  });

  it("renders restricted and retryable error states", async () => {
    const view = render(
      <PasVendorProductsPage
        adapter={makeAdapter(vi.fn(async () => ({ state: "restricted" as const })))}
        copy={copy}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText("Catalogue access restricted")).toBeInTheDocument();
    view.unmount();
    const loadCatalog = vi
      .fn()
      .mockRejectedValueOnce(new Error("network"))
      .mockResolvedValue(readyCatalog);
    render(
      <PasVendorProductsPage adapter={makeAdapter(loadCatalog)} copy={copy} tenantId="tenant" />,
    );
    expect(await screen.findByText("Catalogue unavailable")).toBeInTheDocument();
    await userEvent.setup().click(screen.getByRole("button", { name: "Retry" }));
    await waitFor(() => expect(screen.getAllByText("Synthetic preview product A")).toHaveLength(2));
  });
});
