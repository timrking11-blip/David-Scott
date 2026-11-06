# Findings summary

Sub-project 1, evidence and feasibility research. Client: Couple Dudes Doing Biz (stakeholder: Brad). Advisor: Timothy King. Date: 2026-11-06. Status: draft for review. Assessment view, not an approved v1 design.

Built from `evidence-ledger.md`, `connectivity-matrix.md` and `automation-feasibility-matrix.md` only; no new research was done. Every claim cites ledger IDs. Snippet-only rows count as S4. Prices are S1 with a date, or labelled "quoted, unverified" or "estimate". Where no method was found the wording is "No supported method found in sources checked". Nothing here records a vendor contact; every question is a draft in `vendor-questions.md` and every test is a draft in `poc-tests.md`.

## Where the evidence stands

- Of the 14 connectivity paths, one is Recommended for PoC (Sage: CSV import/export). Nine are Viable with conditions: Sage: manual entry (baseline), Sage: SDK or direct data access, Shipping: Unishippers portal, Shipping: Unishippers API, Shipping: multi-carrier tool, Flow: customer PO to Sage draft sales order, Flow: Sage sales order to shipment, Flow: Sage to dashboard (read-only) and Flow: email intake. One is Fallback only (Sage: UI automation (last resort)). Three are Unresolved: Sage: approved marketplace connector, Shipping: direct carrier API and Flow: tracking back to Sage.
- Brad runs Sage 50 Quantum Accounting 2026 (US), described as the "cloud version" [E-SAGE-053; DEC-09]. A-01 is confirmed by stakeholder report 2026-11-06 (E-SAGE-053), not verified; verify via Help, About. What "cloud version" means is open, and it decides where a Sage-facing component must run.
- No draft sales-order status was found in sources checked [E-SAGE-026], so the draft record is one of three untested options: (a) a sales order imported by CSV and held unprinted for human approval, where the import is confirmed and the hold-for-approval convention is untested [E-SAGE-023; E-SAGE-044]; (b) a quote created through the SDK [E-SAGE-003]; (c) a quote CSV template, if Sage confirms one exists, since a CSV template for quotes is not confirmed in sources checked [E-SAGE-023; E-SAGE-026]. A person signs off before an order is finalized [E-SAGE-043].
- Quotes arrive two ways: reps call in, and hospitals email. The quote is then built in Sage by hand [E-MAIL-018; DEC-11]. Phone quotes are outside email intake and stay manual.
- Email intake and PO extraction are the first automation steps, and neither writes to Sage [E-MAIL-015; E-AI-059].

## Assumptions register

| ID | Assumption | Basis | Consequence if wrong |
|---|---|---|---|
| A-01 | Brad runs US Sage 50 Accounting. Confirmed by stakeholder report 2026-11-06 (E-SAGE-053; DEC-09): Sage 50 Quantum Accounting 2026 (US), "cloud version"; verify via Help, About. Still open: the exact release (2026.0 or 2026.1), and what "cloud version" means. | DEC-02 (spec section 4); the confirmation is a stakeholder report (SR, E-SAGE-053), relayed second-hand and not verified. Applies to every Sage path and every flow that touches Sage. | The Canadian and UK/Ireland delta note is no longer needed unless the confirmation proves wrong. Edition-dependent items stay open: Sales Orders window and CSV template availability for Quantum [E-SAGE-017; E-SAGE-023], SDK build for the release [E-SAGE-019]. If "cloud version" means third-party hosting, the Sage-facing "Runs where" cells and the SDK and ODBC paths change [E-SAGE-029; E-SAGE-031]. |
| A-02 | "GrokBot super" means xAI Grok / SuperGrok (the consumer plan). | DEC-03 (spec section 4). Stakeholder intent unconfirmed [E-AI-001 to E-AI-004]. | The D4 xAI SuperGrok rows are re-pointed at the actual product. No matrix verdict relies on a Grok row, so none moves. |
| A-02b | The competing reading: "Grok Bot on the X Super plan", meaning the Grok Bot product reached through the X Subscription Super plan [E-AI-006; E-AI-051 to E-AI-058]. | Both a Grok Bot product and a Super tier exist, so the phrase fits either; the hypothesis is S4 inference from product names [E-AI-006]. | If right, the Grok Bot rows (E-AI-005, E-AI-051 to E-AI-058) replace the SuperGrok rows as the xAI comparison, and the terms that govern a Grok Bot seat remain unestablished [E-AI-051]. If neither reading is right, both sets are re-pointed at the actual product. No matrix verdict changes either way. |

