import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { EscrowTemplatesFeesPage } from "./template_fees_page";
import type {
  EscrowTemplateConfiguration,
  EscrowTemplatesFeesAdapter,
  EscrowTemplatesFeesCopy,
} from "./template_fees_types";

const copy = {
  eyebrow: "Escrow back office",
  title: "Templates and fees",
  subtitle: "Review supplied configuration.",
  loading: "Loading configuration",
  retry: "Retry",
  errorTitle: "Load failed",
  errorBody: "Load error body",
  unavailableTitle: "Unavailable",
  unavailableBody: "Unavailable body",
  restrictedTitle: "Restricted",
  restrictedBody: "Restricted body",
  emptyTitle: "No templates",
  emptyBody: "No templates supplied",
  templateLabel: "Template",
  templatePlaceholder: "Select template",
  templateSection: "Selected template",
  checkpointSection: "Checkpoints",
  checkpointHelp: "Checkpoint help",
  timerSection: "Timers",
  timerHelp: "Timer help",
  documentSection: "Documents",
  documentHelp: "Document help",
  feesSection: "Fees",
  feesHelp: "Fee help",
  unavailableValue: "Not supplied by host",
  approval: "Dual-control approval",
  approvalPending: "Pending approval",
  dualControlHelp: "Dual-control workflow",
  restrictedAction: "Action unavailable",
  submit: "Submit for approval",
  submitting: "Submitting",
  reviewTitle: "Review proposal",
  reviewBody: "Confirm proposed configuration",
  cancel: "Cancel",
  confirmSubmit: "Submit proposal",
  pendingTitle: "Proposal pending",
  pendingBody: "Awaiting approval",
  submitErrorTitle: "Proposal unavailable",
  submitErrorBody: "Proposal error",
  requiredField: (label: string) => `${label} required`,
} as EscrowTemplatesFeesCopy;

const template: EscrowTemplateConfiguration = {
  id: "00000000-0000-4000-8000-000000000004",
  name: "Synthetic test template",
  sections: [
    {
      id: "checkpoints",
      title: "Checkpoints",
      settings: [
        {
          id: "setting-checkpoint",
          label: "Inspection window",
          value: "Host supplied",
          kind: "text",
          editable: true,
        },
      ],
    },
    { id: "timers", title: "Timers and reminders", settings: [] },
    { id: "documents", title: "Required documents", settings: [] },
    {
      id: "fees",
      title: "Fee schedule and minimum charge",
      settings: [
        { id: "fee-value", label: "Fee field", value: null, kind: "number", editable: false },
      ],
    },
  ],
  canPropose: true,
};

function makeAdapter(
  loadConfigurations?: EscrowTemplatesFeesAdapter["loadConfigurations"],
  proposeConfiguration?: EscrowTemplatesFeesAdapter["proposeConfiguration"],
): EscrowTemplatesFeesAdapter {
  return {
    loadConfigurations:
      loadConfigurations ?? vi.fn(async () => ({ state: "ready" as const, templates: [template] })),
    proposeConfiguration:
      proposeConfiguration ??
      vi.fn(async () => ({
        state: "pending_approval" as const,
        statusLabel: "Host confirmed pending approval",
      })),
  };
}

