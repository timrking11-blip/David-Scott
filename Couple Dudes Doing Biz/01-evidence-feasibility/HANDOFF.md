# Handoff: David Scott Company, sub-project 1 (evidence and feasibility)

Last updated 2026-11-06 (cloud session, after Task 11 and G1, G4, G5, G6, G12). Read this first when you resume, whether in a new session or yourself.

## What this is

Stage A of the modernization assessment for Brad's business (Sage 50, Unishippers, emailed POs). Stage A has three sub-projects:

1. **Evidence and feasibility.** This folder. Drafted, reviewed, and partly verified.
2. **Discovery kit and dashboard MVP.** Not started.
3. **Hosting, cost, pilot plan, and Brad's memo.** Not started.

Authority documents:

- Spec: [`../docs/specs/2026-11-04-evidence-feasibility-design.md`](../docs/specs/2026-11-04-evidence-feasibility-design.md). §15 lists the amendments DEC-06 to DEC-11.
- Plan: [`../docs/plans/2026-11-04-evidence-feasibility.md`](../docs/plans/2026-11-04-evidence-feasibility.md), with Tasks 1–11.
- Rulings: [`verification/controller-ledger.md`](verification/controller-ledger.md). Every judgment call made on Timothy's behalf is there (Rulings 1–51), each with the reason and the cost if wrong.

## Where things are

| Path | What it holds |
|---|---|
| `drafts/` | **Canonical** draft deliverables (Ruling 43): `evidence-ledger.md` (185+ rows), `connectivity-matrix.md`, `automation-feasibility-matrix.md`, `vendor-questions.md` (98 drafts, none sent), `poc-tests.md` (POC-01–07), `findings-summary.md`, `sources-*.md` |
| `verification/verify.sh` | Mechanical checker. Run `bash verify.sh` from that folder. `SEED=n` gives a reproducible spot-check sample. |
| `verification/test-verify.sh` | Regression suite: mutation cases that prove each check FAILs when its rule is broken. A full run takes about 20 minutes. `ONLY="NC1 FX-07"` runs a subset and `JOBS` sets parallelism. |
| `verification/research-rows.sha256` | Frozen-row baseline for check L-15 (G4): one sha256 per research row, 136 rows, with a history of rulings at the top. Never edit it by hand. |
| `verification/baseline-research-rows.sh` | Re-baselines after a ruling changes a research row: `bash baseline-research-rows.sh "Ruling NN"`. Commit it together with the ledger edit. |
| `verify.sh --impact E-...` | Lists every cell outside the ledger that cites a row (row and column), for re-review when its Claim changes (G11). `baseline-research-rows.sh` runs it automatically for changed rows. |
| `verification/manual-checklist-review-2026-11-06.md`, `spot-check-2026-11-06b.md` | Evidence for the TEST-PLAN §6 sign-off, and the second source spot-check |
| `verification/research-rows.lib.sh` | The one definition of "research row" and of the row hash, shared by verify.sh and the baseline script. |
| `verification/TEST-PLAN.md` | Test strategy, coverage map, open gaps G1–G13, fixtures FX-01–16. Section 2 holds the single definition of "clean". |
| `verification/spot-check-2026-11-06.md` | Source spot-check: 10 rows re-fetched. 8 confirmed, 2 partly confirmed; both have since been corrected. |
| `verification/*review*.md`, `*audit*.md` | Reviews: verify.sh (rated 7/10 before the fixes), the test plan, and the quote amendment |
| `verification/*.before.*`, `quote-amend/` | Before-copies of every edit made after review |
| Final deliverables (top of this folder) | **Not written yet.** They are promoted from `drafts/` only when Timothy explicitly says go. |

## Task status

