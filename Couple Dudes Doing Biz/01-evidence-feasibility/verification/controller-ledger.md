# SDD ledger — plan: C:/Users/timrk/OneDrive/Desktop/Business Advisory Services/Couple Dudes Doing Biz/docs/plans/2026-11-04-evidence-feasibility.md

Spec: C:/Users/timrk/OneDrive/Desktop/Business Advisory Services/Couple Dudes Doing Biz/docs/specs/2026-11-04-evidence-feasibility-design.md (reachable, binding)
Workspace: this draft folder (no git repo). Briefs in briefs/, reports in reports/.

## Pre-flight scan

| Pair / task | Produces vs consumes | Finding |
|---|---|---|
| T1–T4 vs each other | Disjoint files (rows-sage/ship/ecom/ai/mail.md) | No overlap |
| T1–T4 → T5 | rows files, 15 columns (NF=17) → T5 concatenation and row count `NF==17` | Consistent |
| T5 → T6, T7 | ledger IDs → matrix citations; T6 and T7 may both append S4 rows to the ledger | Shared write. Sequential, so no clash. New IDs continue each domain's numbering |
| T6 → T7 | connectivity verdicts → feasibility "Recommended approach" | Consistent |
| T6/T7 → T8 | Validation-needed column + verdicts → vendor questions and PoC tests | T8's vendor check keys on "ask/vendor/confirm with" in col 14. Researchers must phrase vendor questions that way |
| T1–T8 → T9 | all drafts → criteria 1–8 | Consistent |
| T1 self | DELTA rows vs US check | Exempted in awk; version check still applies (intended) |
| T4 self | email-conditional check vs Step 3 phrasing | Consistent |
| T5 self | SR rows need an Accessed date (RC-3) and a source | Not specified → Ruling 3 |
| T9 self | `shuf` needed | Git Bash coreutils has it; fallback is a manual random pick (noted) |
| T10 self | writes outside draft folder | Gated on Timothy's explicit go (a stop point) |

## Rulings

- Ruling 1: No git repo, so no worktree, commits or review-package script. Reviewers read the draft files directly, and "BASE" is the file state at dispatch — the spec says no git unless Timothy asks — cost if wrong: weaker diff trail for fix rounds; mitigated by report files.
- Ruling 2: Tasks 1–4 run in parallel despite the skill's no-parallel default — the plan mandates parallel and the files are disjoint — cost if wrong: none expected; each writes only its own file.
- Ruling 3: Stakeholder-reported rows added in Task 5 use Source "Master prompt business context (stakeholder-reported via Timothy)", Source type `stakeholder`, Strength `SR`, Accessed `2026-11-04` (the date the brief was received) — the spec gives no date rule for SR rows — cost if wrong: cosmetic; dates can be revised when the tl;dv notes arrive.
- Ruling 4: Researchers phrase any vendor-question validation as "Ask <vendor>: ..." in Validation needed, so the Task 8 coverage check works — it keeps the T8 check deterministic — cost if wrong: a missed vendor question, caught by T9.
- Ruling 5: Models — sonnet for the research implementers and for task reviewers; opus for the Task 9 final verifier — mid-tier is the floor for prose-driven web research — cost if wrong: higher spend or a weaker review.

## Progress

- Ruling 6: "Sources checked" goes in a separate sources-<domain>.md, not under the rows table. This is a plan defect: the RC-1 and cap checks count every line after line 2. Task 5 merges the sources files. Cost if wrong: none; the content is preserved. Sent to T1, T2 and T4.
- Ruling 7: Status `verified` = the cited source states the claim, confirmed by fetching it. It does not mean tested. `hypothesis` = inference or snippet-only. The spec's status vocabulary has no "vendor-claimed" value. Cost if wrong: status semantics must be explained in the memo. Sent to T1, T2 and T4; T3 to be brought into line in its fix round.
- Ruling 8: A non-S1 published price (for example a marketplace listing) is labelled "quoted, unverified" to satisfy Rule 2 / RC-4, with the source type showing who quoted it. Cost if wrong: a cosmetic label.
- T3 returned DONE_WITH_CONCERNS (12 rows; checks clean). Concerns: E-ECOM-005 rests on search snippets; Commercient price conflict (008/009); vendor rows marked hypothesis.
- T3 review: Spec ✅, quality "Changes needed". Two Important status findings. Spot-check of 4 sources: all confirm.
- Ruling 9: The reviewer's Minor about E-ECOM-007/011 ("no connector found" without "in sources checked") is raised to Important. It breaches spec Rule 3 in substance even though RC-2 misses it. Cost if wrong: one extra edit.
- Task 3: minor (deferred): E-ECOM-006 Applies-to cites Woo-as-catalog as stakeholder-reported. Source is the master prompt; consider an SR row in T5.
- Task 3: minor (deferred): E-ECOM-002 Limitations should note keys can be auto-generated via an auth endpoint.
- Task 3: minor (deferred): E-ECOM-005 could cross-reference E-ECOM-003.
- Task 3: fix round 1 dispatched (resumed implementer).
- T2 returned DONE_WITH_CONCERNS: 31 rows; checks clean; rulings 6 and 7 applied.
  - Unresolved: void policy (conflicting sources), fee schedule (link returns 404), service agreement, API eligibility, whether Brad's account can use the UPS developer API.
  - No Unishippers–Sage 50 integration found in sources checked.
