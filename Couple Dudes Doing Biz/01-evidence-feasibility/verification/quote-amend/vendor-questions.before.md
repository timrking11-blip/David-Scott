# Vendor questions and client confirmations

Sub-project 1, evidence and feasibility research. Client: Couple Dudes Doing Biz (stakeholder: Brad). Advisor: Timothy King. Date: 2026-11-06. Status: draft for review.

Every question below is a draft for Timothy to send, in his own words and through his own channels. None has been sent and none has an answer. Each question cites the ledger rows (from `evidence-ledger.md`, column "Validation needed") that its answer would resolve. A reply from a vendor sales or support contact is a vendor statement; it does not by itself move a row to verified until the reply is written down and dated in the ledger. Assumptions: A-01 (US Sage 50 Accounting; Quantum 2026 by stakeholder report, E-SAGE-053; exact release unknown) applies to every Sage question; A-02 and A-02b (the two readings of "GrokBot super") apply to the xAI questions.

Question IDs: S = Sage, U = Unishippers, X = xAI, M = mail platform vendors, O = other AI and document-extraction vendors, V = other vendors, B = client (Brad).

## Sage

Send to Sage (US Sage 50 Accounting support or the developer program contact). Name the product as Sage 50 Accounting (US) and give Brad's edition (Quantum 2026, stakeholder-reported) and the release once known.

- S-01. Does the 2026.0 SDK quick start guide still apply to release 2026.1 and later, is there an SDK build or compatibility statement for 2026.1, and what is the current release number and did the API change in 2026.1? Resolves: E-SAGE-001, E-SAGE-019, E-SAGE-020.
- S-02. Is sales order create and edit available through the SDK in 2026.x in all editions? Resolves: E-SAGE-002.
- S-03. For a company that is cash-basis, or that uses serialized inventory, retainage jobs or units of measure, do the SDK write limits apply to sales orders? Resolves: E-SAGE-004.
- S-04. Is an interactive Windows session required for an SDK client, or can it run as a scheduled task or service in a non-interactive session? Resolves: E-SAGE-005.
- S-05. Does an idle SDK session block exclusive operations such as a backup? Resolves: E-SAGE-007.
- S-06. What does an Application ID for a production company cost today, and are there annual or per-customer fees? Resolves: E-SAGE-008.
- S-07. What are the partner program tiers, fees and approval criteria, and can an advisor or a single-client integrator qualify? Resolves: E-SAGE-009.
- S-08. What are the cost and contract terms of the Sage 50 SDK program for a single-client integration, and is there any add-on fee for CSV import or ODBC? Resolves: E-SAGE-010, E-SAGE-050.
- S-09. Does an SDK-connected application, or an ODBC read, count as a concurrent user, and can it connect while the single licensed user is signed in? Resolves: E-SAGE-011, E-SAGE-048.
- S-10. Is an unattended service on the company-file host a licensed workstation? Resolves: E-SAGE-012.
- S-11. What is the current price for Brad's edition and user count, and which of the monthly figures published for Sage 50 are current? Resolves: E-SAGE-014, E-SAGE-015, E-SAGE-016.
- S-12. Is ODBC acceptable for unattended scheduled reads, and can a dashboard service read the company over ODBC from another server? Resolves: E-SAGE-021, E-SAGE-022.
- S-13. Can CSV import be run unattended or scheduled? Resolves: E-SAGE-023.
- S-14. Where can a carrier tracking number be stored on a sales order or invoice, and is there a field for it beyond Notes or Reference? Resolves: E-SAGE-025.
- S-15. Is there a draft, hold or unapproved state for sales orders? Does a quote convert to a sales order? If a wrong import lands, how is it reversed? Resolves: E-SAGE-026, E-SAGE-044.
- S-16. If Brad's "cloud version" of Sage 50 Quantum 2026 proves to be third-party hosted (B-19), can the .NET API reach a hosted company? Ask after B-19 is answered. Resolves: E-SAGE-029.
- S-17. Can the SDK on a workstation open a company file held on a server share, and where must the SDK client run relative to the company data? Resolves: E-SAGE-030, E-SAGE-031, E-SAGE-045.
- S-18. Is any UI automation or screen-automation approach acceptable under the licence terms? Resolves: E-SAGE-034, E-SAGE-049.

