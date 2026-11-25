export type TeamInviteRole = "MANAGER" | "CASHIER" | "ACCOUNTANT";
export type BusinessVerificationState = "pending" | "verified" | "rejected";

/** Host-mapped roster presentation data. This is not an API response DTO. */
export interface TeamMemberPresentation {
  readonly id: string;
  readonly name: string;
  readonly contact: string;
  readonly role: "OWNER" | TeamInviteRole;
  /** Permission descriptions come from the approved host mapping; the page cannot edit them. */
  readonly permissions: readonly string[];
}

/** Verification state is supplied by the host; no verification endpoint/schema is documented. */
export interface BusinessVerificationPresentation {
  readonly state: BusinessVerificationState;
  readonly message?: string;
  readonly rejectedReason?: string;
}

export interface TeamVerificationOverview {
  readonly members: readonly TeamMemberPresentation[];
  readonly verification: BusinessVerificationPresentation;
}

export interface TeamVerificationAdapter {
  loadOverview(input: { readonly tenantId: string }): Promise<TeamVerificationOverview>;
  /** Maps only the documented POST /business/team phone and role request. */
  inviteMember(input: {
    readonly tenantId: string;
    readonly phone: string;
    readonly role: TeamInviteRole;
  }): Promise<void>;
}
