# Test plan: sub-project 1 evidence package

**What is tested:** the seven deliverables in `../drafts/` (the evidence ledger, two matrices, vendor questions, PoC tests, the findings summary, and the workflow summary, built under Task 11, Ruling 53), plus `verify.sh`.

**Authority:** spec §6, §7, §11, §12 and §15, the rulings in the controller ledger, and the plan's Step 1 checks.

**Status at 2026-11-06, after Task 11 and G1, G4, G5, G6, G12 (Rulings 52 to 55):** `verify.sh` reports 69 PASS, 0 FAIL, 0 SKIP, 3 INFO, exit 0 (after G2, G7 and G11, Ruling 56). `test-verify.sh` full run: 114 OK, 0 BAD, 0 SKIP; every check has a fixture. Clean (§2) items 1 to 3 hold. Items 4 to 6 (spot-check, P-05 lines, manual checklist) are reviewed in `manual-checklist-review-2026-11-06.md` and await Timothy's sign-off.

Revised 2026-11-06 after L2 audit (test-plan-audit.md).

**ID namespaces.** Several ID families look alike. They are different things:

- Check IDs (L-, C-, A-, P-, F-, V-, S-, W-) name `verify.sh` checks. They are always written with the prefix "check", for example "check A-01".
- Assumption IDs are A-01 and A-02 (spec §4).
- Question IDs are S-, U-, V-, M-, B- and O-. The mail questions run M-01 to M-05.
- Fixture IDs are FX-xx (section 5). They were M-xx, which clashed with the mail question IDs.

## 1. The pyramid, adapted to evidence documents

| Layer | What it proves | Type | How many | Speed |
|---|---|---|---|---|
| **Unit** (row and cell rules) | Each row or cell obeys a format or evidence rule: 15 columns, allowed strings, dates, labels, banned wording | Automated, `verify.sh` checks L-, C-, A-, P-, F- | ~35 | Seconds |
| **Integration** (cross-file consistency) | Files agree with each other: cited IDs exist, every viable path has a PoC, every "Ask" item has a question, the summary quotes the matrices correctly | Automated (checks C-10, A-08, F-04, P-04, V-01), plus manual where a gap is noted | ~8 | Seconds, or minutes when manual |
| **Acceptance** (does the evidence hold) | Sources say what the claims say; nothing is overstated; the gates protect Brad's live systems and money | Manual: check S-01 spot-check, the P-05 review list, the overstatement checklist | 10–12 sources plus the checklist | About an hour |
| **Meta** (does the test suite work) | Each check fails when its rule is broken | Fixtures (mutation tests) | At least 1 per check family now; 1 per check before edits (§2) | Seconds |

## 2. Coverage targets and the definition of clean

- **Spec §11:** 8 of 8 criteria map to at least one test (§3).
- **Fixtures:** about 17 of the 44 checks had a fixture when this plan was written; since Ruling 56 every check has one (§5). Target now: at least one fixture per check family (L, C, A, V, P, F, S). Target before Copilot or anyone else edits the drafts: every check has a fixture.
- **Spot-check:** 20% of verified S1 rows (minimum 5), drawn at random, plus the forced IDs E-SAGE-007 and E-AI-053. All must confirm.
- **Definition of clean (single source; §6 and §7 refer here):**
  1. 0 FAIL.
  2. A SKIP is allowed only for a file that does not exist yet (since Task 11, Ruling 53, no deliverable is missing, so no SKIP is allowed).
  3. Every fixture in §5 fails its named check (`test-verify.sh` once G8 exists).
  4. Every spot-checked source confirms its claim.
  5. Every check P-05 line is a prohibition, a gate, a criterion or information, not a step.
  6. The manual checklist in §6 is signed off.

## 3. Spec §11 criteria and the tests that cover them