Every finding that depends on an assumption carries its ID.

## Ranked unknowns

Ranked by how many verdicts and decisions each blocks, with P1 items first among ties (items that block email intake, PO extraction or the Sage CSV import come before the P3 tracking item).

1. What "cloud version" means, and which machine holds the company file [E-SAGE-053; E-SAGE-038; E-SAGE-045; E-SAGE-031; E-SAGE-029]. Blocks: where any Sage-facing component can run (SDK, ODBC reader, CSV import), and the "Runs where" hosting decision for sub-project 3. Sage is not installed on Brad's computer.
2. The exact Sage release, and whether the Sales Orders window and CSV templates exist for Quantum [E-SAGE-017; E-SAGE-018; E-SAGE-023]. Blocks: the Recommended for PoC verdict for Sage: CSV import/export, and the SDK build check for 2026.1 [E-SAGE-019].
3. Seat use and fees for the SDK [E-SAGE-011; E-SAGE-048; E-SAGE-008; E-SAGE-009; E-SAGE-010; E-SAGE-012]. Blocks: whether SAGE-SDK and any scheduled Sage read can go ahead with one reported seat, and the SDK cost line for the pilot.
4. Whether a quote converts to a sales order, and how to reverse a wrong import [E-SAGE-026; E-SAGE-044]. Blocks: the choice among the draft-record options (CSV sales order held unprinted, SDK quote, or CSV quote if a template exists) [E-SAGE-023; E-SAGE-003; E-SAGE-044], and how much human review must come before any import.
5. The email platform, who grants admin consent, and the volume split of quote requests versus POs [E-MAIL-012; E-MAIL-002; E-MAIL-017; E-MAIL-018]. Blocks: the email intake route (Microsoft Graph or Gmail) and the labelling rules.
6. Extraction accuracy on Brad's real documents, and vendor data-retention terms [E-AI-059; E-AI-024; E-AI-043; E-AI-047]. Blocks: the choice of extraction vendor and the build-or-skip decision for PO extraction.
7. Where a tracking number can be stored in Sage [E-SAGE-025; E-SAGE-042]. Blocks: whether tracking write-back is automated or stays manual.
8. Unishippers account type, portal and API access, migration date and void policy [E-SHIP-005; E-SHIP-008; E-SHIP-009; E-SHIP-015; E-SHIP-017; E-SHIP-012]. Blocks: the choice among portal, API and multi-carrier tool, and whether a test label can be issued without a billable charge.
9. Volumes and operating cost [spec section 4; E-MAIL-005; E-MAIL-011]. Blocks: every cost estimate. Reported volumes are unreconciled, so costs here are list prices only.
10. Which Grok product Brad means, and which terms govern a Grok Bot seat [E-AI-006; E-AI-051]. Blocks: whether an xAI product enters the comparison at all.
11. Address validation [E-SHIP-021; E-ECOM-017]. Blocks: the choice between Sage ship-to comparison and a paid address service. No evidence on address-validation services was gathered.

## Questions that change findings

Answers that would move a matrix verdict or priority. Draft IDs refer to `vendor-questions.md`.

