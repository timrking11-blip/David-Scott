# Source spot-check, 2026-11-06 (spec §11 criterion 7)

Ledger: `01-evidence-feasibility/drafts/evidence-ledger.md`. Sample: 10 rows. Every Source URL was re-opened on 2026-11-06. No sign-in, no forms.

| ID | Verdict | Evidence (≤15 words) | Discrepancy, if any |
|---|---|---|---|
| E-AI-011 | confirms | Page title "Terms of Service - Enterprise \| SpaceXSI"; "SpaceXAI LLC ("SpaceXSI")" | WebFetch got HTTP 403. The alternative fetch tool read a cached copy dated 2026-10-23. Only the legal page was checked; the claim's "documentation pages" part was not re-checked. |
| E-AI-029 | confirms | gpt-6.1-terra Batch $0.50 input, $2.50 output; "10% uplift for models released on or after March 5, 2026" | The page gives no "50%" figure. The half-price discount comes from comparing the Batch and Standard tables. The quoted Batch prices are for short context (≤272K); long-context Batch is $1.00 / $3.75. |
| E-AI-034 | confirms | 2.5 Flash $0.30/$2.50; Flash-Lite $0.10/$0.40; 3.1 Pro Preview ≤200k $2.00/$12.00 | The URL now 301-redirects to aistudio.google.com/docs/pricing. The page says Gemini 2.5 Flash is deprecated and will route to Gemini 3.5 Flash-Lite from 2026-12-01. Prices match as of 2026-11-06. |
| E-AI-053 | partly confirms | "Email from a routine ... waits as a draft ... no option for unattended sending." | The claim says Outlook is described only for reading one-time codes. The page also says: "If you've also connected Gmail or Outlook, the Bot asks which account to send from". The routine trigger details (sender filter, authentication, no subject filter) are on computer-and-apps; the skills-routines page only says routines can start on email to the Bot's own address. Everything else is confirmed. |
| E-AI-057 | confirms | "$1000/yr ($84/mo)"; Super "$100 per seat"; "List prices do not include sales tax." | none ($100/mo also confirmed) |
| E-ECOM-001 | confirms | Headings: Create, Retrieve, List all, Update, Delete, Batch update products; WC 3.5+, WP 4.4+ | none. The page also documents "Duplicate product". As in the ledger, only the first part of the long page was read. |
| E-MAIL-008 | confirms | Super Admin grants delegation; "without requiring individual user consent"; "up to 24 hours" | none. The page names Gmail ("reading any user's Gmail"). |
| E-SAGE-001 | confirms | "Release 2026.0 the .NET SDK targets the .NET 4.8 framework"; "compiled for 32 bit" | none. Sage.Peachtree.API ships in the Sage 50 install. The PDF does not mention a web or REST API, which is consistent with the claim's negative statement. |
| E-SAGE-007 | confirms | Exclusive lock list incl. backup/restore, posting, unposting, purging; "Premium Accounting and higher" | Small scope difference: the page limits posting and unposting to the Tasks menu ("System, Post only" / "Unpost only"). The claim says posting and unposting without that limit. |
| E-SAGE-023 | partly confirms | Fields: "Customer ID", "SO/Proposal Number", "Date", "Ship By", "Customer PO", "Ship Via", "Ship to ..." | The cited page does not mention quote, purchase order or customer templates; it has only a "Quote #" field. The Sales Order Journal fields and CSV (default file "SO.CSV") are confirmed. |

## Totals

- Sampled: 10
- Confirms: 8 (E-AI-011, E-AI-029, E-AI-034, E-AI-057, E-ECOM-001, E-MAIL-008, E-SAGE-001, E-SAGE-007)
- Partly confirms: 2 (E-AI-053, E-SAGE-023)
- Contradicts: 0
- Unreachable: 0. E-AI-011 returned 403 to WebFetch but was read through the alternative fetch tool from a cached copy.
- Gated: 0
- Price changes found: none. All prices were checked on 2026-11-06.