| Task | Status |
|---|---|
| 1–4: research (Sage, shipping, e-commerce/CRM, AI and email) | Done and reviewed |
| 5: evidence ledger merge | Done and reviewed |
| 6: connectivity matrix | Done and reviewed. Amended for DEC-09 to DEC-11 and for the quote narrowing. |
| 7: automation matrix | Done and reviewed. Amended likewise. |
| 8: vendor questions, PoC tests, findings summary | Done and reviewed. 2 fix rounds, plus the live-system and cost gates (Rulings 38 and 39). |
| 9: verification | **Scripted part done** (0 FAIL, 0 BAD, every check has a fixture). Manual checklist reviewed, **awaiting Timothy's sign-off**: `verification/manual-checklist-review-2026-11-06.md`. |
| 10: present to Timothy, promote files on his go | Not started |
| 11: CRM-free workflow summary (DEC-07) | **Built** (`drafts/workflow-summary.md`, Ruling 53). W-01 to W-07 PASS. |

## Key decisions from Timothy (spec §3 and §15)

- **DEC-01:** split Stage A into three sub-projects.
- **DEC-02:** assume US Sage 50.
- **DEC-03:** read "GrokBot super" as SuperGrok. The competing reading, A-02b, is Grok Bot on the X Super plan. Both are covered.
- **DEC-04:** evidence-first research.
- **DEC-05:** spec approved.
- **DEC-06:** no CRM, by stakeholder preference.
- **DEC-07:** add the CRM-free workflow summary.
- **DEC-08:** WooCommerce is not an intake channel.
- **DEC-09:** Brad runs Sage 50 **Quantum Accounting 2026, "cloud version"**. This is *stakeholder-reported*; verify it in Sage's Help > About screen.
- **DEC-10:** Sage holds the product master for all products. The website carries only some of them.
- **DEC-11:** quotes arrive by email from hospitals and by phone from reps. Quotes are then built by hand in Sage.
- **DEC-12:** run Task 9 verification with a test kit. Timothy later chose to have the tests run here.

## What the evidence currently says (headline)

- **Connectivity.** Only Sage CSV import/export is *Recommended for PoC*. Writing tracking numbers back into Sage, marketplace connectors and direct carrier APIs are *Unresolved*. UI automation is *Fallback only*. Every other path is *Viable with conditions*.
- **Draft record.** **Sage has no draft sales-order status in the sources checked.** There are three untested options, and none has been chosen:
  - (a) a CSV-imported sales order held unprinted for approval. The import is confirmed; the hold convention is untested.
  - (b) a quote created via the SDK.
  - (c) a quote CSV template, but only if Sage confirms one exists (question S-19). The quote, PO and customer CSV templates are *not confirmed* (E-SAGE-023 was narrowed on 2026-11-06).
- **Automation priorities.**
  - P1: Sage draft record via CSV, email intake, and PO extraction. The last two are P1 by declared exception (Ruling 30).
  - P3: tracking write-back.
  - No agent may finalize orders, issue shipments or send supplier POs.
  - The minimal pilot is SAGE-CSV with manual intake.
- **Gates.** No PoC uses Brad's live accounts, and every chargeable step is gated (Rulings 38 and 39).

## Verification (Task 9)

- **verify.sh.** Before the Ruling 51 scope fix: 50 PASS, 5 FAIL, 1 SKIP, 2 INFO. All 5 FAILs were on stakeholder and inference rows, which the domain-format checks were never meant to cover (Ruling 51). **The final post-fix totals are recorded at the bottom of this file.**
- **Spot-check.** 8 of 10 sources confirmed. The 2 partials (E-AI-053, E-SAGE-023) are corrected. No source contradicted its claim, and no price had changed.
- **Reviews.**
  - verify.sh: all findings applied.
  - Test plan: revised.
  - Quote amendment: 7 of 7 addressed, plus a round-2 cleanup.