| Question | Draft | Matrix verdict or priority that could change |
|---|---|---|
| What does "cloud version" mean: installed on a company machine or server, or third-party hosted? | B-19 | Every "Runs where" cell for Sage: CSV import/export, Sage: SDK or direct data access, Flow: Sage to dashboard (read-only) and Flow: tracking back to Sage; Sage: SDK or direct data access (Viable with conditions) and Flow: Sage to dashboard (read-only) could move if the company is third-party hosted [E-SAGE-029]. |
| Is the sales-order import template present in Brad's Quantum 2026 release, and does a quote import template exist at all (not confirmed in sources checked) [E-SAGE-023; E-SAGE-026]? | B-01; S-19; POC-01 steps 1 and 2 (S-13 covers unattended import only) | Sage: CSV import/export (Recommended for PoC) could drop to Viable with conditions or Unresolved; Flow: customer PO to Sage draft sales order (Viable with conditions) and the Sage draft sales order creation priority (P1) follow it. |
| Does an SDK or ODBC read or write count as a user on the one seat? | S-09, S-10 | Sage: SDK or direct data access and Flow: Sage to dashboard (read-only), both Viable with conditions, could move to Fallback only or Not viable; a person-run CSV read would remain. |
| What do the SDK Application ID and program cost, and can a single-client integrator qualify? | S-06, S-07, S-08 | Sage: SDK or direct data access (licensing Unresolved) and Sage: approved marketplace connector (Unresolved; OrderSync is a native SDK connector). |
| Must the SDK or ODBC reader run on the company-file host? | S-17, B-19 | The "Runs where" cells for Sage: SDK or direct data access, Flow: Sage to dashboard (read-only) and Flow: tracking back to Sage; the hosting plan. |
| Where can a tracking number be stored in Sage? | S-14, B-08 | Flow: tracking back to Sage (Unresolved) could move to Viable with conditions; Tracking retrieval and Sage update (P3) could change. |
| Is there a draft or hold state, does a quote convert to a sales order, and how is a wrong import reversed? | S-15 | Flow: customer PO to Sage draft sales order (Viable with conditions); priorities for Sage draft sales order creation (P1) and Human approval and Sage sales order finalization (P2). |
| Can Brad's Unishippers account issue the credentials the UPS by Unishippers connection needs? | U-12, V-04 | Shipping: multi-carrier tool (Viable with conditions); Shipment data preparation and issuance (P2). |
| Is Brad's account eligible for the Unishippers API, and which API generation applies? | U-09, U-10 | Shipping: Unishippers API (Viable with conditions). |
| Can a Unishippers-issued UPS account be linked to a customer UPS developer app, and at which rates? | U-20 | Shipping: direct carrier API (Unresolved). |
| What is the void policy for a Unishippers-invoiced label? | U-15 | Shipping: Unishippers portal and Shipping: multi-carrier tool (Viable with conditions); the SHIP-PORTAL test design. |
| Does ShipSync work with a Unishippers-issued account, and where does it store tracking? | V-03 | Shipping: multi-carrier tool, Flow: Sage sales order to shipment and Flow: tracking back to Sage. |
| Which email platform, and how will consent be granted? | B-12, M-01, M-04 | Flow: email intake (Viable with conditions); Email and attachment intake (P1). |
| How many emailed quote requests versus POs arrive in a month? | B-14 | Email and attachment intake and Customer PO extraction (P1 by exception, resting on stakeholder-reported shares) [E-MAIL-013; E-MAIL-018]. |
| How accurate is extraction on Brad's own documents? | PoC trial, not a vendor question | Customer PO extraction (P1 by exception) could drop in priority or change vendor. |
| Is any screen-automation approach acceptable under the Sage licence? | S-18 | Sage: UI automation (last resort) (Fallback only). |

## Priority note

Email and attachment intake and Customer PO extraction are P1 by an openly declared exception to spec 7.2 rule 5 (Ruling 30). Rule 5 asks for a Recommended for PoC path; only Sage CSV import and export meets that, and email intake is Viable with conditions on partly snippet-only evidence [E-MAIL-012]. They are P1 because each is low consequence and reversible, writes nothing to Sage, and feeds the Sage CSV import; extraction accuracy on Brad's documents is unmeasured [E-AI-059]. Sage draft sales order creation is P1 by rule 5.

The minimal pilot option is SAGE-CSV alone, with manual intake. A person receives the PO or quote request (by email or phone, E-MAIL-018), keys a sales-order CSV from the Sales Order Journal import fields, leaves the order unprinted for approval, and runs the import on the Sage machine; the import is confirmed, the hold-for-approval convention is untested, and a quote CSV is an option only if Sage confirms a quote template exists [E-SAGE-023; E-SAGE-026; E-SAGE-044]. It uses a built-in feature, needs no separate component and no developer registration, and keeps Brad's first step small [E-SAGE-023; E-SAGE-045; E-SAGE-050]. The release check, the template check and the import test come first [E-SAGE-017; E-SAGE-018].

## Handoffs

