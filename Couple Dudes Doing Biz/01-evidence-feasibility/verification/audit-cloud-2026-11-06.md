# Independent audit: sub-project 1 evidence package (cloud, 2026-11-06)

Scope: `main` at 1a299e3, folder `Couple Dudes Doing Biz/01-evidence-feasibility/`. Commits reviewed: 6cea749..1a299e3 (G4/L-15 Ruling 52, Task 11 Ruling 53, G5/P-06 Ruling 54, G6/F-05, G1/L-16 and G12/C-11 Ruling 55, F-06/A-09/`--impact` Ruling 56, final totals). Read first: `HANDOFF.md`, `verification/controller-ledger.md`, `verification/TEST-PLAN.md`. Timothy's local copy was not used; `main` is canonical.

This audit made no production writes, no vendor contact and no purchases, and it touched no live system. Nothing is merged.

## Verdict

**Sound, with two holes in the new W-06 check and one numbering gap in the rulings log.** The claimed totals reproduce exactly. No draft claim, verdict or priority changed in the reviewed range. Every verdict and priority in `workflow-summary.md` matches the two matrices. The evidence discipline holds. Two W-06 mutations pass undetected: a wrong verdict paired with a path label that lacks a `Sage:`/`Shipping:`/`Flow:` prefix, and a verdict whose `[Path]` bracket has been dropped. Neither hole affects today's file, which is correct, but W-06 is weaker than Ruling 53 says it is. The fixes applied here are wording only (proposed Rulings 57 and 58). Neither changes a check, verdict or priority.

## 1. Test re-run (step 1)

| Run | Result | Claimed at 1a299e3 |
|---|---|---|
| `bash verify.sh`, fresh container, mawk only | `FAIL SETUP — GNU awk (gawk) is required`, exit 2. The setup guard works as designed. | — |
| `bash verify.sh`, after `apt-get install -y gawk` (GNU Awk 5.2.1) | **69 PASS, 0 FAIL, 0 SKIP, 3 INFO**, exit 0 (1.4 s) | 69/0/0/3 ✔ |
| `bash test-verify.sh` (6 jobs) | **114 OK, 0 BAD, 0 SKIP** (114 results from 113 cases), exit 0 (41 s) | 114/0/0 ✔ |
| Both again, after this audit's fixes | 69/0/0/3 and 114/0/0 | unchanged ✔ |

The three INFO lines are L-16sr (E-ECOM-015, E-MAIL-018, E-SAGE-054), P-05 (14 lines) and S-01 (12-row sample). **Confirmed.**

## 2. Commit review (step 2)

**Mutation coverage of the new checks.** Each new check FAILs under at least one passing mutation case in test-verify.sh: L-15 ×4, L-16 ×2, C-11 ×3, A-09 ×3, P-06 ×4, F-05 ×6, F-06 ×2, W-06 ×2 and W-07 ×2. L-16sr is INFO and is pinned by BASELINE-S01's INFO count. `--impact` and `baseline-research-rows.sh` have no case at all (Suggestion S1). I added probes of my own (scratch copies only, never the drafts):

| Probe | Expected | Got |
|---|---|---|
| `Unresolved [Flow: tracking back to Sage]` → `Recommended for PoC [Tracking back to Sage]` | W-06 FAIL | **69 PASS, no FAIL** (hole, I1) |
| `\| Unresolved [Flow: tracking back to Sage] \|` → `\| Recommended for PoC \|` | W-06 or W-07 FAIL | **69 PASS, no FAIL** (hole, I2) |
| workflow-summary "reported as Quantum 2026" → "confirmed as Quantum 2026" | F-06 FAIL | F-06 FAIL ✔ (this branch has no fixture, S2) |
| automation matrix deleted | F-06 line printed | **no F-06 line** (S3) |
| an unknown row's Validation needed set to `N/A.` | L-16 FAIL | L-16 PASS (only L-15 fired) (S4) |
| a Current-workflow row cites a research row (E-SAGE-023) | something flags it | nothing (S5) |

**Draft changes without a ruling.** `git diff --name-status 6cea749^..1a299e3 -- drafts/` shows one file: `A drafts/workflow-summary.md`, which is new (Ruling 53). No existing draft line changed in the range. The ledger, both matrices, poc-tests, vendor-questions and findings-summary are byte-identical to 6cea749^. L-15 PASSes against the 136-row baseline. **Holds.**

