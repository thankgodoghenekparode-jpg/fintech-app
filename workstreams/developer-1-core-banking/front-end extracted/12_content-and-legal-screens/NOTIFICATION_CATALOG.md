# Notification Catalogue (SHARED - identical in front-end and back-end)

Every notification has a key, recipients, channels and English copy (central text layer). Money and security messages use plain, precise wording. See delivery rules in `back-end/11_notifications/DELIVERY_RULES.md`.

## Core banking
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Credit received | Customer | Push, SMS | core.credit - '{amount} received from {sender}' |
| Debit alert | Customer | Push, SMS | core.debit - '{amount} sent to {name}' |
| Transfer pending | Customer | Push | core.transfer.pending - 'Your transfer is being confirmed' |
| Transfer failed and reversed | Customer | Push, SMS | core.transfer.failed - only when confirmed |
| New device login | Customer | Push, SMS, email | core.security.newdevice - 'If this was not you, lock your account' |
| PIN or passcode changed | Customer | Push, SMS | core.security.credentials |
| Account locked | Customer | Push, SMS | core.account.locked |
| KYC decision | Customer | Push, SMS | core.kyc.decision |
| Card created / frozen / transaction | Customer | Push | core.card.* |
| Statement ready | Customer | Push, email | core.statement.ready |
| Ticket update | Customer | Push, in-app | core.ticket.update |

## Instant Loan
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Offer/decision | Customer | Push, SMS | loan.decision |
| Disbursed | Customer | Push, SMS | loan.disbursed - '{amount} has been added to your account' |
| Due soon | Customer | Push, SMS | loan.due.soon |
| Overdue | Customer | Push, SMS | loan.overdue - helpful tone with hardship link |
| Repaid | Customer | Push | loan.repaid - limit increase offer |

## Cooperative
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Join request submitted | Admins | Push, in-app | coop.join.new - 'New request to join {coop}' |
| Join decision | Applicant | Push, SMS | coop.join.decision - 'Your request to join {coop} was {decision}' |
| Contribution due soon | Member | Push, SMS | coop.due.soon - '{coop}: {amount} due on {date}' |
| Auto-deduct failed | Member | Push, SMS | coop.autodeduct.failed - 'We could not collect {amount}. We will retry on {date}' |
| Guarantee requested | Guarantor | Push, SMS, in-app | coop.guarantee.request - '{name} asked you to guarantee a loan' |
| Loan decision | Borrower, guarantors | Push, SMS | coop.loan.decision |
| Repayment due | Borrower | Push, SMS | coop.loan.due |
| Recovery notice | Borrower, guarantors | Push, SMS, email | coop.loan.recovery.notice - action required |
| Large withdrawal notice | All members | Push, in-app | coop.withdrawal.notice - 'A withdrawal of {amount} has been requested' |
| Rule change notice | All members | Push, in-app | coop.rules.notice |
| Admin change | All members | Push, in-app | coop.admin.changed |

## Ajo / Esusu
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Invite received / joined | Creator, members | Push, SMS | ajo.member.joined |
| Contribution due soon | Member | Push, SMS | ajo.due.soon - '{circle}: {amount} due on {date}' |
| Auto-debit failed | Member | Push, SMS | ajo.debit.failed |
| Guarantee requested | Guarantor | Push, SMS | ajo.guarantee.request |
| Payout sent / received | Recipient | Push, SMS | ajo.payout.sent - 'You received {amount} from {circle}' |
| Shortfall notice | All members | Push, in-app | ajo.round.shortfall - round is waiting |
| Default notice | Group | Push, in-app | ajo.member.defaulted |
| Cycle complete | All | Push, in-app | ajo.cycle.complete |

## Pay Am Small
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Plan started | Customer, vendor | Push, SMS | pas.plan.started |
| Auto-debit failed | Customer | Push, SMS | pas.debit.failed |
| Deadline approaching | Customer | Push, SMS | pas.deadline.soon |
| Vault complete | Customer, vendor | Push, SMS | pas.vault.full |
| Delivery code | Customer | Push, SMS | pas.delivery.code |
| Order delivered | Customer | Push | pas.order.delivered |
| Credit request | Vendor | Push, email | pas.credit.request |

## Escrow
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Invite received | Counterparty | Push, SMS | esc.invite |
| Funded | Seller | Push, SMS | esc.funded - 'Funds are secured. You can proceed.' |
| Delivery submitted | Buyer | Push, SMS | esc.delivery.submitted |
| Auto-release soon | Buyer | Push, SMS | esc.autorelease.soon |
| Dispute opened | Both | Push, SMS | esc.dispute.opened |
| Dispute decision | Both | Push, SMS, email | esc.dispute.decided |
| Released | Seller | Push, SMS | esc.released |

## Revenue
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| New bill | Payer | Push, SMS | rev.bill.new - '{collector}: {amount} due on {date}' |
| Reminder | Payer | Push, SMS | rev.bill.reminder |
| Receipt | Payer | Push, SMS | rev.receipt - 'Payment of {amount} to {collector} received' |
| Dispute raised | Collector | Push, email | rev.dispute.raised |
| Cash outstanding | Treasurer | Push, email | rev.cash.outstanding |

## Target Savings
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Auto-save done | Customer | Push | tgt.auto.done |
| Auto-save skipped | Customer | Push | tgt.auto.skipped |
| Milestone | Customer | Push, in-app | tgt.milestone - 'You are {percent}% of the way to {goal}' |
| Goal matured | Customer | Push, SMS | tgt.matured |

## Merchant and Small-Business Tools
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Payment received | Business, payer | Push, SMS | mer.payment.received - '{amount} received from {payer}' |
| Invoice sent/reminder | Customer | SMS, email, link | mer.invoice.sent |
| Invoice overdue | Business | Push | mer.invoice.overdue |
| Refund issued | Payer | Push, SMS | mer.refund.issued |

## Cash-in / Cash-out Agent Network
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Cash-in credited | Customer | Push, SMS | agt.cashin.credited |
| Cash-out code created | Customer | Push | agt.cashout.code - 'Code {code} valid for {minutes} minutes' |
| Cash-out done | Customer, agent | Push, SMS | agt.cashout.done |
| Float low | Agent | Push, SMS | agt.float.low |
| Agent approved | Agent | Push, SMS | agt.approved |

## Spending Insights and Rewards
| Trigger | Recipients | Channels | Key and copy |
|---|---|---|---|
| Budget alert | Customer | Push | ins.budget.alert - 'You have used {percent}% of your {category} budget' |
| Monthly summary | Customer | Push, in-app | ins.summary.ready |
| Reward credited | Customer | Push | ins.reward.credited - 'You earned {amount}' |
| Referral paid | Referrer, referee | Push | ins.referral.paid |