describe("W-ESC-004 Templates and Fees", () => {
  it("renders host-mapped editor sections and unavailable fee values", async () => {
    render(<EscrowTemplatesFeesPage adapter={makeAdapter()} copy={copy} tenantId="tenant-a" />);
    expect(
      await screen.findByRole("heading", { name: "Synthetic test template" }),
    ).toBeInTheDocument();
    expect(screen.getByText("Checkpoints")).toBeInTheDocument();
    expect(screen.getByText("Timers and reminders")).toBeInTheDocument();
    expect(screen.getByText("Required documents")).toBeInTheDocument();
    expect(screen.getByText("Fee schedule and minimum charge")).toBeInTheDocument();
    expect(screen.getByPlaceholderText("Not supplied by host")).toBeDisabled();
  });

  it("validates host-required fields and sends a host change only after explicit confirmation", async () => {
    const requiredTemplate: EscrowTemplateConfiguration = {
      ...template,
      sections: [
        {
          ...template.sections[0],
          settings: [
            {
              id: "setting-checkpoint",
              label: "Inspection window",
              value: "Initial value",
              kind: "text",
              editable: true,
              required: true,
            },
          ],
        },
        ...template.sections.slice(1),
      ],
    };
    const adapter = makeAdapter(
      vi.fn(async () => ({ state: "ready" as const, templates: [requiredTemplate] })),
    );
    render(<EscrowTemplatesFeesPage adapter={adapter} copy={copy} tenantId="tenant-a" />);
    const field = await screen.findByLabelText("Inspection window");
    fireEvent.change(field, { target: { value: "Updated host setting" } });
    fireEvent.click(screen.getByRole("button", { name: "Submit for approval" }));
    expect(await screen.findByText("Review proposal")).toBeInTheDocument();
    expect(adapter.proposeConfiguration).not.toHaveBeenCalled();
    fireEvent.click(screen.getByRole("button", { name: "Submit proposal" }));
    await waitFor(() =>
      expect(adapter.proposeConfiguration).toHaveBeenCalledWith({
        tenantId: "tenant-a",
        templateId: requiredTemplate.id,
        changes: [{ settingId: "setting-checkpoint", value: "Updated host setting" }],
      }),
    );
    expect(await screen.findByText("Host confirmed pending approval")).toBeInTheDocument();
  });

  it("shows empty, restricted and retryable error states", async () => {
    const emptyAdapter = makeAdapter(vi.fn(async () => ({ state: "empty" as const })));
    const { unmount } = render(
      <EscrowTemplatesFeesPage adapter={emptyAdapter} copy={copy} tenantId="tenant-a" />,
    );
    expect(await screen.findByText("No templates")).toBeInTheDocument();
    unmount();

    const restrictedAdapter = makeAdapter(vi.fn(async () => ({ state: "restricted" as const })));
    const restricted = render(
      <EscrowTemplatesFeesPage adapter={restrictedAdapter} copy={copy} tenantId="tenant-a" />,
    );
    expect(await screen.findByText("Restricted")).toBeInTheDocument();
    restricted.unmount();

    const errorAdapter = makeAdapter(
      vi
        .fn()
        .mockRejectedValueOnce(new Error("offline"))
        .mockResolvedValue({ state: "ready", templates: [template] }),
    );
    render(<EscrowTemplatesFeesPage adapter={errorAdapter} copy={copy} tenantId="tenant-a" />);
    expect(await screen.findByText("Load failed")).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Retry" }));
    expect(
      await screen.findByRole("heading", { name: "Synthetic test template" }),
    ).toBeInTheDocument();
  });

  it("does not enable proposals for a host-restricted operator", async () => {
    const restrictedTemplate = {
      ...template,
      canPropose: false,
      restrictionMessage: "Product admin role required.",
    };
    render(
      <EscrowTemplatesFeesPage
        adapter={makeAdapter(
          vi.fn(async () => ({ state: "ready" as const, templates: [restrictedTemplate] })),
        )}
        copy={copy}
        tenantId="tenant-a"
      />,
    );
    expect(await screen.findByText("Product admin role required.")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Submit for approval" })).toBeDisabled();
  });

  it("locks the proposal action when the host returns restricted", async () => {
    const adapter = makeAdapter(
      undefined,
      vi.fn(async () => ({ state: "restricted" as const })),
    );
    render(<EscrowTemplatesFeesPage adapter={adapter} copy={copy} tenantId="tenant-a" />);
    const field = await screen.findByLabelText("Inspection window");
    fireEvent.change(field, { target: { value: "Updated setting" } });
    fireEvent.click(screen.getByRole("button", { name: "Submit for approval" }));
    fireEvent.click(await screen.findByRole("button", { name: "Submit proposal" }));
    expect(await screen.findByText("Action unavailable")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Submit for approval" })).toBeDisabled();
  });
});
