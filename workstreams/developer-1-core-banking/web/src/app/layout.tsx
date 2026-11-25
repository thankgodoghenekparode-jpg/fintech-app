import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "YourApp | Banking that moves with you",
  description: "Your everyday banking, in one place.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
