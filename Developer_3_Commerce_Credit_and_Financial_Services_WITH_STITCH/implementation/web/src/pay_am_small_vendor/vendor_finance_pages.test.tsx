import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { PasVendorCreditOffersPage, PasVendorPayoutsPage } from "./vendor_finance_pages";
import type { PasVendorFinanceCopy } from "./vendor_finance_pages";

const copy: PasVendorFinanceCopy = {
  credit: {
    title: "Credit Offers",
    subtitle: "Host-supplied requests",
    loading: "Loading",
    error: "Load failed",
    restricted: "Restricted",
    unavailable: "No approved credit-offer list is connected.",
    empty: "No requests",
    search: "Search requests",
    buyer: "Buyer",
    product: "Product",
    requested: "Requested",
    status: "Status",
    details: "Request details",
    risk: "Approval required",
    riskCopy: "Vendor credit requires approval.",
    notSupplied: "Not supplied",
    disabledDecision: "Decision unavailable",
    decisionAccepted: "Submitted",
    decisionError: "Failed",
    reason: "Reason",
  },
  payouts: {
    title: "Payouts & Wallet",
    subtitle: "Host-supplied payout information",
    loading: "Loading payouts",
    error: "Payouts failed",
    restricted: "Restricted",
    unavailable: "Payout values are unavailable.",
    empty: "No payout records",
    available: "Available balance",
    holdback: "Holdback",
    settled: "Settled",
    account: "Settlement account",
    ledger: "Payout history",
    reference: "Reference",
    date: "Date",
    order: "Order",
    gross: "Gross",
    fee: "Fee",
    net: "Net",
    status: "Status",
    notSupplied: "Not supplied",
    exportUnavailable: "Statements unavailable",
  },
};

describe("W-PAS-005 Credit Offers", () => {
  it("renders supplied request data, filters it, and keeps decisions disabled without host capability", async () => {
    render(
      <PasVendorCreditOffersPage
        tenantId="tenant"
        copy={copy.credit}
        adapter={{
          async loadOffers() {
            return {
              state: "ready",
              offers: [
                {
                  id: "1",
                  reference: "SYN-1",
                  buyerLabel: "Synthetic buyer",
                  productLabel: "Synthetic item",
                  statusLabel: "Pending",
                  statusTone: "warning",
                  hostDetails: [],
                },
              ],
            };
          },
        }}
      />,
    );
    expect(await screen.findAllByText("Synthetic buyer")).toHaveLength(2);
    expect(screen.getByRole("button", { name: "Accept" })).toBeDisabled();
    fireEvent.change(screen.getByRole("searchbox", { name: "Search requests" }), {
      target: { value: "missing" },
    });
    expect(screen.getByText("No requests")).toBeInTheDocument();
  });

  it("shows the documented unavailable state", async () => {
    render(
      <PasVendorCreditOffersPage
        tenantId="tenant"
        copy={copy.credit}
        adapter={{
          async loadOffers() {
            return { state: "unavailable" };
          },
        }}
      />,
    );
    expect(await screen.findByText(copy.credit.unavailable)).toBeInTheDocument();
  });

  it("keeps a supplied decision callback disabled without explicit legal and host authorization", async () => {
    let called = false;
    render(
      <PasVendorCreditOffersPage
        tenantId="tenant"
        copy={copy.credit}
        adapter={{
          async loadOffers() {
            return {
              state: "ready",
              offers: [
                {
                  id: "1",
                  reference: "SYN-1",
                  buyerLabel: "Synthetic buyer",
                  productLabel: "Synthetic item",
                  statusLabel: "Pending",
                  statusTone: "warning",
                  hostDetails: [],
                },
              ],
            };
          },
          async decide() {
            called = true;
          },
        }}
      />,
    );
    expect(await screen.findAllByText("Synthetic buyer")).toHaveLength(2);
    expect(screen.getByRole("button", { name: "Accept" })).toBeDisabled();
    expect(called).toBe(false);
  });
});

describe("W-PAS-006 Payouts & Wallet", () => {
  it("does not fabricate payout amounts and keeps statement export unavailable", async () => {
    render(
      <PasVendorPayoutsPage
        tenantId="tenant"
        copy={copy.payouts}
        adapter={{
          async loadPayouts() {
            return { state: "ready", snapshot: { transactions: [] } };
          },
        }}
      />,
    );
    expect(await screen.findAllByText("Not supplied")).toHaveLength(4);
    expect(screen.getByRole("button", { name: "Statements unavailable" })).toBeDisabled();
    expect(screen.getByText("No payout records")).toBeInTheDocument();
  });

  it("shows the unavailable state when host payout data is not connected", async () => {
    render(
      <PasVendorPayoutsPage
        tenantId="tenant"
        copy={copy.payouts}
        adapter={{
          async loadPayouts() {
            return { state: "unavailable" };
          },
        }}
      />,
    );
    expect(await screen.findByText(copy.payouts.unavailable)).toBeInTheDocument();
  });
});
