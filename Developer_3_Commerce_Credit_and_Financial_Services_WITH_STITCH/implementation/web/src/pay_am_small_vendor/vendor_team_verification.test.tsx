import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { PasVendorTeamVerificationPage } from "./vendor_team_verification";
import type { PasVendorTeamAdapter, PasVendorTeamCopy } from "./vendor_team_verification";

const copy: PasVendorTeamCopy = {
  title: "Team & Verification",
  subtitle: "Host-supplied team and business information",
  loading: "Loading team",
  error: "Team failed",
  retry: "Retry",
  unavailable: "No documented team endpoint",
  restricted: "Restricted",
  empty: "No team members supplied",
  team: "Team members",
  verification: "Business verification",
  search: "Search team members and roles",
  allMembers: "All team members",
  roles: "Roles & access",
  branch: "Branch",
  access: "Access scope",
  authorization: "Handover authorization",
  lastActive: "Last active",
  status: "Status",
  details: "Member permissions",
  permissions: "Permissions matrix",
  noPermissions: "No permissions supplied",
  noDocuments: "No documents supplied",
  notSupplied: "Not supplied",
  invite: "Invite new team member",
  inviteUnavailable: "No invite API documented",
  download: "Download verification dossier",
  update: "Update verification filings",
  security: "Store security protocol",
  rejectedReason: "Reason",
};

describe("W-PAS-007 Team & Verification", () => {
  it("renders only host-supplied members and rejected document reason, with unsupported actions disabled", async () => {
    const adapter: PasVendorTeamAdapter = {
      async loadTeam() {
        return {
          state: "ready",
          snapshot: {
            businessStatusLabel: "Verification status supplied",
            teamMembers: [
              {
                id: "member-1",
                name: "Host-supplied member",
                roleLabel: "Host-supplied role",
                statusLabel: "Active",
              },
            ],
            verificationDocuments: [
              {
                id: "doc-1",
                title: "Host-supplied document",
                statusLabel: "Rejected",
                rejectionReason: "Host-supplied reason",
              },
            ],
          },
        };
      },
    };
    render(<PasVendorTeamVerificationPage adapter={adapter} copy={copy} tenantId="tenant" />);
    expect(await screen.findAllByText("Host-supplied member")).toHaveLength(2);
    expect(
      screen.getByText(
        (_, element) =>
          element?.tagName === "SMALL" &&
          (element.textContent ?? "").includes("Host-supplied reason"),
      ),
    ).toBeInTheDocument();
    const inviteButtons = screen.getAllByRole("button", { name: "Invite new team member" });
    expect(inviteButtons).toHaveLength(2);
    inviteButtons.forEach((button) => expect(button).toBeDisabled());
  });

  it("shows unavailable state when the host does not supply team data", async () => {
    render(
      <PasVendorTeamVerificationPage
        adapter={{
          async loadTeam() {
            return { state: "unavailable" };
          },
        }}
        copy={copy}
        tenantId="tenant"
      />,
    );
    expect(await screen.findByText(copy.unavailable)).toBeInTheDocument();
  });
});
