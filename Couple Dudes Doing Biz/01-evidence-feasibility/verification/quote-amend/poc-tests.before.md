# Proof-of-concept tests

Sub-project 1, evidence and feasibility research. Client: Couple Dudes Doing Biz (stakeholder: Brad). Advisor: Timothy King. Date: 2026-11-06. Status: draft for review. Assessment view, not an approved v1 design.

Built from `connectivity-matrix.md` and `evidence-ledger.md` only. Nothing here has been run. The test names are frozen: SAGE-CSV, SAGE-SDK, SAGE-ODBC, SHIP-PORTAL, SHIP-MULTI, MAIL-INTAKE and SAGE-TRACKING.

Rules for every test:

- Setup uses synthetic or sandbox data only. No test touches Brad's live Sage company, his live Unishippers account, his orders mailbox or his website. Sage tests use the Sage 50 sample company (Bellwether, per E-SAGE-002) or a copy of a company made up for the test. A-01 applies: US Sage 50 Accounting; Brad is reported on Quantum 2026 (stakeholder report, E-SAGE-053), exact release unknown, so Quantum is used where available and the test machine's edition and release are written down at the start of each run.
- "Moves to PoC-validated" lists the ledger rows whose claim a passing run would test. A row moves only on the criterion that names it. No row is PoC-validated today (ledger conventions).
- A test that cannot be run as written is recorded as not run. It is never recorded as passed.
- Test documents are synthetic. Any document with embedded text that looks like an instruction is treated as data (E-AI-026).
- Seat rule: Brad reports one Sage seat, and Sage is not installed on his computer (E-SAGE-038). A test machine with its own Sage installation and licence for testing is needed, and whether a trial or developer copy is available is a question for Sage (see vendor-questions.md, S-09 and S-17).

## POC-01 — SAGE-CSV

Path: Sage: CSV import/export (matrix verdict: Recommended for PoC). This test also times the baseline Sage: manual entry (baseline) as the comparator, and covers the quote step of Flow: customer PO to Sage draft sales order. The email and extraction legs of that flow are covered by POC-06 for intake only; extraction accuracy is a trial on real documents, not a PoC here.

Setup:
- Sage 50 sample company on a machine with Sage installed; edition and release recorded (E-SAGE-017, E-SAGE-018).
- Synthetic files: a one-line sales order CSV, a one-line quote CSV, a customer CSV, built from the exact import templates (field count and order must match) (E-SAGE-023, E-SAGE-024).
- One deliberately broken file (a wrong field count) and one file with an unknown customer ID.

Steps:
1. Record whether the sales-order, quote and customer import templates appear for this edition (E-SAGE-017, E-SAGE-023).
2. Import the one-line sales order and the one-line quote into the sample company; note required fields (customer ID, SO number, date, ship-by date, customer PO, ship-via, ship-to) (E-SAGE-023).
3. (Note: record the result as "no draft status found" only if all quote and order screens were checked, E-SAGE-026.) Review both records in the Sage screens. Check whether a quote can be converted to a sales order, and whether a printed and an unprinted sales order can be told apart (E-SAGE-026, E-SAGE-044).
4. Import the broken file and the unknown-customer file; record the error text and whether any partial record landed (E-SAGE-024, E-SAGE-046).
5. Try to reverse each imported record using only the Sage screens; record the steps or that no way was found (E-SAGE-026).
6. Export the sales order, quote and customer data using the matching export templates; confirm the files re-import cleanly (E-SAGE-024).
7. Key three synthetic orders by hand (1, 5 and 20 lines) and time each, then time the CSV route for the same three. This is a tester's timing, not Brad's staff time (E-SAGE-041 stays stakeholder-reported; staff time is measured in sub-project 2).
8. Ask Sage whether import can run unattended (S-13) and record the written answer; scheduling is not tested by this run.

Pass criteria:
- The quote and sales-order import templates are present and a valid one-line file lands as a quote and as a sales order with every required field populated.
- The bad-field file is rejected with a readable error and creates no record.
- A landed record can be reviewed in the Sage screens, and a way to remove or void a wrong import is found and written down.
- Exports re-import without edits.
- Manual and CSV times are recorded for all three orders.