- Ruling 10: A snippet-only (`hypothesis`) row keeps its source's strength grade but counts as S4 for Rule 1 "Supported" decisions and for the Task 9 spot-check pool. Its Limitations must say "snippet only". Reason: a snippet is not a reading of the page. Cost if wrong: some paths rated "Viable with conditions" when they might have earned "Recommended". Carry this into the Task 6 and Task 9 dispatches.
- T2 review dispatched (sonnet).
- T1 returned DONE_WITH_CONCERNS: 36 rows (26 verified, 7 hypothesis, 3 unknown); checks clean; rulings 6 and 7 applied.
  - Key findings: no draft sales-order status in sources checked (E-SAGE-026; quotes are the nearest record); no tracking-number field (E-SAGE-025; Notes fields are an untested workaround).
  - Open: SDK seat use (011), SDK fees (010), whether the integration must run on the company-file host (030/031), cloud price conflict (014/015).
  - E-SAGE-003 was truncated in the fetch.
- Ruling 11: The Accessed date is the date of our fetch (2026-11-04), even where the page's cache metadata is older. Cost if wrong: dates can look fresher than the content; mitigated by the Limitations notes.
- Handoff note for Tasks 6–7 and the memo: "draft sales order" in the spec may have to map to a Sage quote, or to an unprinted sales order behind human approval. Flag this as a design consequence, not as a decision.
- T1 review dispatched (sonnet).
- T2 review: Spec ✅, quality "Changes needed" (3 Important, 5 Minor). Spot-check: 009 and 012 confirm; 030 partly contradicts (it is the Standard plan, not Starter).
- Ruling 12: Four of T2's Minors are raised to Important, because each breaches a spec rule that a later task builds on:
  - 004: the claim says more than its source does;
  - 016/017: Rule 4 not applied;
  - 008/025: conflict not explained;
  - 023: Rule 3 sources not named.
  Cost if wrong: extra edits only.
- Task 2: minor (deferred): E-SHIP-031 is tagged both comparison-only and D2.Q4; note the dual role.
- Task 2: fix round 1 dispatched (resumed implementer).
- T4 returned DONE_WITH_CONCERNS: 49 AI rows and 12 mail rows. Checks summarized, not verbatim; the reviewer will re-run them.
  - Key: xAI's Acceptable Use Policy bars unauthorized bot or script access, and its consumer terms route business use to Enterprise terms (E-AI-017).
  - Google Document AI pricing unit conflicts (039/040).
  - No PO-specific model found for Textract or Document AI. Azure's invoice model names POs.
- Ruling 13: A-02 is NOT proven wrong. E-AI-006 found a real xAI product called "Grok Bot", included in the X Premium, Super and Ultra plans. That makes "GrokBot super" = Grok Bot on the X Super plan a competing reading. Both readings are consumer subscriptions, so the consumer-vs-API evaluation applies to either. A-02 stays, A-02b is added as an alternative hypothesis, and the domain is not stopped (§12 requires proof, not plausibility). This must be surfaced to Timothy prominently in Task 10 and in the findings summary, with a request for Brad's plan name or invoice. Cost if wrong: the AI rows lean toward the wrong product's terms. Mitigation: both are covered.
- T4 review dispatched (sonnet); the reviewer re-runs the checks because the verbatim output is missing.
- Task 3: fix round 1/5 (3 addressed, 0 open — status values, connector wording; no git).
- Task 3: complete (review clean after fix round 1; 3 minors deferred).
- T1 review: Spec ✅; quality "Changes needed" (4 Important, 5 Minor).
  - Spot-check: 003, 018 and 012 confirm; 007 partly confirms.
  - The strict S1 reading (must name a version) downgrades several vendor KB rows to S2.
- Ruling 14: T1 Minors 5–8 go into fix round 1 alongside the Important findings, because they are cheap and in the same file. Minor 6 (row 007 claims more than the source shows) counts as Important. Cost if wrong: none.
- Task 1: fix round 1 dispatched (resumed implementer).
- Task 2: fix round 1/5 (7 addressed, 0 open; 32 rows, adds new row E-SHIP-032). The re-review re-fetched the source and found the original reviewer wrong on E-SHIP-030: the bring-your-own Unishippers LTL option is on all three plans.
- Task 2: minor (deferred): E-SHIP-023 source cell still says "Sage community search results"; the queries are named in Limitations.
- Task 2: complete (review clean after fix round 1).
- T4 review: Spec ❌ (the A-02b alternative cannot yet be evaluated); quality "Changes needed".
  - Critical: the "snippet only" phrase is missing from all 32 hypothesis rows. Cause: a controller communication gap; Ruling 10 was never sent to T4.
  - Important: E-AI-004 merges consumer and API in one row; the 007/008 conflict is referenced one way only; the tier naming differs between rows.
  - Spot-check: 021, MAIL-003 and 035 confirm.
