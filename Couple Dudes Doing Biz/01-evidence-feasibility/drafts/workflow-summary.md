# Workflow summary with no CRM (DEC-06, DEC-07)

Assessment view — not an approved v1 design (Stage B)

Sub-project 1, evidence and feasibility. Client: David Scott Company (stakeholder: Brad). Advisor: Timothy King. Draft of 2026-11-06, written under plan Task 11. Status: draft; it is promoted only on Timothy's go (plan Task 10).

What this is: one page that follows an order from the inbox to the tracking number, first as it runs today and then with the best-rated option for each step, using only the evidence ledger and the two matrices. It recommends no CRM: the stakeholder sees no need for one (DEC-06; E-ECOM-015). Every connectivity verdict and feasibility priority below is copied from `connectivity-matrix.md` and `automation-feasibility-matrix.md`; if the two disagree with this page, the matrices win.

Assumptions carried: Sage is reported as Quantum 2026 (stakeholder-reported, E-SAGE-053; A-01, verify via Help, About). The mail platform is not known yet, so every mail step is conditional on Microsoft 365 or Google Workspace (B-12). Nothing here has been tested; the PoC names point to `poc-tests.md`.

## Current workflow

The steps today, from the stakeholder-reported rows only. None of these has been observed; each needs validation (questions B-04 to B-14).