Fail criteria:
- A template is missing for the edition, or a valid file does not land.
- A bad file creates a partial or live record that cannot be removed.
- No way to review a quote before it is used, or no way to reverse a wrong import is found.

Moves to PoC-validated (on pass): E-SAGE-023, E-SAGE-024, E-SAGE-026, E-SAGE-044 (the quote and printed-versus-unprinted checks only). Open after this test regardless: unattended import (Sage answer), E-SAGE-017 edition (Brad's own edition, not the test machine's).

## POC-02 — SAGE-SDK

Path: Sage: SDK or direct data access (matrix verdict: Viable with conditions). Also covers the SDK quote half of Flow: customer PO to Sage draft sales order.

Setup:
- Sage 50 sample company, release 2026.0 (the release the S1 SDK pages cover) on a Windows test machine with a 32-bit .NET Framework 4.8 caller (E-SAGE-001, E-SAGE-030).
- An Application ID obtained through Sage (cost and eligibility unresolved, E-SAGE-008, E-SAGE-009, E-SAGE-010). Cost gate: it is not obtained unless the fee is written and the step runs only at no cost (free tier or vendor-confirmed non-billable), or with spend approved in advance by Timothy. If an Application ID cannot be obtained under the gate, this test is not run and the verdict stays Viable with conditions on that ground.
- Synthetic customer, item, quote and sales order data only.

Steps:
1. Complete the one-time approval inside Sage 50 and record any Pending or locked results (E-SAGE-006).
2. Create, read, update and delete a sales order, and create a quote, in the sample company (E-SAGE-002, E-SAGE-003). Record whether a company without AR history rejects the first quote (E-SAGE-003).
3. Run the client as a scheduled task or service in a non-interactive session; record whether it opens the company (E-SAGE-005).
4. Hold an SDK session open and attempt a backup in Sage 50; record which blocks which (E-SAGE-007).
5. With one Sage user signed in, attempt an SDK connection; record whether it connects and whether Sage reports it as a user (E-SAGE-011, E-SAGE-048).
6. Open a test company from a second machine, over a share, and record the result (E-SAGE-031, E-SAGE-045).
7. Record the installed release against the SDK build available (E-SAGE-019, E-SAGE-020).

Pass criteria:
- Sales order create, read, update and delete and quote create all succeed on the sample company.
- The client runs unattended, or the need for an interactive session is documented.
- Seat behaviour with one user signed in is observed and written down, whichever way it goes.
- The result of the second-machine test is recorded.

Fail criteria:
- Order update or delete fails (the forum-snippet claim E-SAGE-002 is not borne out).
- The client cannot connect while the single user is signed in, and Sage's written answer does not allow it.
- An idle SDK session blocks a backup in a way that cannot be scheduled around.
- Gate not met (cost gate on the Application ID; recorded as not run).
- No Application ID can be obtained at a cost the pilot can bear (fees are a Sage answer, S-06 to S-08, not a test result).

Moves to PoC-validated (on pass): E-SAGE-002, E-SAGE-003, E-SAGE-005, E-SAGE-007, E-SAGE-011, E-SAGE-031, E-SAGE-045, E-SAGE-048. Fees and licence terms (E-SAGE-008 to E-SAGE-010, E-SAGE-012) cannot be proven by a test and stay vendor questions.

## POC-03 — SAGE-ODBC

Path: Flow: Sage to dashboard (read-only) (matrix verdict: Viable with conditions). The path is read-only, so no Sage record changes.

Setup:
- Sage 50 sample company with a data-access password set in User Security (E-SAGE-021).
- The Pervasive client and 32-bit ODBC driver on the reading machine (E-SAGE-021).
- A second machine for the remote-read step (E-SAGE-022).