### To sub-project 2 (discovery kit and dashboard)

- Questions whose answers would change findings go into the discovery questionnaire: product line and edition (Quantum 2026 by stakeholder report, E-SAGE-053; verify via Help, About; exact release still open, B-01), company-file host and the meaning of "cloud version" (B-19, S-17), email platform (B-12) and Unishippers account type (U-05, B-10). The section "Questions that change findings" supplies the rest.
- Reported volumes (8,200 per year, 750 per month, 150 per week, 500 to 600 shipments per month) are unreconciled; reconciliation belongs here (spec section 4). Baselines for staff time are to be measured there [E-SAGE-041; E-SAGE-042; E-SHIP-033].
- Read-path findings define the dashboard's possible data sources and refresh cadence: read-only ODBC (Viable with conditions; scheduled pulls stored as snapshots with age shown), person-run CSV export (cadence is as often as someone runs it), an SDK read under SDK conditions, shipping status by portal, API or ShipStation (polling), email read with a safety-net listing, and WooCommerce as an optional partial product reference only [E-SAGE-021; E-SAGE-023; E-SAGE-047; E-SHIP-036; E-MAIL-014; E-ECOM-016; E-SAGE-054]. Sage is the product master for all products [E-SAGE-054; DEC-10]. Reconciliation and failure-recovery patterns are in the connectivity matrix's data-sharing assessment.
- Customer data without a CRM comes from Sage customer records, email and WooCommerce as a partial catalog reference, framed as low-cost options (DEC-06) [E-SAGE-023; E-MAIL-013; E-ECOM-016].

### To sub-project 3 (hosting, cost, pilot and memo)

- Sourced prices, with their labels: ShipStation Standard plan tiers 29.99 USD per month (50 shipments) to 89.99 USD (500), list price (S1, accessed 2026-11-04) [E-SHIP-030]; ShipSync 299 USD per year, quoted, unverified [E-SHIP-031]; Azure Document Intelligence prebuilt models 10 USD per 1,000 pages, quoted, unverified (read from a search extract, counted as S4, accessed 2026-11-04) [E-AI-041]; Sage plan prices are quoted, unverified and disagree [E-SAGE-050]. No per-read or CSV import fee was found in sources checked [E-SAGE-050]. Costs are list prices only because Brad's volumes are unknown.
- Licensing constraints: one reported Sage seat, and a single-user licence covers one individual [E-SAGE-012; E-SAGE-038]; SDK seat use and fees unresolved [E-SAGE-010; E-SAGE-011]; new Unishippers platform terms accepted at first use [E-SHIP-008]; UPS by Unishippers needs a paid ShipEngine plan [E-SHIP-012]; xAI consumer terms send scripted business use to the Enterprise terms [E-AI-001].
- "Runs where" constraints for hosting: the dashboard can be hosted anywhere [E-SAGE-045]. The SDK component needs a Windows machine with Sage 50 installed, planned on the company-file host until tested [E-SAGE-030; E-SAGE-031; E-SAGE-045]; whether Brad's "cloud version" is company-installed or third-party hosted is open [E-SAGE-053; B-19]. Nothing Sage-facing can run on Brad's computer [E-SAGE-038]. CSV import runs inside Sage on whichever machine opens the company [E-SAGE-045]. The portal, Unishippers API, ShipStation and UPS API are vendor-hosted; ShipSync needs Sage 50 on the shipping computer [E-SHIP-035; E-SHIP-024]. Email intake runs where its notice endpoint is hosted [E-MAIL-015].
- PoC tests seed the pilot plan: POC-01 SAGE-CSV first (the minimal pilot), then POC-06 MAIL-INTAKE, POC-03 SAGE-ODBC, POC-04 SHIP-PORTAL, POC-02 SAGE-SDK, POC-05 SHIP-MULTI and POC-07 SAGE-TRACKING. See `poc-tests.md`.

## Open questions

The three non-blocking questions from spec section 14, as they stand after the 2026-11-06 answers, then those found during the research. Each names the decision it blocks.

