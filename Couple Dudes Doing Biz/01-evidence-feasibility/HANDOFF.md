# Handoff: Couple Dudes Doing Biz, sub-project 1 (evidence and feasibility)

Last updated 2026-11-06. Read this first when you resume, whether in a new session or yourself.

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
| 9: verification | **In progress.** See Verification below. |
| 10: present to Timothy, promote files on his go | Not started |
| 11: CRM-free workflow summary (DEC-07) | **Not built.** Requirements are in the plan's Task 11. Checks W-* run once the file exists. |

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
  - **G4:** frozen-row baseline check (L-15). This is the highest priority before anyone edits the drafts again.
  - **G5:** gate presence check (P-06).
  - **G6:** summary consistent with the matrices (F-05).
  - **G1** (L-16), **G11** (claim drifts away from its citation; an `--impact` report), **G12** (C-11) and **G13**, which was resolved by Ruling 46.
  - Fixtures FX-14 and FX-15 activate once L-15 and P-06 exist.
  - The manual checklist (TEST-PLAN §6) has not been signed off.

## Open questions (they need Brad or a vendor; draft questions are in vendor-questions.md)

- What does "cloud version" mean: installed on a company machine or server, or hosted by a third party? It decides where any Sage-facing component must run (B-19).
- The exact release (2026.0 or 2026.1), and a Help > About check to confirm A-01.
- Does Quantum 2026 have CSV import templates for quotes, POs and customers (S-19)? Can quotes convert to sales orders? How is a wrong import reversed?
- Does Unishippers offer a test or demo account or a non-billable mode (U-22)? Can Brad's Unishippers credentials be used with ShipStation or ShipEngine (U-12)?
- Volumes are unknown, so all costs are list prices only.
- Which terms govern a Grok Bot seat (E-AI-051)?

## Next steps, in order

1. Read the **final totals** at the bottom of this file. Confirm 0 FAIL, and that test-verify.sh has 0 BAD.
2. Build **G4 (L-15)** before any further edits to the drafts.
3. Build Task 11 (`workflow-summary.md`), then re-run verify.sh so the W-* checks run.
4. Build G5, G6, G1 and G12. Sign off the manual checklist.
5. Task 10: present the drafts to Timothy. Promote them to this folder only on his explicit go.
6. Timothy sends the vendor and Brad questions himself. Log the answers as new ledger rows.

## Session notes

- **Usage limits.** Opus and Sonnet subagents each hit the 5-hour limit during this work; it resets at about 6am ET. A stopped agent keeps its work, so resume it rather than restart it.
- **The recoup-catalogs plugin's Stop hook** blocked every turn end. Timothy patched its prompt; the patch takes effect from the next session. If blocking returns after a plugin update, disable that plugin for this project.
- **Not a git repository.** The before-copies in `verification/` serve as the change record.

## Final totals (filled in at the end of the 2026-11-06 run)

_Pending: Ruling 51 scope fix and a full test-verify.sh run._