Steps:
1. Read the sales order and inventory tables from the sample company over ODBC and time a full refresh and a date-filtered refresh (E-SAGE-021, E-SAGE-047).
2. Compare record counts and totals with a Sage report run by a person (E-SAGE-047).
3. Connect from a second machine to a test host using the client interface and read the same tables (E-SAGE-022).
4. With one Sage user signed in, run an ODBC read and record whether it connects and whether it blocks or is blocked (E-SAGE-011, E-SAGE-048).
5. Cause a lock (for example an exclusive operation) and record how the read fails, and that the last good snapshot remains usable (E-SAGE-007, E-SAGE-047).
6. Change the data-access password and record the failure message (E-SAGE-047).
7. Ask Sage whether ODBC is acceptable for unattended scheduled reads (S-12) and record the written answer.

Pass criteria:
- The sales order and inventory tables are readable with row counts equal and totals agree to the cent with a Sage report.
- A refresh time is measured and written down.
- A second-machine read works, or the failure is recorded.
- Failure cases leave the last good snapshot intact.

Fail criteria:
- Tables cannot be read, or totals cannot be reconciled to a Sage report.
- A read cannot run while a Sage user is signed in and no time window is workable.
- The second-machine read fails and no other reader placement works.

Moves to PoC-validated (on pass): E-SAGE-021, E-SAGE-022, E-SAGE-047, E-SAGE-048 (ODBC read only). Sage support limits for third-party ODBC tools (E-SAGE-021) are a Sage statement and stay as stated.

## POC-04 — SHIP-PORTAL

Path: Shipping: Unishippers portal (matrix verdict: Viable with conditions). This test also covers Flow: Sage sales order to shipment (export one order and key it into the portal) and a documentation-only check of Shipping: Unishippers API (matrix verdict: Viable with conditions).

Setup:
- No Unishippers test or sandbox mode is documented in the ledger. Part A below needs no label and can run with synthetic addresses. Part B issues a label, which on a real account creates a billable shipment (E-SHIP-037), so Part B uses only a Unishippers-provided test or demo account, requested via U-22, and the cost gate applies: it runs only at no cost (free tier or vendor-confirmed non-billable), or with spend approved in advance by Timothy. If no such account is provided, or the gate is not met, Part B is recorded as not run, and any criterion that depends on it stays unmet. Brad's live account is never used.
- A synthetic sales order exported from the sample company by CSV (from POC-01), with synthetic ship-to data (E-SAGE-023).

Steps:
Part A (no label):
1. Using Brad's portal screenshot and a recent invoice (real documents supplied by Brad, read only; no action on his account), record the account type, enabled tools and migration state (E-SHIP-005, E-SHIP-008).
2. Take the exported synthetic order and list which shipping fields the portal needs (address, weight, service, dimensions) and which are not on the Sage order (E-SHIP-033, E-SAGE-023).
3. Compare rates for the synthetic parcel and record the fields requested (E-SHIP-006).
4. Request the Unishippers API documentation, key steps, cost and eligibility (U-09, U-10) and record what is received; no integration is built in this test (E-SHIP-009, E-SHIP-010).

Part B (only on the Unishippers-provided test or demo account, and only if the cost gate is met):
5. Book, label and track one test parcel (E-SHIP-006, E-SHIP-015).
6. Void the label and record the window, who can void, any charge and the credit timing (E-SHIP-015, E-SHIP-016, E-SHIP-017).

Pass criteria:
- Part A: the field gap between the Sage order and the portal is listed, and the account's portal access and role permissions are confirmed (label print, void, bulk upload).
- Part B: a test label is created and voided without a charge or with a charge written down, and the void window is recorded from Unishippers' own written answer.
- Unishippers states in writing whether Brad's account type is eligible for the API and supplies documentation.

Fail criteria:
- Brad's account or user role lacks portal label or void access.
- A voided label cannot be voided or carries a charge the pilot cannot accept.
- Unishippers cannot state a void policy in writing.
- Part B was needed to pass and could not be run (recorded as not run, not as a pass).
- Gate not met (account gate or cost gate for Part B; recorded as not run).
- No documentation or eligibility statement by the pilot's decision date; the Shipping: Unishippers API verdict then stays at Viable with conditions with no basis to move up.

