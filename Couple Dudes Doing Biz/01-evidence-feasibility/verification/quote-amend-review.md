# Quote amendment review (read-only), 2026-11-06

Method: diff --strip-trailing-cr of quote-amend/*.before.md against drafts; word-level diff; column-aware comparison of Verdict and Priority; E-SAGE-044 compared with the before block in spotcheck-fixes.before.txt.
Note: before files are CRLF, drafts are LF in all 5 files. Line-ending only; content diffs below ignore it.

1. No remaining CSV-creates-quote/PO/customer claim: ADDRESSED (with residuals outside scope)
   - In the 5 files and E-SAGE-044, every quote, PO or customer CSV mention is conditional or "not confirmed in sources checked" (connectivity rows 4 and 12 and line 26, automation rows 4 and 7 and lines 24/34, findings-summary lines 11/32/48/68/94-95, poc-tests lines 17-33, vendor-questions S-19).
   - Residuals in the ledger, which was not in the amended set: E-SAGE-026 source cell still cites "Import_Export_Overview.htm (quotes template)" and its PoC says "create a quote through each path"; E-SAGE-051 still says the record chain "is a Sage quote that a person reviews (E-SAGE-044)", which reads as a choice. E-SAGE-051 is cited by the automation matrix row 7 and line 34. Recommend narrowing both.
2. Verdict and Priority identical: ADDRESSED
   - Column compare of connectivity Verdict and automation Priority: no differences. Counts of P1/P2/P3 and of each verdict string are equal before and after in all 5 files. Row and line counts are unchanged except poc-tests +2 and vendor-questions +1 (new step and new S-19).
3. Options (a)(b)(c) presented as options: ADDRESSED (minor gap)
   - "one of three untested options ... none chosen" in connectivity row 12, automation row 7 and line 24, findings-summary line 11 and 32, E-SAGE-044. Citations: (a) E-SAGE-023, E-SAGE-044; (b) E-SAGE-003; (c) E-SAGE-023, E-SAGE-026.
   - Gap: S-19 is cited in E-SAGE-044, findings-summary line 48 and POC-01 step 9, not in the matrix option lists. Automation row 7 says the record is "left open", but its recommended-approach text lists SAGE-SDK as an "alternative", which is mild.
4. POC-01: ADDRESSED
   - Step 2 checks for a quote template (and PO and customer). Quote CSV is built and imported only if step 2 finds one (lines 21, 27). Pass criteria: quote counted "if a quote template exists"; if none, "recorded and is not a fail". Fail criteria: only a missing sales-order template or failed sales-order import fails; "a missing quote template is recorded, not a fail".
   - Minor: step 4 still says "Check whether a quote can be converted to a sales order" unconditionally, but no quote exists unless the SDK or a template supplies one (PoC SAGE-SDK covers it).
5. S-19: ADDRESSED
   - Asks whether Quantum 2026 CSV import supports quotes, purchase orders and customers and where the template is documented; "Resolves: E-SAGE-023".
6. E-SAGE-044: ADDRESSED
   - Row has 15 cells (same as header and E-SAGE-043); type process, status hypothesis, "analyst inference", grade S4, date 2026-11-06, A-01. Corrected position: sales-order CSV import confirmed (E-SAGE-023); hold convention untested; quote only via SDK (E-SAGE-003) or a template if Sage confirms (S-19).
7. No change outside the quote topic: ADDRESSED
   - All hunks concern the draft record, quote, PO or customer templates, the S-19 addition, POC-01 renumbering to 9 steps, or the 7.2 rule 5 / priority prose where "quote" was reworded (automation lines 32/34, findings-summary lines 27/66). Automation row 7 Benefit text changed "quote step" to "draft-record step" (same topic).

Overstatement check on new text: no unsupported claims found.
- "Import is confirmed" rests on E-SAGE-023, S1 field table, but "person-run, not tested". Acceptable; the ledger row still says edition availability of the template is unconfirmed. Findings-summary line 68 wording "keys a sales-order CSV ... leaves the order unprinted" is described as untested.
- Wording "Recommended for PoC" for CSV now rests on sales-order import only; verdict string unchanged as required.

verify.sh: 45 PASS, 0 FAIL, 1 SKIP (W-*, workflow-summary.md not yet built, Task 11). Exit 0.