- **Still open before the work counts as "clean"** (TEST-PLAN §2):
  - ~~G4~~ **built** (Ruling 52): check L-15. Any edit to a research row now FAILs until it is re-baselined under a ruling.
  - ~~G5~~ **built** (Ruling 54): check P-06.
  - ~~G6~~ **built**: check F-05.
  - ~~G1~~ (L-16), ~~G12~~ (C-11), ~~G2~~ (F-06), ~~G7~~ (A-09) and ~~G11~~ (`verify.sh --impact`) **built**; G3 and G9 were already covered; G13 was resolved by Ruling 46. **No TEST-PLAN gap is open.**
  - Fixtures FX-14 and FX-15 activate once L-15 and P-06 exist.
  - The manual checklist (TEST-PLAN §6) is **reviewed but not signed off**. Four items pass. Item 1 passes with one follow-up (E-AI-028's context qualifier). Items 2 and 3 need Timothy's call. See `verification/manual-checklist-review-2026-11-06.md`.

## Open questions (they need Brad or a vendor; draft questions are in vendor-questions.md)

- What does "cloud version" mean: installed on a company machine or server, or hosted by a third party? It decides where any Sage-facing component must run (B-19).
- The exact release (2026.0 or 2026.1), and a Help > About check to confirm A-01.
- Does Quantum 2026 have CSV import templates for quotes, POs and customers (S-19)? Can quotes convert to sales orders? How is a wrong import reversed?
- Does Unishippers offer a test or demo account or a non-billable mode (U-22)? Can Brad's Unishippers credentials be used with ShipStation or ShipEngine (U-12)?
- Volumes are unknown, so all costs are list prices only.
- Which terms govern a Grok Bot seat (E-AI-051)?

## Next steps, in order

1. ~~Read the final totals and confirm 0 FAIL, 0 BAD.~~ Done 2026-11-06 (see the bottom of this file).
2. ~~Build G4 (L-15).~~ Done 2026-11-06 (Ruling 52). From now on, a research-row edit needs a ruling and `baseline-research-rows.sh` in the same commit.
3. ~~Build Task 11.~~ Done 2026-11-06 (Ruling 53).
4. ~~Build G5, G6, G1 and G12.~~ Done 2026-11-06 (Rulings 54 and 55). **Timothy:** sign off the manual checklist, or decide items 2 and 3 in `verification/manual-checklist-review-2026-11-06.md`.
5. Task 10: present the drafts to Timothy. Promote them to this folder only on his explicit go.
6. Timothy sends the vendor and Brad questions himself. Log the answers as new ledger rows.

## Session notes

- **Usage limits.** Opus and Sonnet subagents each hit the 5-hour limit during this work; it resets at about 6am ET. A stopped agent keeps its work, so resume it rather than restart it.
- **The recoup-catalogs plugin's Stop hook** blocked every turn end. Timothy patched its prompt; the patch takes effect from the next session. If blocking returns after a plugin update, disable that plugin for this project.
- **Now in git** (private repo `David-Scott`, path `Couple Dudes Doing Biz/`), worked from a cloud session since 2026-11-06. Git history is the change record from here; the older before-copies in `verification/` stay as they are. Pull before working and push after, so the local copy and the cloud copy cannot drift.
- **GNU awk is required.** A fresh Linux container may lack it: `apt-get install -y gawk`.

## Final totals (filled in at the end of the 2026-11-06 run)

| Run | Where | verify.sh | test-verify.sh (full, single run) |
|---|---|---|---|
| After the Ruling 51 scope fix | Timothy's PC, and again in the cloud session | 55 PASS, 0 FAIL, 1 SKIP, 2 INFO | 82 OK, 0 BAD, 2 SKIP (FX-14, FX-15) |
| After G4 (Ruling 52) | Cloud session | 56 PASS, 0 FAIL, 1 SKIP, 2 INFO | 86 OK, 0 BAD, 1 SKIP (FX-15 waits for P-06) |
| After Task 11, G1, G5, G6, G12 (Rulings 53 to 55) | Cloud session | 67 PASS, 0 FAIL, 0 SKIP, 3 INFO | 109 OK, 0 BAD, 0 SKIP |
| After G2, G7, G11 (Ruling 56): all TEST-PLAN gaps closed | Cloud session | 69 PASS, 0 FAIL, 0 SKIP, 3 INFO | 114 OK, 0 BAD, 0 SKIP |

Since Task 11, verify.sh has no SKIP. The INFO lines are L-16sr (three stakeholder rows with no Validation needed entry, Ruling 55), the P-05 manual-review list and the S-01 spot-check sample. Reproduce the sample with `SEED=handoff-2026-11-06 bash verify.sh`.