Moves to PoC-validated (on pass): E-SHIP-006, E-SHIP-015, E-SHIP-037 (preparation from an exported order), E-SHIP-034 (portal and void parts only), E-SHIP-033 (field gap). Void windows (E-SHIP-016, E-SHIP-017) move only on a written Unishippers statement, not on observation alone.

## POC-05 — SHIP-MULTI

Path: Shipping: multi-carrier tool (matrix verdict: Viable with conditions).

Setup:
- Gate (Rulings 38 and 39): steps 2, 3 and 6 run only on a Unishippers- or vendor-provided test or trial account (requested via U-22), and only at no cost (free tier or vendor-confirmed non-billable), or with spend approved in advance by Timothy. Brad's Unishippers credentials, accounts and live systems are never used. If no such account is provided, POC-05 is recorded as not run and only steps 1 and 5 and the V-03 request are done.
- A trial or test account with the multi-carrier vendor. Whether a sandbox exists is not established in the ledger, so the first step is to ask (V-04).
- The UPS by Unishippers connection needs a paid ShipEngine plan and Unishippers-issued credentials (client ID and secret) (E-SHIP-012). The test uses credentials from the provided test or trial account (U-22). Whether Brad's own account could issue such credentials is a question (U-12), not a test step. If no test credentials are provided, the test stops at step 2.
- Synthetic ship-to data and parcels only. No label is bought unless the gate above is met.