## Unishippers

Send to Unishippers through Brad's account representative or the corporate contact. Question U-01 to U-06 also help Timothy decide which office and entity to address.

- U-01. Is Brad's UPS account a Unishippers-issued account number, and who holds the contract with UPS? Resolves: E-SHIP-001.
- U-02. Which parcel and freight services are active on Brad's account? Resolves: E-SHIP-002.
- U-03. Which office services Brad's account, and which policies are set by corporate versus the local office? Resolves: E-SHIP-003.
- U-04. Is the contracting entity on Brad's account Unishippers Global Logistics or Worldwide Express? Resolves: E-SHIP-004, E-SHIP-032.
- U-05. Confirm Brad's account type, services and enabled tools. Resolves: E-SHIP-005.
- U-06. Is label printing, void and bulk upload enabled for Brad's user role? Resolves: E-SHIP-006.
- U-07. Please give written steps for label creation and void in myUnishippers. Resolves: E-SHIP-007.
- U-08. Has Brad's account migrated to the new platform, and what is the migration date? Resolves: E-SHIP-008.
- U-09. For the Unishippers API: documentation, key request steps, cost, and whether Brad's account type is eligible. Resolves: E-SHIP-009.
- U-10. Which API generation would a new integration use, and what is the support horizon of the current one? Resolves: E-SHIP-010.
- U-11. Which partners handle ERP or accounting order import, and is any partner or customer using Sage 50 with the API? Resolves: E-SHIP-011, E-SHIP-023.
- U-12. Can Brad's Unishippers-issued UPS credentials (client ID and secret) be used with ShipStation or ShipEngine, and can Brad's account issue them for the UPS by Unishippers connection? This is a question, not a PoC step. Resolves: E-SHIP-012.
- U-13. Is any charge raised for a label created and then voided before pickup? Resolves: E-SHIP-013.
- U-14. What is the official WooCommerce option and its feature scope; do you support the Eniture plugin, and is a migrated account needed? Resolves: E-SHIP-014, E-SHIP-025. (WooCommerce is catalog-only under DEC-08; this is a low-priority question.)
- U-15. Please provide a written void policy for UPS parcel labels: window, who can void, unused versus scanned, any fee, and credit timing. Does the UPS 90 and 180 day window apply to voids raised through Unishippers, and which void window and refund or credit method applies to a Unishippers-invoiced UPS label? Resolves: E-SHIP-015, E-SHIP-016, E-SHIP-017, E-SHIP-037.
- U-16. What is the current dispute deadline for parcel charges, does any parcel dispute deadline exist in days, and who files the dispute? Resolves: E-SHIP-018, E-SHIP-019.
- U-17. Is an invoice audit included in Brad's account, and how often? Resolves: E-SHIP-020.
- U-18. What is the current schedule of adjustment types and amounts for Brad's account, and who may waive them? Resolves: E-SHIP-021.
- U-19. Please provide a copy of the customer service agreement and the myUnishippers terms, with the clauses on voids, adjustments and liability. Resolves: E-SHIP-022.
- U-20. May a customer link the Unishippers-issued UPS account number to their own UPS developer app, and will API calls on that account return and bill at Unishippers rates? Resolves: E-SHIP-027, E-SHIP-029.
- U-21. Combined confirmation for the shipping integration: migration date, API documentation and eligibility, written void policy, and that the API is callable from a server. Resolves: E-SHIP-034, E-SHIP-035. (overlaps U-08, U-09, U-15; send once)
- U-22. Can Unishippers provide a test or demo account, or a non-billable test mode, for portal label and void testing (POC-04 Part B) and for the ShipEngine connection (POC-05), at no cost? Resolves: E-SHIP-006, E-SHIP-012, E-SHIP-015, E-SHIP-037.

## xAI

Send to xAI through the channel xAI publishes for business or sales questions. Two products are in play because the stakeholder's phrase is unconfirmed: SuperGrok (A-02) and Grok Bot on the X Subscription Super plan (A-02b). Ask both sets until Brad answers question B-18. Keep consumer terms and API terms apart in every reply.