| § 11 | Criterion | Tests | Gap |
|---|---|---|---|
| 1 | Every §5 question has a ledger entry, or an Unresolved entry with Validation needed filled | check L-14 | **G1.** Check L-14 only checks that the question ID appears. It does not check that unknown or hypothesis rows have a non-empty Validation needed cell. |
| 2 | Every matrix cell cites an ID or says Unresolved | checks C-04, A-03, C-10, A-08 | None |
| 3 | No "Recommended for PoC" without Supported evidence | checks C-07, C-08 | **G12.** Check C-07 only tests the leading string "Supported". It does not test spec §6 Rule 1: a "Supported" cell cites S1 evidence, or S2 plus a named PoC. |
| 4 | Pricing is S1 with a date, or labelled | checks L-03 (access date), L-04 (pricing) | None |
| 5 | No "not supported" | check L-02, applied to all files | None |
| 6 | Assumption-dependent findings carry their assumption tag | checks L-12, L-13 | **G2.** No check tests the matrices' assumption A-01 wording ("reported as Quantum 2026", Ruling 34) outside findings-summary.md. **G13.** Check L-12 covers assumption A-01 on D1 rows only. Check L-13 covers assumption A-02 only where the Claim says SuperGrok. Spec §4 ties A-02 to the D4 xAI rows, but E-AI-011 to E-AI-020 carry no A-02. |
| 7 | Source spot-check | check S-01 (manual) | **G3.** See §4. |
| 8 | Order types never share a row | check A-04 | None |

## 4. Gaps outside §11, ranked by risk

This table is ranked by harm if the gap stays open. §7 is ranked by build order, which differs on purpose (see §7).