- Ruling 15: Fix round 1 for T4 includes up to 8 new research rows covering the A-02b reading (Grok Bot on the X Super plan): binding terms, unattended mailbox access, usage allowance, retention, and a fetched product source. Ruling 13 requires both readings to be evaluable. Cost if wrong: about 8 rows of extra research.
- Task 4: fix round 1 dispatched (resumed implementer).
- Task 1: fix round 1/5 (8 addressed, 0 open; 37 rows, adds new row E-SAGE-037).
- Task 1: complete (review clean after fix round 1).
- Task 1: minor (deferred): the 014/015/016 status says `verified` while the claim says "quoted, unverified". Ruling 8 allows this (the source states the price; the price is not confirmed for Brad). Explain the convention in the ledger header in Task 5.
- Task 9 carry: include E-SAGE-007 in the spot-check sample. Its lock list rests on the implementer's re-fetch alone.
- Task 4: fix round 1/5 (4 addressed, 0 open from the original review; new A-02b rows 051–058 raised 4 Important and 5 Minor findings).
  - Key: the claim that the Cursor ToS governs Grok Bot seats is overstated. The Grok Bot Terms supplement an unnamed "Agreement", and the x.ai SpaceXSI Subscription Terms are the likelier governing terms.
- Task 4: fix round 2 dispatched (resumed implementer). The Minors are included because they are cheap and in the same file.
- Task 4: fix round 2/5 (8 addressed, 1 open). E-AI-053's Gmail connected-mailbox read is disputed between the implementer, who re-fetched the page, and the reviewer. 054's source cell needs aligning, and 054 and 055 have broken sentence splices.
- Task 4: fix round 3 dispatched. The implementer must quote the exact source phrase for E-AI-053, or scope the claim back.
- Task 9 carry: include E-AI-053 in the spot-check sample whatever round 3's outcome.
- Task 4: fix round 3/5 (3 addressed, 0 open). E-AI-053's Gmail read capability was confirmed by an independent fetch. Final file has 58 AI rows and 12 mail rows.
- Task 4: complete (review clean after fix round 3).
- Task 5 dispatched (sonnet).
- T5 returned DONE: 155 rows; all checks clean; no new cross-domain conflicts. The SR wording was inferred because the master prompt was not available to it.
- Ruling 16: The controller supplied the verbatim master-prompt bullets as a pre-review correction. Changes: E-SAGE-038 gains "not installed on Brad's computer"; E-MAIL-013 says buyers, not POs; E-AI-059 moves to E-SAGE-039; new SR rows cover manual entry for custom products, the print/pick/pack process, manual tracking entry, and human sign-off. Reason: Tasks 6 and 7 cite these facts, and the controller holds the source. Cost if wrong: none, since the wording is verbatim.
- Ruling 17: The session date has rolled to 2026-11-05. Rows fetched on 2026-11-04 keep that date. SR rows use 2026-11-04 (the date the brief was received). Any new fetch from here on uses 2026-11-05. Cost if wrong: cosmetic.
- T5 review: Spec ✅, quality "Changes needed".
  - Merge fidelity verified by comm: 151 input rows unchanged and 9 SR rows added. No new cross-domain conflicts.
- Ruling 18: E-SHIP-005 and E-AI-009 are normalized to the SR source string. "As a reseller" is removed from E-SHIP-005 because it is a researched fact, not a stakeholder statement.
  - E-AI-017's inference clause moves to Limitations; this Minor is upgraded to Important because the row claims more than its source says.
  - Minors 1 and 3 (tracking cross-references, header SR conventions) are included because they are cheap and feed Task 6.
  - Cost if wrong: none.
- Task 5: fix round 1 dispatched (resumed implementer).
- Task 5: fix round 1/5 (5 addressed, 0 open). The ledger has 160 rows.
- Task 5: complete (review clean after fix round 1).
- Task 5: minor (deferred): the report's merge-fidelity section describes E-SAGE-042 inconsistently. Cosmetic, report only.
- Ruling 19: Tasks 6 and 7 use opus as the implementer. They produce the verdicts Brad's memo rests on, so this is the judgment tier. Reviews stay on sonnet. Cost if wrong: higher spend.
- Task 6 dispatched (opus).
- T6 implementer (a7375532e0ea17227) was stopped by an opus rate limit (5-hour cap). Resumed it on 2026-11-05 with an instruction to check partial work and the ledger's integrity before continuing. If it fails again, re-dispatch on sonnet with the same brief.
- DEC-06 (2026-11-05, Timothy in chat): "they have a website they run through WooCommerce - it was expressed to me they see no need for a CRM".
  - Consequence: HubSpot and Zoho are out of v1 scope, by stakeholder preference.
  - The D3.Q2 rows (E-ECOM-007 to 012) stay as evidence, but the matrices and memo treat a CRM as not wanted, not merely as "no gap identified".
  - The website runs on WooCommerce, which supports E-ECOM-013.
- Ruling 20: Two SR rows are queued for the ledger after Task 6 finishes; Task 6 is writing to the ledger now, so they wait to avoid clashing edits. Source "Stakeholder report relayed by Timothy in chat, 2026-11-05", Accessed 2026-11-05.
  - E-ECOM-014: the company website runs on WooCommerce.
  - E-ECOM-015: the stakeholder sees no need for a CRM.
  - Tasks 7, 8 and the findings summary must cite E-ECOM-015 when excluding a CRM.
  - Cost if wrong: none.
