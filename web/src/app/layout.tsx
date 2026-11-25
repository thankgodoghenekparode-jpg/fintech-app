import type { Metadata } from 'next';
import './globals.css';
import { en } from '@/i18n/en';
import { AppProviders } from './providers';

export const metadata: Metadata = {
  title: en.app.title,
  description: en.app.description,
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body><AppProviders>{children}</AppProviders></body>
    </html>
  );
}