Consumer terms and SuperGrok (A-02):

- X-01. Confirm in writing that a SuperGrok subscription is a consumer-terms product and that scripted business use must go through the API under the Enterprise terms. Resolves: E-AI-001.
- X-02. State the default training setting for a paid SuperGrok account, and whether a business purchase order uploaded to a consumer account falls under the broad licence. Resolves: E-AI-002.
- X-03. Confirm that the FAQ commercial-use statement applies to outputs produced from third-party customer documents. Resolves: E-AI-003.
- X-04. Is any scripted or unattended use of a consumer SuperGrok login permitted, and which interface is the authorised route for unattended PO processing? Resolves: E-AI-004.

Grok Bot and the X Subscription (A-02b):

- X-05. Can Grok Bot read a shared orders mailbox unattended, and under which terms (consumer or Enterprise) does a Grok Bot seat fall? Resolves: E-AI-005.
- X-06. Which terms and data processor apply to Grok Bot, and are customer documents retained or used for training? Resolves: E-AI-010.
- X-07. Which terms govern a Grok Bot seat bought through an X Subscription (including the SpaceXSI Subscription Terms linked from x.ai/legal), who owns Grok Bot output, and is non-coding business use within the permitted purpose? Resolves: E-AI-051, E-AI-052.
- X-08. Can a Grok Bot routine open and extract fields from a PDF attachment on an inbound email without a person present? Resolves: E-AI-054.
- X-09. What is the absolute weekly allowance of the Super plan versus SuperGrok, and what does one PO read cost in that allowance? Resolves: E-AI-055.
- X-10. What is the default Privacy Mode for an individual Super seat, and can customer PO files be purged on request? Resolves: E-AI-056.
- X-11. Can the Gmail connector run on a schedule without a person in the chat? Resolves: E-AI-058.

xAI API (enterprise terms):

- X-12. Which models accept PDF or image purchase orders directly, and what is their accuracy on tabular documents? Resolves: E-AI-013.
- X-13. Is zero data retention self-serve for a small-business API team, and what is the exact retention period for files uploaded for document search? Resolves: E-AI-015.
- X-14. Does the no-training statement bind API usage bought by card on the self-serve console, or only usage under a signed Order Form? Is the self-serve console covered by the Enterprise terms without a signed Order Form? Resolves: E-AI-016, E-AI-050.
- X-15. Do business contact names and addresses on a purchase order count as personal data that must go through the ZDR-enabled API? Resolves: E-AI-017.
- X-16. Please provide the SOC 2 Type II report under NDA before any production use. Resolves: E-AI-019.
- X-17. Does xAI publish prompt-injection guidance or controls for API document ingestion, and does the Responses API mark file content as untrusted? Resolves: E-AI-020.

## Other AI and document-extraction vendors

The automation matrix recommends extraction by an AI-assisted step with a person confirming. These questions compare the other vendors in the comparison set. They are lower priority than the Sage and Unishippers questions.

- O-01. Anthropic: ZDR eligibility and process for a small account, and which listed models can be used under it. If the client uses a consumer Claude plan for PO work, which terms and retention apply? Resolves: E-AI-024, E-AI-027.
- O-02. OpenAI: ZDR eligibility for an account processing PDF purchase orders through Responses. Resolves: E-AI-031.
- O-03. Google: length of the abuse-monitoring log period, and whether Vertex AI ZDR is available to a small account. Resolves: E-AI-036.
- O-04. Google: is there Gemini API guidance for ingesting untrusted third-party documents? Resolves: E-AI-038.
- O-05. Google: define the billing unit for the Invoice parser, and say whether the Procurement splitter handles purchase orders. Resolves: E-AI-040.
- O-06. Microsoft (Azure Document Intelligence): written confirmation that documents submitted to the prebuilt models are not used to train or improve models. Resolves: E-AI-043.
- O-07. Microsoft (Azure Document Intelligence): does any prompt-injection risk apply to the generative or custom generative extraction models? Resolves: E-AI-044.
- O-08. AWS (Textract): is Analyze Expense validated for customer purchase orders, and are non-English POs handled? Resolves: E-AI-046.
- O-09. AWS (Textract): confirm the opt-out is in force and what retention applies to documents processed under it. Resolves: E-AI-047.
- O-10. AWS (Textract): is there any documented prompt-injection exposure for Textract Queries or for downstream use of its output? Resolves: E-AI-048.