Steps:
1. Ask ShipStation or Unishippers whether the UPS by Unishippers connection is in the ShipStation app plans or only in the ShipEngine API (V-04) and record the written answer (E-SHIP-012, E-SHIP-030).
2. Connect the Unishippers- or vendor-provided test or trial account using its own test credentials (E-SHIP-012).
3. Rate-shop a synthetic parcel, buy one label, retrieve tracking and void the label (E-SHIP-012).
4. Check that tracking is read by polling (the connection has no webhook tracking) (E-SHIP-036).
5. Record the plan price for the connection, which is not in the ledger (E-SHIP-012).
6. With Noverhead Software, request a ShipSync test on a Noverhead-provided test or trial account only (not Brad's Sage or Unishippers account), under the same cost gate, and record whether ShipSync writes tracking back to Sage 50 and where (V-03) (E-SHIP-024).

Pass criteria:
- A test connection works on the provided test or trial account.
- Rate, label, tracking and void all complete for one synthetic parcel.
- The plan price for the connection is recorded.

Fail criteria:
- No test or trial credentials are provided for the connection (recorded as not run).
- The connection is not available in the plan the pilot would use.
- Void fails or carries a charge, or a label cannot be bought on the test account.
- Gate not met (account gate or cost gate; recorded as not run, never as a pass).

Moves to PoC-validated (on pass): E-SHIP-012, E-SHIP-036. ShipSync (E-SHIP-024, E-SHIP-031, E-SHIP-035) moves only if step 6 is run on a real test, which needs Noverhead's cooperation.

## POC-06 — MAIL-INTAKE

Path: Flow: email intake (matrix verdict: Viable with conditions).

Setup:
- A test mailbox in a separate trial or developer tenant of the platform Brad names (Microsoft 365 or Google Workspace, E-MAIL-012), never in Brad's tenant and never the orders mailbox. Consent and delegation are exercised in the trial tenant (E-MAIL-002, E-MAIL-008). Whether Brad's administrator will grant the same scope is a question (B-12, M-01, M-04), not a test step.
- A public HTTPS endpoint for Microsoft notices, or a Pub/Sub topic for Google (E-MAIL-003, E-MAIL-009, E-MAIL-010). Cost gate: the endpoint or topic runs only at no cost (free tier or vendor-confirmed non-billable), or with spend approved in advance by Timothy; free tier or trial only.
- Synthetic emails: purchase orders with PDF, spreadsheet and plain-text bodies, and quote requests, labelled by type. One contains instruction-like text that must be treated as data (E-AI-026).

Steps:
1. Receive one test PO email and attachment through the chosen route: a new-mail notice, then read the message and attachment (E-MAIL-001, E-MAIL-006).
2. Read a shared mailbox or group alias created in the trial tenant, if the orders address is of that kind. It is the trial tenant's own test mailbox, not Brad's orders mailbox (E-MAIL-004).
3. Label each message as customer PO or quote request by sender, subject and attachment type; leave unclear messages in an unsorted queue (E-MAIL-017).
4. Renew a subscription or watch on the test mailbox and record the renewal limit (seven days) (E-MAIL-003, E-MAIL-009). Cost gate: this step, which can incur cloud charges, runs only at no cost (free tier or vendor-confirmed non-billable), or with spend approved in advance by Timothy.
5. Drop a notice on purpose and confirm that the scheduled safety-net listing catches the missed message (E-MAIL-014).
6. Record any throttling or quota messages and attachment size limits (E-MAIL-005, E-MAIL-011).
7. Confirm nothing is written to Sage by this step (E-MAIL-015).

Pass criteria:
- A test PO email and its attachment are received and read through the chosen route.
- The deliberately dropped notice is caught by the safety-net listing.
- All 20 synthetic messages (10 PO, 10 quote request) are labelled correctly or left unsorted, with zero mislabelled.
- No instruction in a test email changes any permission or action.

Fail criteria:
- The attachment cannot be read through the route.
- A dropped notice is not caught.
- Consent in the trial tenant needs mailbox-wide scope with no way to restrict it (E-MAIL-008).
- A test email's text changes system behaviour.
- Gate not met (cost gate on the endpoint, topic or renewal step; recorded as not run).

Moves to PoC-validated (on pass): E-MAIL-014, E-MAIL-003 or E-MAIL-009 (whichever platform was tested), E-MAIL-001 and E-MAIL-006 (attachment reading; both are snippet-only today), E-MAIL-004 (shared mailbox read; snippet-only today). Platform choice (E-MAIL-012) is a fact from Brad, not a test result.

## POC-07 — SAGE-TRACKING

Path: Flow: tracking back to Sage (matrix verdict: Unresolved). This test is how that verdict gets resolved either way.

Setup:
- Sage 50 sample company with a synthetic sales order and an invoice (from POC-01), with edition and release recorded.
- A synthetic tracking number (a made-up string in the carrier's format). No real shipment is needed.

Steps:
1. Re-read the full Sales Journal, Sales Order Journal and Sales Order field lists in the help (the earlier read used extracts that elide rows) and list every field that could hold a tracking number (E-SAGE-025).
2. Write the synthetic number into a notes, reference or line-description field by CSV import, and read it back in the Sage screens (E-SAGE-025, E-SAGE-023).
3. Do the same through the SDK on release 2026.0, if POC-02 is running (E-SAGE-025, E-SAGE-004).
4. Check whether the value can be found by search or shown on a report, since the Notes workaround is untested for that (E-SAGE-025).
5. Re-import a changed order and record field-mismatch failures (E-SAGE-024).
6. Ask Sage where a tracking number can be stored (S-14); ask Noverhead Software how ShipSync stores tracking (V-03); ask Brad where tracking is recorded today (B-08) (E-SHIP-024, E-SAGE-042).

Pass criteria:
- A field is found (documented, or tested through CSV or SDK) that holds a tracking number and can be read back in the Sage screens.
- The value can be found by search or appears on a report, or its absence is recorded.
- Brad agrees which field staff will use.

Fail criteria:
- No field holds the value reliably, or it is lost on re-import.
- The value can be written but not searched or reported, and Brad needs it searchable.
- The SDK cannot write to the needed record type for Brad's accounting basis (E-SAGE-004).

Moves to PoC-validated (on pass): E-SAGE-025. ShipSync write-back (E-SHIP-024) moves only if tested with Noverhead. The matrix verdict for this flow changes from Unresolved to Viable with conditions, or to Fallback only or Not viable if the test fails and Sage and Noverhead answers confirm no field.
