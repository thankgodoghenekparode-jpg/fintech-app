import { act, fireEvent, render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { testCopy } from "../test_copy";
import { ReportsAndExportsPage } from "./reports_and_exports_page";
import type { ReportsAdapter, ReportsResult } from "./reports_types";

const readyReport: ReportsResult = {
  state: "ready",
  summary: { salesKobo: 1_250_000, feesKobo: 12_500, refundsKobo: 8_000, taxKobo: 45_000 },
};

function makeAdapter(
  loadReport = vi.fn(async () => readyReport),
  exportReport = vi.fn(async () => undefined),
): ReportsAdapter {
  return { loadReport, exportReport };
}

describe("W-MER-004 Reports and Exports", () => {
  it("loads host summaries for the supplied report type without inventing a wire response", async () => {
    const loadReport = vi.fn(async () => readyReport);
    render(
      <ReportsAndExportsPage
        adapter={makeAdapter(loadReport)}
        copy={testCopy.reports}
        reportType="host-approved-type"
        tenantId="tenant-test"
      />,
    );

    expect(await screen.findByRole("heading", { name: "Reports and exports" })).toBeInTheDocument();
    expect(
      screen.getByText("Sales", { selector: ".report-metric-heading span:first-child" }),
    ).toBeInTheDocument();
    await waitFor(() =>
      expect(loadReport).toHaveBeenCalledWith({
        tenantId: "tenant-test",
        reportType: "host-approved-type",
      }),
    );
    expect(screen.getByRole("button", { name: "Export report" })).toBeEnabled();
  });

  it("applies only the documented date filters and rejects a reversed range", async () => {
    const user = userEvent.setup();
    const loadReport = vi.fn(async () => readyReport);
    render(
      <ReportsAndExportsPage
        adapter={makeAdapter(loadReport)}
        copy={testCopy.reports}
        reportType="host-approved-type"
        tenantId="tenant-test"
      />,
    );

    fireEvent.change(screen.getByLabelText("From date"), { target: { value: "2026-10-01" } });
    fireEvent.change(screen.getByLabelText("To date"), { target: { value: "2026-10-31" } });
    await user.click(screen.getByRole("button", { name: "Apply dates" }));
    await waitFor(() =>
      expect(loadReport).toHaveBeenLastCalledWith({
        tenantId: "tenant-test",
        reportType: "host-approved-type",
        from: "2026-10-01",
        to: "2026-10-31",
      }),
    );

    const callsBeforeInvalidRange = loadReport.mock.calls.length;
    fireEvent.change(screen.getByLabelText("From date"), { target: { value: "2026-11-01" } });
    fireEvent.change(screen.getByLabelText("To date"), { target: { value: "2026-10-31" } });
    await user.click(screen.getByRole("button", { name: "Apply dates" }));
    expect(await screen.findByRole("alert")).toHaveTextContent(
      "The start date must be on or before the end date.",
    );
    expect(loadReport).toHaveBeenCalledTimes(callsBeforeInvalidRange);
  });

  it("shows the generating state and delegates export without a guessed format", async () => {
    const user = userEvent.setup();
    let finishExport: (() => void) | undefined;
    const exportReport = vi.fn(
      () =>
        new Promise<void>((resolve) => {
          finishExport = resolve;
        }),
    );
    render(
      <ReportsAndExportsPage
        adapter={makeAdapter(
          vi.fn(async () => readyReport),
          exportReport,
        )}
        copy={testCopy.reports}
        reportType="host-approved-type"
        tenantId="tenant-test"
      />,
    );

    await user.click(await screen.findByRole("button", { name: "Export report" }));
    expect(screen.getByRole("button", { name: "Generating report…" })).toBeDisabled();
    expect(exportReport).toHaveBeenCalledWith({
      tenantId: "tenant-test",
      reportType: "host-approved-type",
    });

    await act(async () => finishExport?.());
    expect(await screen.findByText("Export request completed by the host.")).toBeInTheDocument();
  });

  it("handles restricted and empty report states", async () => {
    const restricted = makeAdapter(vi.fn(async () => ({ state: "restricted" as const })));
    const first = render(
      <ReportsAndExportsPage
        adapter={restricted}
        copy={testCopy.reports}
        reportType="host-approved-type"
        tenantId="tenant-test"
      />,
    );
    expect(await screen.findByText("Reports access restricted")).toBeInTheDocument();
    first.unmount();

    render(
      <ReportsAndExportsPage
        adapter={makeAdapter(vi.fn(async () => ({ state: "empty" as const })))}
        copy={testCopy.reports}
        reportType="host-approved-type"
        tenantId="tenant-test"
      />,
    );
    expect(await screen.findByText("No report data for this period")).toBeInTheDocument();
  });
});
