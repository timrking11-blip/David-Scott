# Source spot-check, second draw (2026-11-06, cloud session)

Sample: `SEED=handoff-2026-11-06 bash verify.sh`, check S-01. Pool 49 S1 rows without "snippet only"; K = 10 drawn plus the 2 fixed IDs (E-SAGE-007, E-AI-053) = 12 rows. The first draw is in `spot-check-2026-11-06.md`.

How the sources were read: this cloud session's network does not reach these hosts, except platform.claude.com. That page was fetched directly; the other ten URLs were read through the Parallel web-fetch connector, which returns excerpts. The connector's cache dates are given where the page was not fetched live. Each claim was compared as written: numbers, units, plan or model names, edition and version.

| ID | Result | What the source says |
|---|---|---|
| E-AI-005 | Confirmed | Bots are "AI teammates" on "a persistent cloud computer with a browser, filesystem, and terminal"; included with X Subscription Premium, Super and Ultra, every paid legacy Cursor plan, and by linking an individual SuperGrok subscription. |
| E-AI-016 | Confirmed | Customer retains rights in Input and owns Output; "will not use any User Content to train"; deleted "no later than 30 days after the end of the interaction or session" unless an exception applies; De-Identified Data may be used "except when Customer elects to use ... ZDR". (Connector cache 2026-10-23.) |
| E-AI-021 | Confirmed | Sonnet 5.5 $2 / $10 per MTok; Haiku 5.5 $0.10 / $0.50 up to 100,000 prompt tokens, $0.50 / $2.50 over. Fetched directly. |
| E-AI-022 | Confirmed | Batch: Sonnet 5.5 $1 / $5, Haiku 5.5 $0.05 / $0.25 up to 100,000 tokens (50%); `inference_geo: "us"` applies a 1.1x multiplier. Fetched directly. |
| E-AI-028 | Partly confirmed | Prices match exactly: gpt-6.1-sol $2.00 / $10.00, gpt-6.1-terra $1.00 / $5.00, gpt-6-luna $0.10 / $0.50 (Standard). The "up to 272K tokens" qualifier is not visible in the excerpt; the page has a Short / Long context toggle, so the qualifier is plausible but unconfirmed here. |
| E-AI-042 | Confirmed | Supported document types list "Sales orders" and "Purchase orders"; PDFs up to 2,000 pages; 500 MB on the paid (S0) tier; structured JSON output. |
| E-AI-050 | Confirmed | AUP "applies to anyone using our Service, including consumers, developers and businesses"; Enterprise Terms 1.1(b) grant use of the APIs "to develop integrations between the Services and Customer's own products or services". The row's last clause is analysis drawn from these, not a quote. |
| E-AI-057 | Confirmed | Super $100/mo, $1000/yr ($84/mo); team Super seat $100 per seat; "List prices do not include sales tax." |
| E-SAGE-005 | Confirmed | Connects "without the need for Sage 50 to be launched"; a company "must have been opened in Sage 50 at least once"; "can only access one company at a time"; "There is no security model". (Guide dated 2025-09-19, version 2026.0.) |
| E-SAGE-037 | Confirmed | Subscription license "lasts only as long as your subscription remains active"; "must have the most current version"; on cancelling "will revert to read-only mode"; connected services need "an active subscription". (Connector cache 2026-02-22; the ledger access date is 2026-11-04.) |
| E-SAGE-007 [fixed] | Confirmed | Exclusive locks during backup or restore, changing accounting periods, changing posting method, User Security, Maintain Item Prices, closing payroll or fiscal year, posting, unposting, purging; and opening a company "while another user is doing one of these single-user processes". |
| E-AI-053 [fixed] | Confirmed | One address at `mail.grokbot.com` to "receive, read, search, and send"; routines on mail from chosen senders, by default only those passing email authentication, and "can't filter by subject"; Gmail can "search and read"; one-time codes from "a connected Gmail or Outlook account"; the Bot "asks which account to send from when either could work"; routine email "waits as a draft ... no option for unattended sending". |

Result: 11 confirmed, 1 partly confirmed, 0 contradicted. No price has changed since the ledger's access date.

Proposed follow-up for Timothy (not applied, since E-AI-028 is a frozen research row and changing it needs a ruling): either re-read the OpenAI page's Long-context view and keep the row, or narrow the Claim to drop "for context up to 272K tokens" under a ruling and re-baseline with `baseline-research-rows.sh`.