- T6 implementer stalled after resume: no output for about 12 hours; the ledger was last modified at 02:31. Stopped it at 15:01. Re-dispatch on sonnet after the CRM edits land, using the Ruling 19 fallback.
- DEC-07 (2026-11-05, Timothy in chat). Timothy's message: "if this has already been factored in adjust (if the fix is easy), frame up low cost options correctly (if the tool is needed), or add a workflow summary as a new final task that eliminates the CRM".
- Ruling 21: do all three, because each is cheap.
  - (a) Add SR rows E-ECOM-014/015. A CRM was already considered (D3.Q2 found no gap), so this is the easy adjustment.
  - (b) Tasks 7, 8 and 11 must meet customer-data needs with existing systems (Sage, email, WooCommerce), framed as low-cost options, never as a CRM.
  - (c) Add Task 11 `workflow-summary.md`, labelled as an assessment view, not an approved Stage B design. It runs after Task 8 and before Task 9 so the verifier checks it.
  - The spec gets §15 Amendments and the plan gets Task 11, applied by an executor.
  - Cost if wrong: the summary could be read as a v1 design; the label guards against that.
- DEC-08 (2026-11-05). Timothy wrote in chat: "you are correct about the product catalog". This confirms WooCommerce serves as the product catalog only.
- Ruling 22: Treat this as resolving the E-ECOM-014 question. WooCommerce is not an intake channel in v1; all customer intake is by email, per E-MAIL-013. Cost if wrong: if the site does take occasional quote requests, it needs a minor added row in the automation matrix later.
  - Queued for after Task 6, because Task 6 is writing the ledger now:
    - Set E-ECOM-014 Validation needed to "Resolved 2026-11-05: Timothy confirmed catalog-only (DEC-08)".
    - Add DEC-08 to spec §15.
  - Tasks 7 and 11 treat WooCommerce as catalog/product-reference only.
- T6 retry (sonnet) returned DONE_WITH_CONCERNS. 14 rows; 13 inference rows added; ledger now has 175 rows.
  - Verdicts: only CSV import/export is Recommended for PoC. The marketplace connector, direct carrier API and tracking-back are Unresolved. UI automation is Fallback only. Everything else is Viable with conditions.
  - The draft record is a Sage quote (E-SAGE-023/003). The "unprinted sales order held for approval" alternative is untested (E-SAGE-044).
- Ruling 23: The plan's Task 6 "bad support value" check lacks an NF>2 guard, which is a plan defect. The guarded form is the correct test, and Task 9 must use it. Cost if wrong: none.
- T6 review dispatched (sonnet). DEC-08 edits dispatched (haiku executor; they touch only the E-ECOM-014 Validation cell and spec §15).
- DEC-08 edits applied (E-ECOM-014 Validation cell; spec §15 row).
- Stakeholder report (2026-11-05, Timothy in chat): "they do request quotes through email but I will get back on this". An SR row is being added as E-MAIL-016 (expected ID), with Validation marked pending.
- Ruling 24: Email intake covers both quote requests and customer POs. Task 7 must treat "Email and attachment intake" as two document types: quote requests and incoming customer POs. Quote requests feed a Sage quote, which matches the draft-record finding in E-SAGE-023/003. Cost if wrong: one row's scope in the automation matrix.
- Open item for Timothy: confirm detail with Brad. Recorded in the findings-summary open questions.
- T6 review: Spec ✅; quality Changes needed (4 Important, 9 Minor). The ladder and about 40 citations hold; the 13 inference rows are sound.
  - I1: multi-carrier row blends ShipEngine API (E-SHIP-012) with ShipStation app prices (E-SHIP-030).
  - I2: CSV prose says "no licensing question" while edition-template availability is open.
  - I3: tracking-back Unresolved lacks its stated reasons.
  - I4: PoC names coined in the matrix.
- Ruling 25: T6 fix round 1 includes all Minors (cheap, same files). T6 may edit only its own inference rows.
  - M5 is handled by adding E-SAGE-026 to the citation, not by editing frozen row E-SAGE-023.
  - Cost if wrong: none.
- Ruling 26: Freeze the PoC test IDs SAGE-CSV, SAGE-SDK, SAGE-ODBC, SHIP-PORTAL, SHIP-MULTI and MAIL-INTAKE. Tasks 7, 8 and 11 must use exactly these names, and Task 8's poc-tests.md entries carry them alongside POC-01 onward.
  - Reason: the Rule 1 "S2 plus named PoC test" path for Sage-to-dashboard depends on SAGE-ODBC, so the name must stay stable through Task 9.
  - Cost if wrong: renaming later is mechanical.
- Task 6: fix round 1 dispatched (resumed implementer aad2d372cda00a4f6).
- Task 6: fix round 1/5 (13 addressed, 0 open). Re-review confirmed all fixes. Frozen rows E-SAGE-023 and E-SHIP-012/030 are byte-identical, and all 14 verdicts are unchanged.
- Task 6: complete (review clean after fix round 1).
- Task 6: minor (deferred): the "Which Sage record" prose cites only E-SAGE-023 for the quote template; add E-SAGE-026.
- Task 6: minor (deferred): E-MAIL-009 is untagged "(snippet only)" in the email row's Dependencies and Failure modes cells.
- Ruling 27: Task 7 runs on sonnet, not opus. Opus hit its 5-hour rate limit during Task 6, and the sonnet retry produced a matrix that passed review after one round. Cost if wrong: the reviewer may catch more judgment issues.
- Task 7 dispatched (sonnet).
- The T7 implementer (af590f3a0d13de7cf) was stopped by the sonnet 5-hour rate limit (resets 5:20pm ET). Resumed on Timothy's "Try again", with an integrity-check-first instruction. If it fails or stalls again, wait for the reset and re-dispatch fresh with the same brief. Do not switch to haiku: it is too weak for judgment-heavy matrix work.
- T7 returned DONE (resume worked after the rate-limit reset). Built from scratch; the ledger was intact at 176 rows and now has 182 (6 inference rows: E-AI-059, E-ECOM-017, E-MAIL-017, E-SAGE-051/052, E-SHIP-037).
  - P1: email intake, customer PO extraction, Sage draft record (CSV-imported quote).
  - P2: matching, validation, human approval and finalization, shipment prep, inventory recommendation.
  - P3: tracking write-back.
  - Concerns: no PoC name for tracking write-back; address validation thinly evidenced; quote conversion and import reversal unestablished; costs are list prices only.