**workflow-summary.md against the matrices.** I compared all 10 `Verdict [Path]` pairs and all 9 priorities with `connectivity-matrix.md` column 11 and `automation-feasibility-matrix.md` column 12 by hand. Each string matches exactly, and each of the 9 automation tasks has one row. **Holds.** Which path a row brackets is a separate question (J3).

**Rulings log numbering.** Rulings 1–41 and 43–56 each appear once; there are no duplicates. **Ruling 42 does not exist** (I3). No other file in the repo mentions "Ruling 42", and the gap has been there since the import commit f6e377a.

## 3. Evidence discipline (step 3)

- **Facts, stakeholder reports, assumptions and unknowns.** The ledger keeps `stakeholder-reported` / `SR` / `stakeholder` separate from research rows. Every ID that workflow-summary.md's Current-workflow table cites (lines 17–24) is a stakeholder-reported SR row. A-01 and B-12 are carried as assumptions (line 9). Step 8 says Unresolved instead of guessing. **Holds.**
- **"verified" means fetched, not tested.** The ledger header defines it so (`drafts/evidence-ledger.md:17`), and no row is PoC-validated. One edge case is E-AI-011 (`evidence-ledger.md:45`): it stays `verified` although the 2026-11-06 re-check read a cached copy after a 403 (J4).
- **Nothing claims a vendor question was sent.** Searches for "we asked/emailed/contacted/called/sent", "was sent", "vendor replied/confirmed" return only the denials in `vendor-questions.md:5` and `workflow-summary.md:77`, the before-copy and the checklist review. V-02 PASSes. **Holds.**
- **One overstatement, fixed.** In `workflow-summary.md:66`, the Haiku 5.5 and gpt-6-luna prices had lost the scope qualifiers their S1 rows carry: "prompts up to 100,000 tokens" in E-AI-021 and "context up to 272K tokens" in E-AI-028. Fixed (F4, proposed Ruling 58).

## 4. Findings

### Critical

None.

### Important

- **I1. W-06 ignores a bracketed path label without a `Sage:`/`Shipping:`/`Flow:` prefix**, so a wrong verdict passes. `verification/verify.sh:710`. Ruling 53 says "an unknown path label also FAILs", but the code only flags unknown labels that start with one of the three prefixes, and silently skips the rest. *Fix (needs a ruling, not applied):* inside `## Assessed workflow`, flag every `[...]` that follows a verdict string and is not a matrix label. Outside that section, keep the prefix filter so bracketed IDs elsewhere do not trip it. Add fixture W06c from probe 1.
- **I2. An Assessed-workflow row whose verdict has no `[Path]` is not checked at all.** `verification/verify.sh:699–731`; W-07 there checks priority only. The tracking step could read "Recommended for PoC" and every check would pass. That is the plan's Task 11 rule ("every verdict ... must match exactly") left unguarded. *Fix (needs a ruling, not applied):* W-07, or a new W-08, requires that column 5 of each Assessed-workflow row consist only of `Verdict [Path]` pairs separated by `; `. Add fixture W06d from probe 2.
- **I3. Ruling 42 is missing from the rulings log.** `verification/controller-ledger.md:237–246` (Ruling 41 is followed directly by Ruling 43). *Fix:* Timothy's call (J1). Not filled here, because inventing a ruling's text would be worse than the gap. HANDOFF now says the number was never used (F2).

### Suggestions

- **S1.** `verify.sh --impact` (`verify.sh:35–65`, branch at line 38) and `baseline-research-rows.sh` have no regression case. *Fix:* add cases. `--impact E-SAGE-023` lists at least one line in each matrix. `--impact E-SAGE-02` lists nothing (the prefix boundary). The baseline script refuses to run without a ruling argument, and a changed row appears in its "changed:" history line.
- **S2.** F-06's `workflow-summary.md` branch (`verify.sh:659–662`) works (probe 3) but has no fixture. *Fix:* add F06c from probe 3.
- **S3.** F-06 is emitted only inside the F-05 branch. When a matrix is missing, the `else` branch at `verify.sh:669` prints `SKIP F-05` and nothing for F-06. That breaks the header rule "every check prints exactly one line". X-00 still FAILs, so nothing is hidden. *Fix:* add `emit SKIP F-06 "..."` in the same `else` branch.
- **S4.** The L-16 and L-16sr placeholder regex (`verify.sh:300, 304`) matches whole cells only, so `N/A.`, `None.` and `TBD -` count as real entries. *Fix:* strip trailing punctuation before matching, for example `x=lc($14); gsub(/[ .;:!-]+$/,"",x)`.
- **S5.** "Current workflow uses stakeholder-reported rows only" (Ruling 53 notes; `workflow-summary.md:13`) is true today but not scripted. *Fix:* an optional W-check that every E- ID in the Current-workflow table has Strength SR.
- **S6.** `HANDOFF.md:25` says a full test-verify.sh run takes about 20 minutes. Here it took 41 s with 6 jobs. *Fix:* say it depends on JOBS and the machine (not applied, since the PC timing may be right for the PC).
- **S7.** `TEST-PLAN.md` G1 (line 63) still describes L-16 as "unknown, or hypothesis with 'Unresolved' in Limitations". The built check, per Ruling 55, covers every unknown or hypothesis row. *Fix:* align the G1 wording with Ruling 55 when TEST-PLAN is next revised.
- **S8.** `workflow-summary.md:65` gives the Azure price as "S1 page, status hypothesis". E-AI-041 is snippet-only and counts as S4 (Ruling 10). *Fix:* add "snippet only". This is close to mechanical, but it changes how the price's strength reads, so it is left for Timothy.

