import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { testCopy } from "../test_copy";
import { TeamVerificationPage } from "./team_verification_page";
import type {
  TeamInviteRole,
  TeamVerificationAdapter,
  TeamVerificationOverview,
} from "./team_verification_types";

const overview: TeamVerificationOverview = {
  verification: {
    state: "pending",
    message: "Verification status supplied by host.",
  },
  members: [
    {
      id: "owner-1",
      name: "Ada Owner",
      contact: "+2348000000001",
      role: "OWNER",
      permissions: ["Business access review"],
    },
    {
      id: "cashier-1",
      name: "Tunde Cashier",
      contact: "+2348000000002",
      role: "CASHIER",
      permissions: ["Payment collection"],
    },
  ],
};

function makeAdapter(result = overview) {
  const loadOverview = vi.fn(async () => result);
  const inviteMember = vi.fn(
    async (_input: { tenantId: string; phone: string; role: TeamInviteRole }) => undefined,
  );
  const adapter: TeamVerificationAdapter = { loadOverview, inviteMember };
  return { adapter, loadOverview, inviteMember };
}

describe("W-MER-005 Team and verification", () => {
  it("renders host-mapped roster permissions and verification state without edit controls", async () => {
    const fixture = makeAdapter();
    render(
      <TeamVerificationPage
        adapter={fixture.adapter}
        copy={testCopy.teamVerification}
        tenantId="tenant-test"
      />,
    );

    expect(
      await screen.findByRole("heading", { name: "Team and verification" }),
    ).toBeInTheDocument();
    expect(screen.getByText("Pending verification")).toBeInTheDocument();
    expect(screen.getByRole("row", { name: /Ada Owner/ })).toBeInTheDocument();
    expect(screen.getByText("Business access review")).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: /remove|revoke|edit permission/i })).toBeNull();
    expect(fixture.loadOverview).toHaveBeenCalledWith({ tenantId: "tenant-test" });
  });

  it("shows the host-supplied rejected reason", async () => {
    const rejected: TeamVerificationOverview = {
      ...overview,
      verification: { state: "rejected", rejectedReason: "Document image was unreadable." },
    };
    render(
      <TeamVerificationPage
        adapter={makeAdapter(rejected).adapter}
        copy={testCopy.teamVerification}
        tenantId="tenant-test"
      />,
    );

    expect(await screen.findByText("Rejected")).toBeInTheDocument();
    expect(screen.getByText("Document image was unreadable.")).toBeInTheDocument();
  });

  it("invites with only tenant ID, phone and the selected documented role", async () => {
    const user = userEvent.setup();
    const fixture = makeAdapter();
    render(
      <TeamVerificationPage
        adapter={fixture.adapter}
        copy={testCopy.teamVerification}
        tenantId="tenant-test"
      />,
    );

    await user.click(await screen.findByRole("button", { name: "Invite team member" }));
    const dialog = screen.getByRole("dialog", { name: "Invite team member" });
    await user.type(within(dialog).getByLabelText("Phone number"), "+234 800 111 2233");
    await user.selectOptions(within(dialog).getByLabelText("Role"), "CASHIER");
    await user.click(within(dialog).getByRole("button", { name: "Send invite" }));

    await waitFor(() =>
      expect(fixture.inviteMember).toHaveBeenCalledWith({
        tenantId: "tenant-test",
        phone: "+234 800 111 2233",
        role: "CASHIER",
      }),
    );
    expect(await screen.findByText("Invite request completed by the host.")).toBeInTheDocument();
  });

  it("validates only a non-empty phone and offers retry after load failure", async () => {
    const user = userEvent.setup();
    const loadOverview = vi
      .fn<() => Promise<TeamVerificationOverview>>()
      .mockRejectedValueOnce(new Error("offline"))
      .mockResolvedValue(overview);
    const inviteMember = vi.fn(async () => undefined);
    const adapter: TeamVerificationAdapter = { loadOverview, inviteMember };
    render(
      <TeamVerificationPage
        adapter={adapter}
        copy={testCopy.teamVerification}
        tenantId="tenant-test"
      />,
    );

    expect(await screen.findByText("Team details unavailable")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: "Retry" }));
    expect(await screen.findByRole("button", { name: "Ada Owner" })).toBeInTheDocument();

    await user.click(screen.getByRole("button", { name: "Invite team member" }));
    const dialog = screen.getByRole("dialog", { name: "Invite team member" });
    await user.click(within(dialog).getByRole("button", { name: "Send invite" }));
    expect(await within(dialog).findByText("Enter a phone number.")).toBeInTheDocument();
    expect(inviteMember).not.toHaveBeenCalled();
  });

  it("renders an empty host roster without inventing team records", async () => {
    const empty = makeAdapter({ ...overview, members: [] });
    render(
      <TeamVerificationPage
        adapter={empty.adapter}
        copy={testCopy.teamVerification}
        tenantId="tenant-test"
      />,
    );

    expect(await screen.findByText("No team members yet")).toBeInTheDocument();
    expect(screen.getByText("Pending verification")).toBeInTheDocument();
  });
});