- Ruling 28: Add SAGE-TRACKING to the frozen PoC names, for the tracking write-back test (Notes or custom fields, SDK, ShipSync). Task 8 must give it a poc-tests.md entry even though the path is Unresolved, because a PoC is how it gets resolved. Cost if wrong: one extra test entry.
- Ruling 29: Table-first layout (title below the table) is accepted for draft files. The plan checks use NR>2, and the connectivity matrix uses the same layout. Task 10 may move titles above the table in the final copies and re-run guarded checks. Cost if wrong: cosmetic.
- Carry to Task 8 (findings summary, open questions):
  - quote-to-sales-order conversion and reversing a wrong import (E-SAGE-026);
  - no evidence gathered on address-validation services;
  - costs at Brad's volumes need volume data.
- T7 review dispatched (sonnet).
- T7 review: Spec ❌ (both fixable by text); quality Changes needed (1 Critical, 11 Important, 10 Minor).
  - Passes: reorder rule verbatim; verdict strings match; order types separate; human gates held; no CRM; quote requests covered.
- Ruling 30 (C1): Keep email intake and customer PO extraction at P1, as an openly declared exception to spec §7.2 rule 5. Both are low-consequence and reversible, write nothing to Sage, and feed the SAGE-CSV quote import, which is the only Recommended path.
  - The matrix must state the exception and list "Sage draft sales order creation" first. Rule 5 is not to be reworded.
  - Cost if wrong: Brad may prefer to pilot CSV import alone with manual intake. The memo should offer that as the minimal pilot.
- Task 7: fix round 1 dispatched (resumed implementer af590f3a0d13de7cf), covering all findings.
- Task 7: fix round 1/5 (22 addressed, 0 open). The ledger diff shows only the 6 inference rows changed.
- Task 7: complete (review clean after fix round 1).
- Task 7: minor (deferred): row 5 Human approval cell is missing a full stop ("...Sage machine Sending a quote...").
- Ruling 31: "Ask Brad" validation items go in a "Client confirmations (Ask Brad)" section of vendor-questions.md, not only in the findings summary. Reason: Task 8's coverage check keys on "ask" in ledger column 14, and collecting them in one place helps Timothy. The findings summary still lists them as open questions, each with the decision it blocks. Cost if wrong: cosmetic, since Brad is not a vendor.
- Task 8 dispatched (sonnet).
- T8 (a8fedbcad0679e882) partial: vendor-questions.md (97 questions) and poc-tests.md (7 entries, POC-01–07) are written. findings-summary.md was drafted but not saved, because plan mode blocked its writes. No checks run yet.
- Plan mode: Timothy approved the plan at C:/Users/timrk/.claude/plans/sorted-purring-stream.md on 2026-11-06.
- DEC-09 / DEC-10 / DEC-11 (2026-11-06). Timothy's words: "Sage is where their product catalog lives (all products - newly introduced and standard products). Website ha some but not all. They are on Sage 50 Quantum Accounting 2026 cloud version. Quotes usually consist of a reps calling in or a hospital sending an email. Then the process becomes manual when they generate in Sage and send the product out".
  - DEC-09: A-01 confirmed as Quantum 2026. "Cloud version" is open.
  - DEC-10: Sage is the product master; the website is a partial catalog.
  - DEC-11: reps phone in quotes and hospitals email them; quotes are then built in Sage by hand.
- Ruling 32: Edition-dependent findings resolve only where the ledger covers Quantum 2026. "Cloud version" is not assumed either way; it becomes an Ask Brad question because it decides where Sage components run. Cost if wrong: one more question for Timothy to ask.
- Step 0 records dispatched (sonnet executor).
- Step 0 records done. New ledger rows: E-SAGE-053 (edition), E-SAGE-054 (product master), E-MAIL-018 (phone quotes). E-MAIL-016 and E-ECOM-014 Validation cells are marked resolved. Ledger now has 185 rows.
  - vendor-questions.md: B-01/03/14/16 marked answered or partly answered; B-19 added (cloud version).