## 5. Fixes applied in this PR

Each one has its before-copy in `verification/audit-cloud-2026-11-06.before.txt` and is recorded as a *proposed* ruling in `controller-ledger.md`, pending Timothy's acceptance. None changes a check's behaviour, a claim in the ledger, a verdict or a priority. Both suites still give 69/0/0/3 and 114/0/0.

| # | File:line | Change | Proposed ruling |
|---|---|---|---|
| F1 | `verification/verify.sh:20–22` | The header comment listed L-16, P-06, F-05, F-06, A-09 and C-11 as "deliberately unused"; all six are built. It now names only L-17 as unused, and lists the built gap checks. Comment only. | 57 |
| F2 | `HANDOFF.md:17` | "Rulings 1–51" → "Rulings 1–56", noting that 42 was never used | 57 |
| F3 | `verification/TEST-PLAN.md:3, 30, 34` | Removed "workflow summary, which is not yet built", the "17 of the 44 checks have a fixture today" status, and "SKIP allowed ... today, W-*". All three were stale after Rulings 53 and 56. The §2 rule text is unchanged. | 57 |
| F4 | `drafts/workflow-summary.md:66` | Added the scope qualifiers from E-AI-021 (≤100,000-token prompts; 0.50/2.50 USD over) and E-AI-028 (context ≤272K tokens; long-context rates higher) | 58 |

## 6. Judgment calls for Timothy (not decided here)

- **J1. Ruling 42.** Does your local copy hold a Ruling 42? If so, bring its text into main as Ruling 42. If not, record "42 unused". The local copy's own G4 build is also numbered Ruling 52, so take nothing from it by number; main's 52 to 56 stand.
- **J2. Proposed Rulings 57 and 58.** Accept or reject them in PR review. If you reject 58, revert line 66 from the before-copy.
- **J3. Which path a workflow-summary row brackets.** The "Customer and SKU matching" row (line 36) and the "Inventory monitoring" row (line 42) both read Sage by "CSV export or read-only ODBC", but they show only `Recommended for PoC [Sage: CSV import/export]`. The "Quantity, price and address validation" row (line 37) shows both its CSV and its ODBC verdicts. Adding `Viable with conditions [Sage: SDK or direct data access]`, or `[Flow: Sage to dashboard (read-only)]` (the path that TEST-PLAN maps SAGE-ODBC to), would change no verdict. Which path to cite is still your call. Fix I1 and I2 first, so the result is checked.
- **J4. E-AI-011 `verified` on a cached copy** (`evidence-ledger.md:45`). The live fetch returned 403, and the claim was confirmed against a cache dated 2026-10-23. Is a dated cache a "fetch" for the `verified` definition? If not, the row moves to hypothesis under a ruling and a re-baseline.
- **J5. Fixing I1 and I2** changes check behaviour, so it needs a ruling (proposed 59). The proposed W-06 fix may also flag other bracket uses inside the Assessed section. Run the full suite before you accept it.
- **Carried over, still open:** manual-checklist items 2 and 3 (`manual-checklist-review-2026-11-06.md:10–11`); the E-AI-028 qualifier follow-up (`spot-check-2026-11-06b.md:24`); Validation needed for E-ECOM-015, E-MAIL-018 and E-SAGE-054 (Ruling 55); the reorder question (`workflow-summary.md:84`), which is not yet in vendor-questions.md; then Task 10.