| Step | Person or system | Manual effort | Evidence IDs |
|---|---|---|---|
| 1. A customer PO or quote request arrives | Buyers email POs (about 90 percent); hospitals email quote requests; reps phone quotes in. Staff read the email or take the call | Every message is read and sorted by hand; phone quotes have no written intake | E-MAIL-013; E-MAIL-016; E-MAIL-018 |
| 2. A quote is built | Staff, in Sage 50 | Built by hand in Sage | E-MAIL-018 |
| 3. The order is entered in Sage | Staff, in Sage 50 (one seat, not installed on Brad's computer) | Typed by hand. About 80 to 85 percent of orders use standard products already set up in Sage; custom and new products take extra manual entry | E-SAGE-041; E-SAGE-038; E-SAGE-039; E-SAGE-040; E-SAGE-054 |
| 4. Sign-off before the order is final | A person | Human sign-off must remain before orders are finalized | E-SAGE-043 |
| 5. Print, pick and pack | Staff | The order is printed, then picked and packed by hand | E-SAGE-041 |
| 6. Shipping is arranged | Staff, through Unishippers | Arranged by hand after packing; the Unishippers tool and account type are not confirmed | E-SHIP-033; E-SHIP-005 |
| 7. Tracking goes back into Sage | Staff, in Sage 50 | Each tracking number is typed back in by hand | E-SAGE-042 |
| 8. Stock is checked and supplier POs are raised | Not reported | Unresolved: the stakeholder has not described how reorders are decided today | Unresolved |

The product master for every product is Sage; the WooCommerce website carries some products and serves mainly as a catalog (E-SAGE-054; E-ECOM-013; E-ECOM-014).

## Assessed workflow

The same steps with the best-rated option for each, one row per automation-matrix task. "Connectivity verdict" is the verdict of the connectivity-matrix path the step depends on, named in brackets. No step lets an agent finalize a Sage order, issue a shipment or send a supplier PO (E-SAGE-043).

| Step | System that does it | Human approval point | Connectivity verdict | Feasibility priority | Evidence IDs |
|---|---|---|---|---|---|
| Email and attachment intake (steps 1 and 2) | Email: the orders mailbox read through the Microsoft 365 or Google Workspace API, with rule-based labels (PoC: MAIL-INTAKE). Phone quotes stay a person's task | A person works the unsorted queue of unclear messages and spot-checks the labels; no record is created at this step | Viable with conditions [Flow: email intake] | P1 | E-MAIL-012; E-MAIL-017; E-MAIL-013; E-MAIL-016; E-SAGE-043 |
| Customer PO extraction (step 3) | AI extraction into a fixed schema, then deterministic checks; document text is handled as untrusted data and the model holds no write tools | A person confirms or corrects every extracted field set before any Sage record is created | Viable with conditions [Flow: customer PO to Sage draft sales order] | P1 | E-AI-059; E-AI-026; E-SAGE-043 |
| Customer and SKU matching (step 3) | Sage 50 reference data through CSV export, deterministic lookup first, AI suggestions for unmatched lines | A person confirms every non-exact match and every custom or new product | Recommended for PoC [Sage: CSV import/export] | P2 | E-SAGE-023; E-ECOM-017; E-SAGE-040; E-SAGE-054 |
| Quantity, price and address validation (step 3) | Sage 50 data read through CSV export by a person, or read-only ODBC with seat use unresolved | A person reviews every flagged exception and approves the final values | Recommended for PoC [Sage: CSV import/export]; Viable with conditions [Sage: SDK or direct data access] | P2 | E-SAGE-021; E-SAGE-023; E-SAGE-051 |
| Sage draft sales order creation (step 3) | Sage 50: a CSV import run by a person on the Sage machine (PoC: SAGE-CSV). The record type is open: option (a) a sales order held unprinted, option (b) a quote through the SDK, option (c) a quote by CSV if Sage confirms a template (S-19); none is tested or chosen | A person approves the import file before it is loaded | Recommended for PoC [Sage: CSV import/export]; Viable with conditions [Flow: customer PO to Sage draft sales order] | P1 | E-SAGE-023; E-SAGE-044; E-SAGE-026; E-SAGE-046 |
| Human approval and Sage sales order finalization (step 4) | Sage 50, by a named person, with a deterministic review sheet | A named person reviews the validated record and finalizes the Sage sales order; no agent or script finalizes it | Viable with conditions [Sage: manual entry (baseline)] | P2 | E-SAGE-043; E-SAGE-051 |
| Shipment data preparation and issuance (steps 5 and 6) | Unishippers or its tools: data prepared from the approved order, then a person issues the label in the myUnishippers portal (PoC: SHIP-PORTAL), with ShipStation as the comparison (PoC: SHIP-MULTI) | A human authorizes every label before it is issued; no agent issues a shipment | Viable with conditions [Flow: Sage sales order to shipment]; Viable with conditions [Shipping: Unishippers portal]; Viable with conditions [Shipping: multi-carrier tool] | P2 | E-SHIP-037; E-SHIP-006; E-SHIP-012 |
| Tracking retrieval and Sage update (step 7) | Unishippers or its tools for the read; the write into Sage 50 stays manual until tested (PoC: SAGE-TRACKING) | A person approves each tracking update before it is entered in Sage | Unresolved [Flow: tracking back to Sage] | P3 | E-SAGE-025; E-SAGE-042; E-SAGE-043 |
| Inventory monitoring and supplier PO recommendation (step 8) | Sage 50 data through CSV export or read-only ODBC, feeding a deterministic reorder list | The output is a recommendation only; a human authorizes every supplier PO, and no agent sends one | Recommended for PoC [Sage: CSV import/export] | P2 | E-SAGE-021; E-SAGE-023; E-SAGE-052 |

The read-only dashboard path is rated Viable with conditions [Flow: Sage to dashboard (read-only)]. It has no row in the automation matrix, so it carries no priority here. WooCommerce takes no step: it is not an intake channel (DEC-08), only a partial, read-only product reference (E-ECOM-016).

## Where customer data lives

With no CRM (DEC-06; E-ECOM-015), customer data stays where it is today. Nothing below adds a new system of record.

| Data | Where it lives | How it can be read | Evidence IDs |
|---|---|---|---|
| Customer IDs, ship-to addresses, products and order history | Sage 50 customer and sales records, the system of record | CSV export run by a person, or read-only ODBC (32-bit, separate data-access password); a customer CSV import template is not confirmed (S-19) | E-SAGE-023; E-SAGE-021; E-ECOM-017 |
| Purchase orders, quote requests and correspondence | The orders mailbox and staff email history | If Microsoft 365, Graph with Mail.Read; if Google Workspace, the Gmail API with a read-only scope. The platform and mailbox type are not known (B-11, B-12) | E-MAIL-001; E-MAIL-006; E-MAIL-004; E-MAIL-012 |
| Phone quote requests from reps | Nowhere until the quote is built in Sage | Only through the Sage quote | E-MAIL-018 |
| Product listings shown on the website | WooCommerce, for some products only | REST API with a read-only key, as a partial product reference; whether Woo holds any customer or order records is not known (B-15) | E-ECOM-001; E-ECOM-002; E-ECOM-013; E-ECOM-016 |
| Leads and follow-up outside Sage and email | Not known | Asked only to describe current practice, with no CRM in scope (B-17; DEC-06) | E-ECOM-015 |

## Low-cost options

Only steps that need a tool beyond Sage, email and Unishippers are listed. Prices are list prices with the ledger's access date of 2026-11-04, or labelled "quoted, unverified". Brad's volumes are unknown, so no monthly total is estimated (findings-summary open question 9).

| Step that needs a tool | Lowest-cost options in the ledger | Price as recorded | Evidence IDs |
|---|---|---|---|
| Customer PO extraction | Amazon Textract Analyze Expense | 0.01 USD per page for the first million pages, free tier of 100 pages a month for new customers (S1, accessed 2026-11-04); validation for purchase orders is unconfirmed (O-08) | E-AI-045 |
| Customer PO extraction | Azure AI Document Intelligence prebuilt models | 10 USD per 1,000 pages, free tier of 500 pages a month (S1 page, status hypothesis, accessed 2026-11-04) | E-AI-041 |
| Customer PO extraction and match suggestions | Low-cost model APIs | Claude Haiku 5.5 at 0.10 USD input and 0.50 USD output per million tokens, half that by Batch API (S1, accessed 2026-11-04); Gemini 2.5 Flash-Lite at 0.10 and 0.40 USD (S1, accessed 2026-11-04); gpt-6-luna at 0.10 and 0.50 USD (S1, accessed 2026-11-04) | E-AI-021; E-AI-022; E-AI-034; E-AI-028 |
| Sage draft sales order creation | Sage 50 built-in CSV import | No added tool; included in Sage 50 | E-SAGE-023 |
| Sage draft sales order creation, option (b) | Sage 50 US SDK | Sage describes the SDK as free (S2); the Application ID cost for a production company is unresolved (S-06) | E-SAGE-008; E-SAGE-009; E-SAGE-010 |
| Shipment issuance comparison | ShipStation | Comparison only: Standard from 29.99 USD per month for 50 shipments (S1, accessed 2026-11-04); use of Brad's Unishippers credentials is unconfirmed (U-12) | E-SHIP-030; E-SHIP-012 |
| Shipment issuance comparison | ShipSync on the Sage Marketplace | Comparison only: 299 USD per year, quoted, unverified | E-SHIP-031 |
| Email intake | Microsoft Graph or Gmail API | Unresolved: no price row in the ledger, and any charge for Graph application-permission mail calls is a vendor question (M-02) | E-MAIL-012 |

Not listed as low-cost: the WooCommerce-to-Sage connector found is quoted, unverified at 599 USD per month and is not confirmed for US Sage 50 (E-ECOM-004; E-ECOM-005). No CRM option is listed: the paid Sage 50 sync apps found for HubSpot and Zoho are excluded by DEC-06 (E-ECOM-008; E-ECOM-011; E-ECOM-015).

## Open questions

Each names the decision it blocks. Question IDs refer to `vendor-questions.md`; none has been sent.

1. What does "cloud version" mean for Brad's Sage 50, and which machine holds the company file (B-19)? Blocks: where any Sage-facing step can run, and whether the SDK and ODBC reads are open at all [E-SAGE-053].
2. Does Quantum 2026 have CSV import templates for quotes, purchase orders and customers (S-19), can a quote convert to a sales order, and how is a wrong import reversed? Blocks: the choice among draft-record options (a), (b) and (c), and the customer-data read in "Where customer data lives" [E-SAGE-023; E-SAGE-026; E-SAGE-044].
3. Which platform hosts the orders mailbox, and is it shared or personal (B-11, B-12)? Blocks: which mail API the intake step uses, and who grants admin consent [E-MAIL-004; E-MAIL-012].
4. Can Brad's Unishippers credentials be used with ShipStation or ShipEngine (U-12), and is there a no-cost test account (U-22)? Blocks: the SHIP-MULTI comparison and any label test, since Brad's live account is never used [E-SHIP-012; E-SHIP-037].
5. Where is the tracking number recorded in Sage today, and who enters it (B-08)? Blocks: the target field for the tracking step, which stays Unresolved [E-SAGE-025; E-SAGE-042].
6. How are stock levels checked and supplier POs decided today? This is new and not yet drafted in `vendor-questions.md`; it is proposed for Timothy's review. Blocks: the current-workflow row for step 8 and the inputs to the reorder list [E-SAGE-052].
7. Brad's monthly volumes of POs, quotes and shipments (B-13, B-14). Blocks: every cost line above and the benefit sizing in the automation matrix [E-MAIL-013; E-SAGE-041].