- Matrix amendment for DEC-09 to DEC-11 done: no verdict or priority changes; 115 cited IDs, all present in the ledger. Before-copies are in t-amend/.
- Ruling 33: Run the amendment review and the Task 8 resume in parallel, because they touch disjoint files. Task 8 reads the matrices but writes only its own files. Cost if wrong: if the review changes matrix wording, Task 8's summary could cite stale text. That would be caught in Task 8's review and in Task 9.
- Amendment review dispatched (sonnet). Task 8 resumed with the DEC-09 to DEC-11 facts.
- Amendment review: Changes needed (2 Important, 5 Minor). Scope passed. The E-ECOM-014 and E-MAIL-016 Validation diffs are expected; they come from the controller's own DEC-08 and DEC-11 edits.
- Ruling 34: E-SAGE-053 is stakeholder-reported and not verified via Help, About. All wording says "reported as Quantum 2026 (stakeholder-reported, E-SAGE-053)", never "confirmed" or "known". In the Task 8 summary, A-01 reads "confirmed by stakeholder report 2026-11-06; verify via Help, About". This supersedes the plan's "A-01 confirmed" wording. Cost if wrong: none; it is more accurate.
- Ruling 35: Analyst-inference rows (not research rows) may be updated by a later amendment when the facts they infer from change. A before-copy is kept and the change is recorded. E-MAIL-017 is updated under this ruling. Cost if wrong: weaker immutability for inference rows; mitigated by the before-copies.
- Amendment: fix round 1 dispatched (resumed implementer).
- T8 returned DONE: 98 questions (19 Ask Brad), 7 PoC tests, 10 open questions. All guarded checks are clean.
- Ruling 36: T8 wrote findings-summary.md and its report with PowerShell, because the Write tool refused them with "Subagents should return findings as text". This is accepted. The files are this task's assigned deliverables in the draft folder, so the refusal was a harness heuristic, not a permission denial, and nothing was escalated. Cost if wrong: none.
- T8 concern: "matrices still say edition unknown in places". The T8 agent likely read the matrices before the amendment finished. The amendment fix round and Task 9 will confirm.
- T8 review dispatched (sonnet), in parallel with the amendment fix (disjoint files). The review enforces Ruling 34 on A-01 wording.
- Amendment DEC-09 to DEC-11: fix round 1 of 5 (7 addressed, 0 open). Re-check is clean. E-MAIL-017 before-copy saved.
- Amendment DEC-09 to DEC-11: complete (review clean after fix round 1). The ledger stays at 185 rows; no verdict or priority changed.
- T8 review: Spec ❌; quality: Changes needed (4 Critical, 8 Important, 6 Minor).
  - Passes: frozen PoC names, path coverage, DEC-06 to DEC-11, priority note, minimal pilot, no CRM, B-19, no "sent" language, verdicts match.
- Ruling 37: All three T8 folding choices accepted: Unishippers API in SHIP-PORTAL, manual baseline in SAGE-CSV, PO flow split across CSV and SDK.
  - Conditions: a falsifiable API-documentation criterion (I-5), and a representative timing set with no claim that E-SAGE-041 is validated (M-2).
  - Cost if wrong: SHIP-PORTAL tests two things at once; the report must keep them separable.
- Ruling 38: No PoC may use Brad's live accounts, credentials, tenant or systems, even with his consent. Only synthetic, sandbox or trial environments.
  - Where none exists, the test is "not run unless <vendor> confirms a non-billable test in writing". Applies to C-3, C-4 and I-1.
  - Reason: the spec §12 and global constraint against touching live systems, plus label charges that cannot be undone.
  - Cost if wrong: some PoCs wait on vendor answers. This is accepted.
