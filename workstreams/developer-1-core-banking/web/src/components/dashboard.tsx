"use client";

import { useEffect, useState } from "react";
import { bankingApi, formatNaira, type Account, type Transaction } from "@/lib/api";

const navigation = [
  { name: "Overview", icon: "◫" },
  { name: "Payments", icon: "⇄" },
  { name: "Cards", icon: "▤" },
  { name: "Save & Borrow", icon: "▱" },
  { name: "More", icon: "•••" },
];

export function Dashboard() {
  const [active, setActive] = useState("Overview");
  const [showBalance, setShowBalance] = useState(true);
  const [account, setAccount] = useState<Account | null>(null);
  const [transactions, setTransactions] = useState<Transaction[] | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(false);

  async function loadAccount(signal?: AbortSignal) {
    setLoading(true);
    setLoadError(false);
    try {
      const [nextAccount, activity] = await Promise.all([
        bankingApi.getAccount(signal),
        bankingApi.getTransactions(signal),
      ]);
      setAccount(nextAccount);
      setTransactions(activity.items);
    } catch (error) {
      if (error instanceof DOMException && error.name === "AbortError") return;
      setLoadError(true);
    } finally {
      if (!signal?.aborted) setLoading(false);
    }
  }

  useEffect(() => {
    const controller = new AbortController();
    void loadAccount(controller.signal);
    return () => controller.abort();
  }, []);

  const money = (amount: number | undefined) => {
    if (loading) return "Loading…";
    if (!account) return "—";
    return showBalance ? formatNaira(amount ?? 0) : "₦ ••••••";
  };

  return (
    <main className="app-shell">
      <aside className="sidebar">
        <a className="wordmark" href="#home" aria-label="YourApp home"><span className="brand-mark">Y</span>YourApp</a>
        <div className="profile"><div className="avatar">JD</div><div><strong>Welcome back</strong><span>Personal account</span></div><span className="chevron">⌄</span></div>
        <nav aria-label="Main navigation" className="main-nav">
          <p className="nav-label">MENU</p>
          {navigation.map((item) => <button key={item.name} className={`nav-item ${active === item.name ? "selected" : ""}`} onClick={() => setActive(item.name)}><span className="nav-icon" aria-hidden="true">{item.icon}</span>{item.name}</button>)}
        </nav>
        <div className="sidebar-bottom"><div className="help-card"><span className="help-icon">?</span><strong>Need a hand?</strong><p>Our team is here to help you.</p><button onClick={() => setActive("Support")}>Get support <span>↗</span></button></div><button className="nav-item"><span className="nav-icon">⚙</span>Settings</button><div className="sidebar-footer">Secure banking, made for you</div></div>
      </aside>

      <section className="workspace" id="home">
        <header className="topbar"><div className="breadcrumbs">Personal <span>/</span> {active}</div><div className="top-actions"><button className="icon-button" aria-label="Notifications">♧<i /></button><button className="user-chip"><span className="avatar small">JD</span><span>My account</span><span>⌄</span></button></div></header>
        <div className="content">
          <div className="welcome-row"><div><p className="eyebrow">WEDNESDAY, 19 NOVEMBER</p><h1>{active === "Overview" ? "Good morning" : active}<span className="wave"> ✦</span></h1><p className="subtitle">Here&apos;s what&apos;s happening with your account today.</p></div><button className="secondary-button" onClick={() => setActive("Statements")}><span>↧</span> Download statement</button></div>

          {loadError && <div role="alert" className="load-error">We couldn&apos;t load your account. Check your connection and try again. <button onClick={() => void loadAccount()}>Retry</button></div>}
          <div className="summary-grid">
            <article className="balance-card"><div className="balance-top"><span>Available balance</span><button onClick={() => setShowBalance(!showBalance)} aria-label={showBalance ? "Hide balance" : "Show balance"}>{showBalance ? "◉" : "◎"}</button></div><div className="balance-amount">{money(account?.availableBalanceKobo)}</div><div className="account-row"><span className="account-dot" />{account?.accountName ?? "Personal account"}<span className="account-number">{account ? `•••• ${account.accountNumber.slice(-4)}` : ""}</span></div><div className="balance-actions"><button onClick={() => setActive("Payments")}>＋ Add money</button><button onClick={() => setActive("Payments")}>↗ Send money</button></div><div className="card-decoration decor-one"/><div className="card-decoration decor-two"/></article>

            <article className="stat-card"><div className="stat-heading"><span className="stat-icon purple">↗</span><span>Account details</span><button aria-label="More options">···</button></div><p className="stat-label">Account status</p><strong className="stat-amount">{loading ? "Loading…" : account?.status ?? "Unavailable"}</strong><div className="stat-note"><span className="muted-dot"/> Tier {account?.tier ?? "—"}</div><div className="stat-divider"/><p className="stat-label">Ledger balance</p><strong className="stat-amount">{money(account?.ledgerBalanceKobo)}</strong><div className="stat-note"><span className="muted-dot"/> Updated from your account</div></article>
          </div>

          <div className="section-heading"><div><h2>Quick actions</h2><p>What would you like to do?</p></div></div>
          <div className="quick-grid">
            {[{icon:"⇄", title:"Transfer", tint:"lavender"},{icon:"▤",title:"Pay a bill",tint:"peach"},{icon:"▱",title:"Save",tint:"mint"},{icon:"＋",title:"Add money",tint:"blue"}].map((action) => <button className="quick-action" key={action.title} onClick={() => setActive(action.title)}><span className={`quick-icon ${action.tint}`}>{action.icon}</span><span>{action.title}</span><span className="quick-arrow">↗</span></button>)}
          </div>

          <div className="section-heading transactions-heading"><div><h2>Recent activity</h2><p>Your latest account activity</p></div><button className="text-button" onClick={() => setActive("Transactions")}>View all <span>→</span></button></div>
          <div className="activity-card">{loading ? <div className="empty-activity" aria-live="polite">Loading recent activity…</div> : transactions?.length ? <div className="transaction-list">{transactions.map((item) => <div className="transaction-row" key={item.id}><span className={`transaction-icon ${item.direction === "C" ? "credit" : "debit"}`}>{item.direction === "C" ? "↓" : "↑"}</span><span className="transaction-name"><strong>{item.counterpartyName || item.narration || item.type}</strong><small>{new Date(item.createdAt).toLocaleString("en-NG", { dateStyle: "medium", timeStyle: "short", timeZone: "Africa/Lagos" })}</small></span><span className="transaction-amount"><strong>{item.direction === "C" ? "+" : "−"}{formatNaira(item.amountKobo)}</strong><small>{item.status}</small></span></div>)}</div> : <div className="empty-activity"><div className="empty-icon">↔</div><strong>{loadError ? "Activity unavailable" : "No transactions yet"}</strong><span>{loadError ? "Try again after your connection is restored" : "Your account activity will appear here"}</span></div>}</div>
          <footer className="page-footer"><span>© 2026 YourApp Financial Services</span><span><i className="secure-dot"/> Your account is secure</span></footer>
        </div>
      </section>

      <nav className="mobile-nav" aria-label="Mobile navigation">{navigation.map((item) => <button key={item.name} className={active === item.name ? "mobile-selected" : ""} onClick={() => setActive(item.name)}><span>{item.icon}</span>{item.name}</button>)}</nav>
    </main>
  );
}