## Mail platform vendors

Ask only the vendor that matches the platform Brad names in B-12. Both are drafted because the platform is unconfirmed.

- M-01. Microsoft 365: confirm which admin role and plan can configure RBAC for Applications for a small Microsoft 365 tenant. Resolves: E-MAIL-002.
- M-02. Microsoft Graph: what are the published throttling limits for the Outlook mail API, and is there any charge for application-permission Graph mail calls? Resolves: E-MAIL-005.
- M-03. Google Workspace: do verification and the security assessment apply to an internal-only app run by the same domain that owns the mailboxes? Resolves: E-MAIL-007.
- M-04. Google Workspace: can domain-wide delegation be restricted to one mailbox, or is a dedicated orders account with a user OAuth grant the safer design? Resolves: E-MAIL-008.
- M-05. Gmail API: what are the documented per-user quota units for messages.get and attachments.get, and what is the maximum attachment size returned? Resolves: E-MAIL-011.

## Other vendors

Marketplace, connector and plugin vendors. Each is optional. The Sage marketplace connector path is rated Unresolved and the CRM-related connectors are out of v1 scope (DEC-06), so these questions are lower priority.

- V-01. Sage marketplace listing vendors: does your product read emailed PDF purchase orders into Sage 50 sales orders, and which US Sage 50 editions and prices apply? Resolves: E-SAGE-027.
- V-02. OrderSync: confirm US Sage 50 release support, price, and whether orders land as draft sales orders for approval. Resolves: E-SAGE-028.
- V-03. Noverhead Software (ShipSync): does it work with a Unishippers-issued UPS account through ShipStation, which Sage 50 versions are supported, what is the current price and what does it cover, and where must ShipSync run relative to the company file? How does it store tracking in Sage? Resolves: E-SHIP-024, E-SHIP-031, E-SHIP-035.
- V-04. ShipStation or Unishippers: is the UPS by Unishippers connection available in the ShipStation app plans, or only through the ShipEngine API? Resolves: E-SHIP-012, E-SHIP-030 (cited in the multi-carrier tool row of the connectivity matrix). (overlaps U-12)
- V-05. Eniture: current plugin price, term and platform prerequisite. Resolves: E-SHIP-026.
- V-06. Clarity Ventures: does the connector support US Sage 50 Accounting (name the edition and version), which Sage 50 access method does it use, and what is the total first-year cost including setup for one WooCommerce to Sage 50 US pair? Resolves: E-ECOM-003, E-ECOM-004.
- V-07. Codeless Platforms: does BPA Platform support US Sage 50 Accounting for WooCommerce product sync? Re-check once the Sage rows state which US access methods are open. Resolves: E-ECOM-005.
- V-08. Commercient: is sync one-way or two-way per object, which plans are current and what each costs, what are the monthly or annual price and onboarding fee for Sage 50 US to HubSpot, and what are the per-user monthly price and supported Sage 50 US versions for the Zoho CRM app? Resolves: E-ECOM-007, E-ECOM-008, E-ECOM-009, E-ECOM-011. (HubSpot and Zoho are out of v1 scope by stakeholder preference, DEC-06.)

## Client confirmations (Ask Brad)

Draft for Timothy to put to Brad, ideally in one short call with a screen share. Ranked: B-01 to B-04 change the most verdicts.

Sage and the machine:

- B-01. **Answered 2026-11-06 (DEC-09/10/11):** Sage 50 Quantum Accounting 2026 (US), described as the "cloud version". Still open: release and Help > About detail, Sales Orders window, licensed user count, and which machine or host holds the company file. Original question: Which Sage 50 edition and release does he run (Help, About screenshot), is the Sales Orders window present, how many licensed users does the company have, and which machine or host has Sage installed and holds the company file? Resolves: E-SAGE-013, E-SAGE-017, E-SAGE-018, E-SAGE-038, E-SAGE-045.
- B-02. Is the company cash-basis or accrual, and does it use serialized inventory, retainage jobs or units of measure? Resolves: E-SAGE-004.
- B-03. **Answered 2026-11-06 (DEC-09/10/11):** Partly answered: Sage 50 Quantum Accounting 2026, described as the "cloud version". Still open: what "cloud version" means (see B-19), and subscription or perpetual licence. Original question: Is it Sage 50 Cloud or Desktop, and is it a subscription (Sage Business Care) or an older perpetual licence? Resolves: E-SAGE-029, E-SAGE-033, E-SAGE-037.

Today's manual steps:

- B-04. Please walk through the steps from PO receipt to pick and pack. Resolves: E-SAGE-041.
- B-05. Who signs off, at which step, and what evidence does the sign-off need? Resolves: E-SAGE-043.
- B-06. How are custom and new products set up and entered, and how often? Resolves: E-SAGE-040.
- B-07. Please define a standard product and supply a sample of recent orders so the 80 to 85 percent share can be counted. Resolves: E-SAGE-039.
- B-08. Where in Sage is the tracking number recorded today, and who enters it? Resolves: E-SAGE-042.
- B-09. How many active customers are there, are Sage ship-to addresses kept current, and is email history searchable by staff? Resolves: E-ECOM-017.

Shipping:

- B-10. Which Unishippers tool do staff use to book, label and track, and how long does the step take? Please supply a portal screenshot and a recent invoice. Resolves: E-SHIP-005, E-SHIP-033.

Email:

- B-11. Is incoming PO mail in a personal mailbox, a shared mailbox or a group alias, and is it one shared orders address or several? Resolves: E-MAIL-004, E-MAIL-017.
- B-12. Which email platform hosts the orders mailbox, and who administers it, including who can grant admin consent and who administers the Google Cloud organisation and any sharing restrictions? Resolves: E-MAIL-010, E-MAIL-012, E-MAIL-014.
- B-13. Please confirm the share of buyers who email POs and supply a sample month of PO emails with attachment types. Resolves: E-MAIL-013.
- B-14. **Answered 2026-11-06 (DEC-09/10/11):** Partly answered: quotes arrive by reps calling in or hospitals sending an email, then are built in Sage by hand and the product is sent out. Still open: how many quote requests versus POs arrive in a typical month. Original question: Quote requests by email: how are they handled today, how many quote requests versus POs arrive in a typical month, and does the website take any quote requests? This item is pending Timothy's follow-up with Brad. Resolves: E-MAIL-017 (volumes); E-MAIL-016 is closed by E-MAIL-018.

Website and customer tracking:

- B-15. Which WooCommerce and WordPress versions does the store run, is the REST API reachable (pretty permalinks on), who administers it, and is it served over HTTPS? Does the store hold customer or order data worth reading? Resolves: E-ECOM-001, E-ECOM-002, E-ECOM-013, E-ECOM-016.
- B-16. **Answered 2026-11-06 (DEC-09/10/11):** Partly answered: Sage is the product master for all products, newly introduced and standard; the website carries some but not all. Still open: whether the website takes any quote requests. Original question: Where is product data first created (Sage or WooCommerce), and do customers request quotes through the website today? Resolves: E-ECOM-006.
- B-17. Does he track leads, quotes or customer follow-up outside Sage and email today? This is asked to describe existing practice only, since a CRM is out of scope by his preference (DEC-06). Resolves: E-ECOM-010, E-ECOM-012.

AI product:

- B-18. Which exact product, plan name and screen or invoice was he quoted for "GrokBot super", and does he already pay for it? What exact price, billing period and product name were quoted, and who quoted them? Resolves: E-AI-006, E-AI-007, E-AI-009, E-AI-057.
- B-19. Ask Brad: what does "cloud version" mean for your Sage 50 Quantum 2026, installed on a company Windows machine or server, or hosted by a third party, and which machine holds the company file? [E-SAGE-053; DEC-09]