1. Does Timothy have a transcript or notes from the tl;dv meeting? If so, they are added as stakeholder-reported inputs. The recording needs a sign-in and was not reviewed; no finding cites it (spec section 4). Blocks: a second account of the stakeholder-reported rows [E-SAGE-038 to E-SAGE-043; E-SAGE-053; E-MAIL-013; E-MAIL-018].
2. Is "Couple Dudes Doing Biz" the client's real business name, and fine to use in client-facing deliverables? (Assumed yes.) Blocks: whether client-facing versions can carry the name.
3. Can Brad share a screenshot of Sage's Help, About screen? The edition is stated by stakeholder report as Quantum Accounting 2026 [E-SAGE-053]; the screenshot would verify it and settle the exact release (2026.0 or 2026.1). Blocks: the CSV template check [E-SAGE-017; E-SAGE-023] and the SDK build check, since the S1 SDK pages cover release 2026.0 [E-SAGE-018; E-SAGE-019].
4. What does "cloud version" mean for Brad's Sage 50 Quantum 2026: installed on a company Windows machine or server, or hosted by a third party, and which machine holds the company file (B-19; E-SAGE-053)? Blocks: where a Sage-facing component can run, and whether the SDK and ODBC paths are open at all [E-SAGE-029; E-SAGE-031; E-SAGE-045].
5. Which exact release is installed (2026.0 or 2026.1), and are the Sales Orders window and the quote and sales-order CSV templates present for Quantum [E-SAGE-017; E-SAGE-018; E-SAGE-023]? Blocks: the Recommended for PoC verdict for Sage: CSV import/export and the SDK build match [E-SAGE-019].
6. Does a Sage quote convert to a sales order, and how is a wrong import reversed [E-SAGE-026]? The sources checked do not establish either. Blocks: the choice among the draft-record options, and the human review step before any import [E-SAGE-023; E-SAGE-044; E-SAGE-046].
7. Quote volumes: how many emailed quote requests versus POs arrive in a typical month, and does the website take any quote requests (B-14)? The channels are known [E-MAIL-018; DEC-11]; the counts and the website question are not. Blocks: the labelling rules and the volume behind the Sage quote step [E-MAIL-017].
8. No evidence was gathered on address-validation services. The low-cost option in the matrix is comparison with Sage ship-to records [E-ECOM-017]. Blocks: the address leg of Quantity, price and address validation (P2) and any cost line for it [E-SHIP-021].
9. Costs are list prices only because Brad's volumes are unknown. Blocks: every operating-cost estimate in sub-project 3 and the benefit sizing in the automation matrix [E-MAIL-013; E-SAGE-041].
10. Which terms govern a Grok Bot seat bought through an X Subscription [E-AI-051]? The Grok Bot Terms and the Cursor Terms of Service do not say, and the SpaceXSI Subscription Terms were not read [E-AI-052]. Blocks: whether Grok Bot can enter the AI comparison under A-02b.

## Recorded decisions

| ID | Decision | Evidence |
|---|---|---|
| DEC-06 | No CRM, by stakeholder preference. HubSpot and Zoho are out of v1 scope. Customer-data needs (customer master, contacts, PO history) are met by Sage customer records, email and WooCommerce as catalog reference, all framed as low-cost options and never as a CRM purchase. | E-ECOM-015; E-ECOM-014 |
| DEC-07 | A CRM-free workflow summary (`workflow-summary.md`) was added as a seventh deliverable. It is an assessment view built only from the ledger and matrices, labelled "Assessment view - not an approved v1 design (Stage B)". | Spec section 15 |
| DEC-08 | WooCommerce is the product catalog only. It is not an intake channel in v1; all customer intake is by email. | E-ECOM-013; E-ECOM-014; E-MAIL-013 |
| DEC-09 | Brad runs Sage 50 Quantum Accounting 2026 (US), described as the "cloud version". A-01 is confirmed by stakeholder report 2026-11-06 (E-SAGE-053); verify via Help, About. The meaning of "cloud version" and the exact release stay open. | E-SAGE-053 |
| DEC-10 | Sage is the product master for all products, newly introduced and standard. The WooCommerce website carries some but not all, so it is a partial reference and not an intake channel. | E-SAGE-054 |
| DEC-11 | Quotes arrive two ways: reps call in, and hospitals email. Phone quotes are outside email intake and stay manual. E-MAIL-016 is resolved. | E-MAIL-018; E-MAIL-016 |