- T8: fix round 1 dispatched (resumed implementer).
- Task 8: fix round 1/5 (17 addressed, 1 open: C-3, POC-05 still uses Brad's credentials). New findings: N-1/N-2 Important, N-3/N-4/N-5 Minor.
- Ruling 39: any PoC step that could incur a charge (labels, cloud services, developer fees) needs a gate: no cost, or spend approved by Timothy in advance. Each such step gets a matching "gate not met" fail criterion.
  - Reason: the spec §9 pilot controls on spending limits; label charges and fees cannot be reversed.
  - Cost if wrong: some PoCs wait for an approval, which is accepted.
- Task 8: fix round 2 dispatched (resumed implementer). All N findings are included.
- Task 8: fix round 2/5 (5 addressed, 0 open). "Noverhead" is sourced (E-SHIP-024).
- Task 8: complete (review clean after fix round 2).
- Task 8: minor (deferred): POC-05's gate names steps 2, 3 and 6; add step 4.
- Task 8: minor (deferred): POC-04 should say "decision date (set by Timothy in sub-project 3)".
- DEC-12 (2026-11-06). Timothy said: "provide me the testing script and clean & fix criteria and I will handle that with github copilot".
  - Task 9 verification moves to Timothy using Copilot.
  - The controller delivers a verification kit: verify.sh plus VERIFICATION-CRITERIA.md.
- Ruling 40: Copy the six drafts, the sources files and the ledger into Couple Dudes Doing Biz/01-evidence-feasibility/drafts/, clearly labelled as drafts.
  - Reason: Copilot cannot read the scratchpad, and Timothy's request requires it.
  - The final-file go gate still applies. Promoting files out of drafts/ needs his go.
  - Cost if wrong: drafts sit visibly in the project folder; the folder name guards against confusion.
- Ruling 41: Task 11 (workflow-summary.md) is not built by the controller. Its requirements and checks go in the kit, and building it is offered as an option. Reason: Timothy is taking over the next stage. Cost if wrong: one extra deliverable left for him.
- Kit build dispatched (sonnet executor).
- Tasks 1–4 dispatched in parallel (sonnet). Implementer agents: T1 a06913976c5cd2d82, T2 a1f9730564c51b218, T3 a529b28679e54dd2f, T4 ae36f30ce21edaec0.

## 2026-11-06 verification (Timothy: "run the tests yourself")
- verify.sh A-07 used grep -x (whole-line match), which was stricter than the plan's substring check, so it failed even though the formula is present verbatim (U+2212). Fixed to grep -qF.
  - Negative control: mutating the formula makes A-07 FAIL again.
  - Result: 45 PASS, 0 FAIL, 1 SKIP (W-*, Task 11 not built), EXIT=0.
  - The drafts/ copies are byte-identical to the reviewed scratchpad copies.
- Ruling 43: drafts/ in the project folder is now canonical. The scratchpad copies are stale from 2026-11-06 02:40 ET. Cost if wrong: none; one canonical copy.
- Spot-check (opus): 8 of 10 confirm, 2 partly confirm (E-AI-053, E-SAGE-023), 0 contradict, prices unchanged.
- Ruling 44: correcting a research row's claim to match its source after a spot-check is a factual correction, not making a check pass. It is allowed with a before-copy (verification/spotcheck-fixes.before.txt) and this ruling.
  - E-SAGE-023 is re-sourced if the overview page supports the templates; otherwise it is narrowed.
  - Limitations notes are added on E-AI-034 (2.5 Flash deprecated from 2026-12-01), E-AI-011 (cached copy) and E-AI-029 (derived 50%).
  - Cost if wrong: frozen-row immutability is weaker. Mitigated by the before-copies, and by test-plan gap G4 (row baseline hash) to be built next.
- TEST-PLAN.md written (/engineering:testing-strategy). /hyperflow:audit scope: the verification kit at L2. The verify.sh opus review serves as the reviewer pass, and TEST-PLAN.md has its own opus L2 reviewer.
- Spot-check fixes applied (opus). E-AI-053 corrected (Outlook send-from added, sources re-attributed; still verified). E-SAGE-023 NARROWED: CSV templates for quote, PO and customer are not confirmed in sources checked. Limitations notes added to E-AI-034, E-AI-011 and E-AI-029. Before-copies are in verification/spotcheck-fixes.before.txt. verify.sh: 45 PASS, 0 FAIL, 1 SKIP.
- Ruling 45: Because of the E-SAGE-023 narrowing, every "CSV-imported Sage quote" claim is rewritten to name three options for the draft record, each with its status:
  - (a) a CSV sales order held unprinted: the import is confirmed; the hold-for-approval convention is untested;
  - (b) an SDK quote: untested;
  - (c) a quote template: only if Sage confirms one.
  - No verdict or priority changes: CSV import is still Supported, and P1 stays.
  - POC-01 gets a quote-template check, and a matching question goes to Sage.
  - Cost if wrong: the pilot's draft record stays undecided until POC-01 runs. That is accepted, because it is the honest state.
- TEST-PLAN gap G11 added (a claim drifts from its citation; the structural checks cannot catch it).
- TEST-PLAN.md revised after the L2 audit (all 7 Important findings and the suggestions applied). Fixtures renamed FX-xx. One definition of "clean", kept in section 2. New gaps G12 (C-07 vs Rule 1) and G13 (xAI rows without A-02).
- Ruling 46 (resolves G13 by ruling, no new check): A-02 tags only the rows that interpret what Brad means by "GrokBot super" (SuperGrok and Grok Bot / X Super). Rows E-AI-011 to 020, about xAI API terms and pricing, are facts about xAI that hold under either reading, so they correctly carry no A-02.
  - Reason: spec section 4 says every finding that depends on an assumption carries its ID, and these rows do not depend on A-02.
  - Cost if wrong: if Brad meant an unrelated product, these rows would still be accurate, just less relevant.
- A-09 PoC-to-path map is marked "confirm when building". Accepted.
- verify.sh review (opus): 7/10, no Critical. 6 of 16 negative controls gave a false PASS (case-sensitivity, NBSP, DELTA exemption, P-03 line-count, A-05). Tool errors read as PASS; a blank line truncates the ledger; 8 plan Step 1 checks are missing.
- Ruling 47: A-05 follows spec §7.2 rule 3, which is stricter than the plan. Finalization, issuance and supplier-PO rows FAIL whenever the Recommended approach is agentic, whatever the approval cell says. Reason: the spec is the binding authority. Cost if wrong: a stricter check than the plan; it could flag a legitimately human-gated agent design.
- Ruling 48: The S-01 pool is S1 rows excluding snippet-only rows (Limitations contain "snippet only"), per Ruling 10. This adds E-AI-051, E-SAGE-025 and E-SAGE-026 back to the pool. K = ceil(20%) with a minimum of 5. The fixed IDs are drawn outside K, so the total is K+2. Cost if wrong: the pool differs from the spec's literal "all S1"; documented.
- Ruling 49: Remove the DELTA exemption from L-12, because the plan tags delta rows A-01. Cost if wrong: none.
- Ruling 50: VERIFICATION-CRITERIA.md is not built. Timothy moved from the Copilot hand-off to "run the tests yourself", so verify.sh points to TEST-PLAN.md. Cost if wrong: the criteria doc can be built later from TEST-PLAN.md.
- verify.sh fix plus a test-verify.sh regression suite dispatched (sonnet).
- Quote-claim amendment done (opus; resumed after rate limit). All 5 drafts were amended:
  - draft record is now options (a)/(b)/(c), untested and unchosen;
  - POC-01 has a new step 2, a quote-template check;
  - vendor question S-19 added;
  - no verdict or priority changed; verify.sh 45/0/1.
- E-SAGE-044 (an inference row) still asserted a quote by CSV. It is being updated under Ruling 35, with its before-copy added to spotcheck-fixes.before.txt.
- Next: a scoped review of the quote amendment plus E-SAGE-044, run in parallel with the verify.sh fixer (disjoint files).
- Quote-amendment review (sonnet): 7/7 addressed, no overstatement; verify.sh 45/0/1.
  - Leftovers being fixed in round 2:
    - E-SAGE-026 source annotation "(quotes template)" (Ruling 44 correction);
    - E-SAGE-051 inference row reads as a choice (Ruling 35);
    - POC-01 step 4 quote-conversion check is unconditional;
    - S-19 is missing from the matrix option lists.
  - The CRLF to LF change is harmless (verify.sh strips CR).
- Quote round 2 is done: E-SAGE-026 annotation corrected, E-SAGE-051 restated as options (a), (b) and (c), POC-01 step 4 made conditional, S-19 labels added in the matrices. Before-copies were kept.
  - The fixer's verify.sh run reported 49 PASS, 6 FAIL (L-02, L-19, L-20, L-22, L-23, L-26), 1 SKIP, 2 INFO, while verify.sh was mid-upgrade.
  - These FAILs are not acted on until the verify.sh fixer classifies them as script or draft. L-02 failing with no banned phrase present suggests a script bug.
  - Task 3 quote amendment: deferred minor. The "(c) (S-19) a quote" word order is awkward.
- verify.sh upgrade (sonnet) done. Every review finding (1-23) is applied. New checks L-18, L-19..L-26, L-00b, P-07, V-03; IDs reserved per TEST-PLAN are left unused.
  - verify.sh: 50 PASS / 5 FAIL / 1 SKIP / 2 INFO. All 5 FAILs are draft-scope (L-19, L-20, L-22, L-23, L-26), on SR and inference rows.
  - test-verify.sh: 82 cases. 80 OK / 0 BAD / 2 SKIP (FX-14 and FX-15 wait for L-15 and P-06), but it ran in two pieces. The full single run is still pending.
  - S-01: pool 49, K=10, sample 12, seed printed.
- Ruling 51: The Task 1-4 domain-format checks (L-19, L-20, L-22, L-23, L-26) apply to research rows only. Stakeholder and analyst-inference rows are exempt. Their scope comes from the stakeholder or from the cited research rows, which pass.
  - The plan's Task 9 instruction to run the Task 1-8 checks on the merged ledger predates SR and inference rows. This is a check-scope correction, not a weakening: research rows are still caught (new test RESEARCH-STILL-CAUGHT).
  - Cost if wrong: inference rows carry a looser explicit scope. Mitigated by G11 (claim drift) and manual review.
- Dispatched the scope change plus a full test-verify.sh run (sonnet). In parallel, the controller writes HANDOFF.md and saves memory (Timothy asked to store info and compact after this run).

## 2026-11-06 cloud session (Timothy: "this session" carries on; work tracked in git, repo David-Scott)

- Folder moved into git (private repo `David-Scott`, path `Couple Dudes Doing Biz/`). From here git history is the change record; the before-copies stay as they are.
- Step 1 re-run from a clean checkout on Linux (GNU awk 5.2.1): verify.sh 55 PASS / 0 FAIL / 1 SKIP / 2 INFO; test-verify.sh full single run 82 OK / 0 BAD / 2 SKIP. Matches Timothy's local audit.
- Ruling 52: G4 is built as check L-15 against a sha256 baseline of every research row, and the first baseline is taken from the drafts as they stand, because they pass every script check and both independent runs agree.
  - A research row is the Ruling 51 definition: Source type is not stakeholder or analyst inference. 136 rows qualify. The definition and the hash live once, in `research-rows.lib.sh`, which both verify.sh and `baseline-research-rows.sh` use.
  - L-15 FAILs on three things: a changed row; a baselined row that is gone or no longer a research row (retyping a row to stakeholder would otherwise escape both the freeze and the Ruling 51 checks); a research row with no baseline.
  - The hash covers the whole row after CR is stripped, so a whitespace-only edit also FAILs. That is deliberate: re-baselining is cheap and every change gets a ruling.
  - Update path: edit the row under a ruling, run `bash baseline-research-rows.sh "Ruling NN"` in the same change, commit both. The script records the date, ruling, row count and changed IDs in the baseline's history.
  - Stakeholder and inference rows are not frozen. Their drift is G11's job (claim drifting from its citation), still open.
  - Cost if wrong: the baseline freezes any undetected error in today's research rows; the S-01 spot-check and G11 remain the guard against that.
- test-verify.sh: FX-14 is now a real case, plus L15-RETYPE, L15-NEW and L15-SR-EXEMPT (a stakeholder edit must not trip L-15). The two display issues from the local audit are fixed: the baseline line prints "none", and the totals print results and cases separately (BASELINE gives two results).