| # | Gap | Risk | Proposed test | Type |
|---|---|---|---|---|
| **G4** | **Frozen research rows.** Nothing detects an edit to a research row, which the rules allow only via a ruling. This is the highest risk once Copilot starts editing. | Evidence silently altered | Store a baseline `sha256` of each research row (Source type ≠ analyst inference or stakeholder) in `verification/`. New check L-15 diffs the current rows against it and lists every changed ID. **Update path:** when a ruling changes a row, re-baseline in the same change and record the ruling ID with it, so the listed IDs can be matched to rulings. **Built 2026-11-06 (Ruling 52):** check L-15, baseline `research-rows.sha256` (136 rows), re-baseline with `baseline-research-rows.sh "<ruling>"`, shared definition in `research-rows.lib.sh`. Also FAILs on a research row retyped to stakeholder or inference, and on a research row with no baseline. | Integration |
| **G5** | **Live-system and cost gates** (Rulings 38 and 39). Check P-05 only lists the lines; it cannot prove a gate exists. | A PoC touches Brad's live account or incurs a charge | New check P-06 tests two things separately and case-insensitively, per PoC section whose steps match P-05's keyword list plus `endpoint`, `credentials` and `\blabel\b` (word-bounded, so "labelled" does not match): (a) a gate statement (`cost gate\|account gate\|Gate \(Rulings`); (b) a `gate not met` fail criterion. **Built 2026-11-06 (Ruling 54):** check P-06; fixtures FX-15, P06-NOTMET, P06-NEWRISK, P06-ACCOUNTING. | Unit |
| **G6** | **Summary against matrices.** The verdict counts and priorities quoted in findings-summary.md are checked only by hand. | Brad's memo quotes stale numbers | New check F-05: count the verdict strings in connectivity-matrix.md and compare them with the counts stated in the summary; compare the P1, P2 and P3 task lists. **Built 2026-11-06:** check F-05; fixtures F05-COUNT, -TOTAL, -LIST, -INLINE, -PRIO, -STALE. | Integration |
| **G7** | **Automation against connectivity.** Nothing scripts whether "Recommended approach" in the automation matrix matches the connectivity verdicts. | A task rated better than its path allows | New check A-09. Needs the PoC-to-path map below. For each PoC name in an automation cell, evaluate it separately: if the cell calls that PoC's path "Recommended for PoC", the connectivity Verdict for the mapped path must say it too. Several PoC names can share a cell (automation rows 5 and 7 pair SAGE-CSV with SAGE-ODBC or SAGE-SDK), so never match the verdict string to the whole cell. **Built 2026-11-06:** check A-09 reads the PoC-to-path map from poc-tests.md Path lines (it matches the table below) and also checks each Path line's quoted verdict; fixtures A09, A09b, A09-POC. | Integration |
| G1 | Unresolved entries without a validation step | An open item has no next action | New check L-16: rows with status unknown, or hypothesis with "Unresolved" in Limitations, have a non-empty Validation needed cell (not "none"). | Unit |
| G2 | Assumption A-01 overclaimed in the matrices | Assumption presented as fact | New check F-06 (check F-02 stays as is: no bare CONFIRMED, findings-summary.md only). Apply to both matrices: fail on `confirmed as Quantum\|edition now known\|Quantum 2026 confirmed`, and assert that "reported as Quantum" is present (5 hits in the connectivity matrix, 2 in the automation matrix today). **Built 2026-11-06:** check F-06, also applied to workflow-summary.md; fixtures F06, F06b. | Unit |
| G3 | Spot-check sample cannot be audited. `verify.sh` already accepts a `SEED` env var (lines 12 and 361–362) and feeds it to `shuf --random-source`, so the draw is reproducible. Two real problems: (a) the seed is not printed in the check S-01 output; (b) the header count K ignores the forced IDs E-SAGE-007 and E-AI-053 when `sort -u` merges them into the drawn rows, so K can disagree with the rows listed. | Audit cannot re-draw the same sample; header count wrong | Print `SEED` in the check S-01 line. Compute K after the `sort -u` merge. No new `--seed` flag. **Resolved before 2026-11-06:** the S-01 line prints SEED, and the total is K+2 by construction; BASELINE-S01 and S-SEED assert both. | Meta |
| G8 | No regression suite for `verify.sh` | A script fix silently disables a check, as check A-07 nearly did | Add `test-verify.sh`, which runs every fixture in §5 and asserts that the matching check FAILs. | Meta |
| G9 | Encoding edge cases | Unicode or CRLF break matching (the check A-07 lesson) | Fixtures with CRLF line endings, U+2212 minus versus hyphen, and non-breaking spaces. **Resolved:** FX-16 (CRLF), FX-01 (U+2212 minus), NC6 (non-breaking space). | Meta |
| G12 | Supported cell without Rule 1 evidence | A path rated Supported on weak sources | New check C-11: every cell starting "Supported" cites at least one S1 row, or an S2 row plus a named PoC. | Unit |
| G13 | Assumption A-02 missing on xAI rows | Assumption presented as fact | Either cite a ruling that exempts the xAI API rows (E-AI-011 to E-AI-020), or add check L-17: every D4 xAI row carries A-02. | Unit |
| **G11** | **A claim drifts away from its citation.** A matrix or summary cell cites a row that still exists, but that row no longer supports the claim. This happened on 2026-11-06: E-SAGE-023 was narrowed and quote templates are now unconfirmed, yet cells still said "CSV-imported quote" and cited it. Every ID-existence check stayed PASS. | Pilot designed on an unsupported capability | Whenever a row's Claim changes, list every cell that cites it for re-review. For example, `verify.sh --impact E-SAGE-023` prints those cells. The re-review itself is manual. **Built 2026-11-06:** `bash verify.sh --impact <ID>...` lists every cited cell (row and column) outside the ledger; `baseline-research-rows.sh` prints it automatically for every changed or removed research row. The re-review stays manual. | Integration and manual |

**PoC-to-path map for check A-09** (confirm against poc-tests.md and connectivity-matrix.md when building):

| PoC name | Connectivity path |
|---|---|
| SAGE-CSV | Sage: CSV import/export |
| SAGE-SDK | Sage: SDK or direct data access |
| SAGE-ODBC | Flow: Sage to dashboard (read-only) |
| SHIP-PORTAL | Shipping: Unishippers portal |
| SHIP-MULTI | Shipping: multi-carrier tool |
| MAIL-INTAKE | Flow: email intake |
| SAGE-TRACKING | Flow: tracking back to Sage |

**Note on G10.** W-* checks for Task 11 are already in `verify.sh` and activate when workflow-summary.md exists. This is not a gap.

## 5. Fixtures (mutation tests)

Each fixture copies `../drafts` to a temporary directory, applies one `sed` change, runs `bash verify.sh "$TMP"`, and asserts that the named check fails.

