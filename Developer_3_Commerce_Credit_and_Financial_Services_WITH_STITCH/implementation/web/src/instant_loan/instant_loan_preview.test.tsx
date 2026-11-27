import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { InstantLoanPreview } from "../../preview/instant_loan_preview";

describe("Instant Loan web preview routes", () => {
  it("registers both back-office screens in its screen list", async () => {
    render(<InstantLoanPreview route="/backoffice/loans/applications" />);
    expect(screen.getByRole("link", { name: "W-LOAN-001" })).toHaveAttribute(
      "href",
      "/backoffice/loans/applications",
    );
    expect(screen.getByRole("link", { name: "W-LOAN-002" })).toHaveAttribute(
      "href",
      "/backoffice/loans/portfolio",
    );
    expect(await screen.findByText("Host data unavailable")).toBeInTheDocument();
  });

  it("opens the portfolio route and keeps the preview marked non-production", async () => {
    render(<InstantLoanPreview route="/backoffice/loans/portfolio" />);
    expect(screen.getByRole("link", { name: "Portfolio and collections" })).toHaveAttribute(
      "href",
      "/backoffice/loans/portfolio",
    );
    expect(screen.getByText(/NON-PRODUCTION PREVIEW/)).toBeInTheDocument();
    expect(await screen.findByText("Host data unavailable")).toBeInTheDocument();
  });

  it("registers product configuration and partner settlement routes", async () => {
    const { rerender } = render(<InstantLoanPreview route="/backoffice/loans/products" />);
    expect(screen.getByRole("link", { name: "W-LOAN-003" })).toHaveAttribute(
      "href",
      "/backoffice/loans/products",
    );
    expect(await screen.findByText("Host data unavailable")).toBeInTheDocument();
    rerender(<InstantLoanPreview route="/backoffice/loans/settlement" />);
    expect(screen.getByRole("link", { name: "W-LOAN-004" })).toHaveAttribute(
      "href",
      "/backoffice/loans/settlement",
    );
    expect(await screen.findByText("Host data unavailable")).toBeInTheDocument();
  });
});
