# Hyperflow learnings — Couple Dudes Doing Biz

## 2026-11-06: audit of the evidence-package verification kit (L2 scope)

These lessons apply to any bash or awk checker that validates Markdown evidence tables.

- **Make a check fail before you trust its pass.** The first verify.sh passed 45 checks, but 6 of 16 negative controls showed false passes. Pair every check with a mutation fixture that proves it can fail (test-verify.sh).
- **Whole-line matching hides real content.** `grep -x` failed A-07 because the formula line started with a list bullet and ended with a full stop. Use substring matching (`grep -F`) unless the rule really is "the whole line".
- **Normalise text before matching:**
  - Lower-case status and type values first, or "Verified" and "Pricing" slip past.
  - Fold NBSP, narrow NBSP and tabs into plain spaces, or "not supported" slips past.
  - Strip CR once, at load time.
- **A check that crashes must not report PASS.** If the check passes when its offender file is empty, an awk or grep error also leaves that file empty and reads as PASS. Record the command's exit status, and add a GNU awk guard. Do not use `set -e`, because grep returns 1 on purpose.
- **Table extraction can drop rows silently.** If extraction stops at the first blank line, a stray blank line drops rows from every check. Count the ID lines in the whole file and compare with the rows extracted.
- **Format rules have a scope.** Domain-format checks written for research rows misfired on stakeholder-reported and inference rows that were added later. Scope each rule to the row types it was written for, and keep a test proving research rows are still caught.
- **Structural checks cannot see a claim drift away from its citation.** A matrix cell can keep citing a valid ID after that row is narrowed. When a row's claim changes, list every cell that cites it for re-review (TEST-PLAN G11).
- **Spot-checks catch what scripts cannot.** A 20% source re-fetch found 2 partly confirmed rows. One of them changed what the pilot can rely on (E-SAGE-023: quote CSV templates are not confirmed).
