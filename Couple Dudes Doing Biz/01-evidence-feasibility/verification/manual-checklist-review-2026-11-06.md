# Manual acceptance checklist (TEST-PLAN §6): review record

Prepared 2026-11-06 in the cloud session, after the full run (verify.sh 67 PASS / 0 FAIL / 0 SKIP / 3 INFO; test-verify.sh 109 OK / 0 BAD / 0 SKIP).

**Status: reviewed, not signed off.** Sign-off is Timothy's. The column "Reviewer's finding" is the evidence for that decision, not the decision.

| # | Checklist item | Reviewer's finding | Proposed |
|---|---|---|---|
| 1 | Each check S-01 source confirms its claim as written | 12-row draw (SEED=handoff-2026-11-06): 11 confirmed, 1 partly confirmed (E-AI-028: prices exact, the "up to 272K tokens" qualifier not visible in the excerpt), 0 contradicted, no price changed. Details: `spot-check-2026-11-06b.md`. The first draw (`spot-check-2026-11-06.md`) had 2 partials, both corrected. | Pass with one follow-up: re-check E-AI-028's context qualifier, or narrow the row under a ruling (it is frozen, so it needs a re-baseline). |
| 2 | No claim in either matrix or the summary is stronger than the rows it cites | Scripted support now covers the structural part: C-07, C-08 and C-11 (Supported needs S1, or S2 plus a PoC), F-05 (summary quotes the matrices), W-06/W-07 (workflow summary quotes the matrices). A wording scan of all four files for "confirmed", "proves", "always", "guarantee", "known", "fully supports" and similar found only hedged or benign uses (for example "the confirmed extraction" means confirmed by a person; "always a suggestion" is a design rule). A full cell-by-cell reading against every cited row was **not** done in this session. | Timothy's call: accept on the scripted checks plus the wording scan, or ask for a cell-by-cell read before sign-off. |
| 3 | Every check P-05 line is a prohibition, a gate, a criterion or information, not a step | 14 lines. 12 are gates, criteria or information. **Two are steps**: line 131 (POC-04 step 6, "Void the label and record ... any charge"), gated only by its Part B heading at line 129; and line 192 (POC-06 step 4, "Renew a subscription ..."), which carries its own inline cost gate. Both are gated, and P-06 confirms each section has a gate and a "gate not met" criterion. Line 236 is a false keyword match ("Brad's accounting basis"). | Either accept "a step is fine when it is gated", or reword the two steps so the gate sits on the step line (POC-04 step 6). The text is unchanged pending that decision. |
| 4 | The three PoC folding choices stay separable in the results (Ruling 37) | Holds. SAGE-CSV times the manual baseline as a separate comparator (poc-tests line 17). SHIP-PORTAL keeps the Unishippers API as a documentation-only step with its own fail criterion (lines 127, 144). The PO flow is split between POC-01 (CSV options) and POC-02 (SDK quote half, line 52). | Pass. |
| 5 | Open questions are ranked so that items blocking P1 tasks come first (I-6) | Holds. In "Ranked unknowns", items 1 to 6 each block a P1 task (Sage draft record, including SDK option (b), email intake, PO extraction); items 7 to 11 block P2 or P3 tasks or cost lines only. | Pass. |
| 6 | Nothing reads as if a vendor or Brad was contacted | Holds. A search of every draft for contact wording ("we asked/emailed/contacted/called/sent", "replied", "told us", "was sent") finds only the two statements that nothing has been sent. Brad's 2026-11-06 answers are recorded as relayed by Timothy (DEC-09 to DEC-11). | Pass. |

Also for Timothy, from the same run (not checklist items):

- INFO L-16sr: three stakeholder-reported rows have no Validation needed entry: E-ECOM-015, E-MAIL-018, E-SAGE-054 (Ruling 55).
- workflow-summary.md open question 6 (how reorders are decided today) is new and not yet in vendor-questions.md.