| ID | Mutation | Expected |
|---|---|---|
| FX-01 | Change the U+2212 minus in the reorder formula to a hyphen | FAIL check A-07 |
| FX-02 | Insert "not supported" into one connectivity cell | FAIL check L-02 |
| FX-03 | Change one Accessed date to `11/06/2026` | FAIL check L-03 |
| FX-04 | Change a non-S1 pricing row's claim to remove "quoted, unverified" | FAIL check L-04 |
| FX-05 | Swap the order of two ledger rows | FAIL check L-07 |
| FX-06 | Delete one side of a Conflicts-with pair | FAIL check L-09 |
| FX-07 | Change the CSV row's Supported evidence to "Partially supported" while keeping "Recommended for PoC" | FAIL check C-07 or C-08 |
| FX-08 | Set the UI automation verdict to "Viable with conditions" | FAIL check C-09 |
| FX-09 | Cite `E-SAGE-999` in an automation cell | FAIL check A-08 |
| FX-10 | Remove "human authorizes" from the Inventory row | FAIL check A-06 |
| FX-11 | Rename `POC-03 — SAGE-ODBC` to `POC-03 — SAGE-READ` | FAIL check P-02 |
| FX-12 | Replace the assumption A-01 qualifier with "CONFIRMED" using a global replace (the qualifier is on 2 lines of findings-summary.md, and check F-03 fails only if both change) | FAIL checks F-02 and F-03 |
| FX-13 | Delete the "Resolves: E-SAGE-007" reference from vendor-questions.md (E-SAGE-007 appears once, at line 17). Check V-01 looks for ledger E- IDs, not question IDs, and the file has no "Ask Sage:" text | FAIL check V-01 |
| FX-14 | Change one word in a research row's Claim (also L15-RETYPE, L15-NEW; L15-SR-EXEMPT must not FAIL) | FAIL check L-15 |
| FX-15 (after G5) | Delete both cost-gate sentences from POC-06 (lines 183 and 190); the "Gate not met" line at 206 stays, so only the gate-statement test fails | FAIL check P-06 |
| FX-16 | Clean run with CRLF line endings | All PASS (CR stripped) |

Checks with no fixture yet: L-01, L-05, L-06, L-08, L-10, L-11, L-14, C-01 to C-06, C-10, A-01 to A-05, V-02, P-01, P-03, P-04, F-00, F-01, F-04. Add them in G8, one family at a time.

## 6. Manual acceptance checklist (cannot be scripted)

Sign-off is part of "clean" (§2).

- [ ] Each check S-01 source confirms its claim as written: numbers, units, plan or model names, edition and version.
- [ ] No claim in either matrix or in the summary is stronger than the rows it cites.
- [ ] Every check P-05 line is a prohibition, a gate, a criterion or information, not a step.
- [ ] The three PoC folding choices stay separable in the results (Ruling 37).
- [ ] Open questions are ranked so that items blocking P1 tasks come first (I-6).
- [ ] Nothing reads as if a vendor or Brad was contacted.

## 7. Recommended order

This is build order, not the risk order of §4. G8 comes second because it guards every other check: a new check without a fixture can fail silently. G4 comes with it because it must exist before anyone edits the drafts. G7 has a high risk rank but a dependency (the PoC-to-path map), so it follows the cheaper checks.

1. Finish the check S-01 spot-check and the `verify.sh` review. **Done 2026-11-06.**
2. **Done 2026-11-06 (G4 under Ruling 52; G8 is `test-verify.sh`).** Build **G4** (frozen-row baseline) and **G8** (`test-verify.sh` covering fixtures FX-01 to FX-13 and FX-16, which needs no new check) **before** anyone, Copilot included, edits the drafts.
3. **All done 2026-11-06:** G1, G2, G5, G6, G7, G11, G12 built; G3 and G9 already covered; G13 resolved by Ruling 46. Add G5, G6 and G1, then G12, G13, G2, G3, G7 and G9.
4. **Done 2026-11-06 (Ruling 53).** Build Task 11. W-* then runs automatically.
5. Re-run everything. Clean is defined in §2.
