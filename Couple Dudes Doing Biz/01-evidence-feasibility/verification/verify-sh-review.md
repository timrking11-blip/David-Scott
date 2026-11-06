# Review: verify.sh

Reviewed 2026-11-06. This is a read-only review: verify.sh and ../drafts were not modified.
Baseline run from verification/: `Totals: 45 PASS, 0 FAIL, 1 SKIP`, exit 0. A fresh copy of the drafts gave the same result before the controls were run.

## Rating: 7 / 10

The structure is sound and most checks do what they claim. The field indexes are right everywhere, and 10 of the 16 controls failed as they should. The other 6 found real false-PASS gaps:
- case sensitivity (L-04, L-05, A-05);
- a non-breaking space getting past the banned-phrase check (L-02);
- the DELTA exemption (L-12);
- the line-count method in P-03.

A tool error also reads as PASS. Several Step 1 checks in the plan are not implemented.

## Strengths

- **Field indexes are correct throughout.**
  - Ledger: the 15 fields sit at `$2`..`$16` with NF==17.
  - Connectivity matrix: Path is `$2`, Licensing `$5`, Verdict `$11`, NF==12.
  - Automation matrix: Human approval is `$7`, Recommended approach `$9`, NF==13.
  - Each was checked against the real header rows.
- **CR handling is right.** Every `.md` file is normalised once with `tr -d '\r'` into a temp copy, so the drafts are never touched.
- **A-07 now uses a substring match.** `grep -qF` handles the U+2212 minus byte for byte.
- **Some checks are stricter than the plan's version.**
  - L-02 removes only the allowed phrase before it tests the line. The plan drops any line that contains the allowed phrase.
  - P-04 reads labels from the Verdict column, not from any line that happens to contain the verdict words.
  - C-05 and C-06 anchor the allowed value at the start of the cell.
- **L-09's symmetry logic is correct.** `comm -13` on the pairs and the reversed pairs gives exactly the back-references that are missing.
- **Paths are quoted everywhere.** The OneDrive path, which contains spaces, works both as the default and as an argument. The temp directory is created with `mktemp -d` and removed by `trap` on EXIT. No `eval` is used, and file content never reaches a shell parser.
- **The output is consistent.** Each check prints one line, then up to 20 offending lines, then totals. The exit code is 1 on any FAIL.

## Findings (priority order)

### Critical

None. No check can report PASS for every possible input. Each control below that targets a rule's main case does FAIL.

### Important

1. **A tool error reads as PASS (all `check` calls, for example lines 94-146 and 175-223).** Each check sends awk or grep output to `$OFF` and passes when that file is empty. If awk exits with an error (syntax error, missing binary, mawk without `{n}` intervals), stdout is empty and the check prints PASS. Under mawk 1.3.3, `match(s,/E-[A-Z]+-[0-9]{3}/)` on line 126 never matches, so `pairs` is empty and L-08 and L-09 both pass with nothing checked.
   Fix:
   - Make the runner record the command's exit status, for example `run() { "$@" > "$OFF" || echo "CHECK ERROR: $1 exited $?" >> "$OFF"; }`.
   - Use it as `run awk -F'|' "$TRIM"'...' "$R"`.
   - Add a guard after line 25: `awk --version 2>/dev/null | grep -q GNU || { echo "FAIL SETUP — GNU awk required"; exit 2; }`.
   - Do not add `set -e`: grep's exit status of 1 is used on purpose throughout.

2. **Status and type checks are case-sensitive, which allows a false PASS (lines 110, 113, 139, 145, 358).**
   - Control NC2: writing `Pricing` defeats RC-4.
   - Control NC4: writing `Verified` defeats RC-5.
   - The same weakness applies to `$6 ~ /hypothesis/` in L-11, `$4 ~ /SuperGrok/` in L-13, and the S-01 pool.

   Fix: normalise once. On line 49, define `TRIM` as `function t(s){gsub(/^[ \t]+|[ \t]+$/,"",s);return s} function lc(s){return tolower(t(s))}`. Then change the checks:

   | Line | Check | Change to |
   |---|---|---|
   | 110 | L-04 | `lc($5) ~ /pricing/ && toupper(t($11)) != "S1"` |
   | 113 | L-05 | `lc($6) == "verified"` (replaces `$6 ~ /verified/ && $6 !~ /un/`) |
   | 358 | S-01 pool | `lc($6) == "verified"` (same change) |
   | 139 | L-11 | `lc($6) == "hypothesis"` |
   | 145 | L-13 | `lc($4) ~ /supergrok/` |

   Better still, add a vocabulary check: Status, Claim type and Strength must each be one of the plan's literal values. Then case drift fails loudly.

3. **A-05 is case-sensitive and accepts a negated approval point (line 220).**
   - Control NC15: `Finalization` with a capital F passes.
   - Control NC16: a Human approval cell that says "No human approval" passes, because it contains "human".

   Fix: `tolower($2) ~ /finali[sz]ation|issuance|supplier po/ && tolower($9) ~ /agentic/ && (tolower($7) !~ /human/ || tolower($7) ~ /(^|[^a-z])(no|none|without)[^a-z]+human|^ *none/)`.

   Spec §7.2 rule 3 is also stricter than the plan: "No agent may finalize Sage orders, issue shipments or send supplier POs". The owner should decide whether A-05 should fail whenever `$9` recommends agentic for these rows, whatever `$7` says.

4. **L-12 exempts DELTA rows from the A-01 tag (line 142).**
   - Control NC8: a D1 row with no A-01 passes once its Claim starts with `DELTA:`.
   - The plan's A-01 check (Task 1 Step 1) has no exemption. The plan also says delta rows "are 1 to 3 rows tagged `A-01`". The DELTA exemption belongs only to the "Applies to lacks US" check.

   Fix: `awk -F'|' "$TRIM"'t($3)=="D1" && $12 !~ /A-01/ {print ...}'`. Remove `&& $4 !~ /DELTA:/` and change the description to "every D1 row carries A-01".

5. **P-03 counts lines, not PoCs (line 277).**
   - Control NC10: deleting POC-03's "Fail criteria:" and mentioning the phrase in POC-01 still passes.

   Fix: replace lines 277-279 with a per-section check:
   `awk '/^## POC-0[1-7] — /{if(h && !fc) print h ": no Fail criteria"; h=$0; fc=0; next} /^Fail criteria/{fc=1} END{if(h && !fc) print h ": no Fail criteria"}' "$POC" > "$OFF"`.

6. **L-02 and W-05 miss a non-breaking space (lines 100-103, 351).**
   - Control NC6: `not<U+00A0>supported` passes.

   Fix: as the first statement of both awk programs, add `gsub(/\302\240|\342\200\257|\t/," ",$0)` (NBSP, narrow NBSP and tab). Then collapse runs of spaces with `gsub(/ +/," ",l)` before the tests.

7. **Several Step 1 checks in the plan are not implemented.** Run them on the ledger rows `$R`, filtered by `t($3)`.

   | Plan task | Rule not checked | Awk condition to add |
   |---|---|---|
   | Task 1 (D1) | Applies to names US (DELTA rows excepted) | `t($3)=="D1" && $9 !~ /US/ && $4 !~ /DELTA:/` |
   | Task 1 (D1) | A version is named, or the row says "version unspecified" | `t($3)=="D1" && $9 !~ /20[0-9][0-9]\|Pro\|Premium\|Quantum/ && tolower($13) !~ /version unspecified/` |
   | Task 2 (D2) | A franchise source is graded S3 or lower | `tolower($7 $13) ~ /franchise/ && $11 ~ /S1\|S2/` |
   | Task 2 (D2) | D2.Q5 rows say "comparison only" | `$15 ~ /D2\.Q5/ && tolower($4) !~ /comparison only/` |
   | Task 3 (D3) | At most 12 D3 rows | the count of `t($3)=="D3"` is at most 12 |
   | Task 4 (D4) | Vendor rows say consumer or API | the Task 4 condition, limited to `t($3)=="D4"` |
   | Task 4 (D4) | Each comparison vendor is covered | the vendor `grep -q` loop over the D4 rows |
   | Task 4 (MAIL) | Email claims are written as conditionals | `t($3)=="MAIL" && $4 !~ /^ *If (Microsoft 365\|M365\|Google Workspace)/` |

   (`\|` in the table means a literal `|` in the regex.)

8. **The ledger table can be cut short without any warning (line 83).** The extraction stops at the first blank line, so any row after a stray blank line is never checked by any L- check.
   - Control NC11: a blank line before the last row was caught only by chance. A-08 noticed that E-SHIP-037 had gone missing. If the dropped row had not been cited in a checked file, everything would have passed.

   Fix: after line 85, add a coverage check, for example
   `grep -cE '^\| E-[A-Z]+-[0-9]{3} \|' "$LEDGER"` must equal `wc -l < "$T/ledger.rows"`. Report it as L-00b, "every ID row in the file is inside the extracted table".

9. **S-01 header and sample.** The header is accurate about K but misleading about the total. See the S-01 sample count section below.

### Minor

10. **The script cannot tell a broken sample draw from a good one (lines 362-364).** `shuf ... 2>/dev/null` hides failures. If shuf is missing, S-01 still prints PASS with only the 2 fixed IDs.
    Fix: `shuf ... || { emit FAIL S-01 "shuf failed"; }`. Also check `[ "$(wc -l < "$T/sample")" -eq "$K" ]`.

11. **Setup has two safety gaps (lines 22-23).**
    - If `mktemp -d` fails, `T` is empty and later writes go to `/evidence-ledger.md` and the like.
      Fix: `T="$(mktemp -d)" || { echo "FAIL SETUP — mktemp failed"; exit 2; }`.
    - The trap covers EXIT only.
      Fix: `trap 'rm -rf "$T"' EXIT INT TERM`.

12. **`grep` treats an ID or label that starts with `-` as an option (lines 247, 284).** For example, a ledger cell `-f/etc/x` makes grep read patterns from that file. The input is file content and the risk is low.
    Fix: `grep -qF -- "$id" "$VEND"` and `grep -qF -- "$p" "$POC"`.

13. **`ID="$id"` as an awk operand runs escape processing on file content (line 379).**
    Fix: `ID="$id" awk ... 't($2)==ENVIRON["ID"]'`.

14. **IDs cited in poc-tests.md and vendor-questions.md are not cross-checked.** C-10, A-08, F-04 and W-04 do this for the other files.
    Fix: add `cited_missing "$POC"` as P-06 and `cited_missing "$VEND"` as V-03, guarded by `HAVE_LEDGER`.

15. **`cited_missing` matches IDs by prefix (line 53).** `E-SAGE-0071` is read as `E-SAGE-007`, and a two-digit ID is missed.
    Fix: `grep -oE 'E-[A-Z]+-[0-9]+' "$1" | csort -u | ccomm -23 - "$T/ids"`. Every malformed ID then reports as missing.

16. **Two kinds of check always print PASS (lines 294-295, 368-369).** P-05 and S-01 are manual items, and counting them as PASS inflates the total.
    Fix: print them as `INFO` (or `MANUAL`), with their own counter in the totals line.

17. **The ID F-00 is used twice (lines 75 and 301).**
    Fix: rename the presence check on line 75 to `X-00` (setup).

18. **The file the script points to does not exist (lines 11 and 389).** VERIFICATION-CRITERIA.md is not in verification/.
    Fix: create it, or point to the plan instead.

19. **The connectivity and automation matrix checks assume the table is the first thing in the file (lines 161 and 207).** Any later prose line with 2 or more pipes counts as a data row.
    Fix: extract the table the same way as the ledger. Start at `/^\| Path \|/` or `/^\| Task \|/` and stop at the first blank line.

20. **L-03 accepts impossible dates such as `2026-13-45` (line 107).**
    Fix: add a check that the month is between 01 and 12 and the day between 01 and 31.

21. **V-01's "ask" also matches "task" and "mask" (line 246).** This can cause a false FAIL, not a false PASS.
    Fix: `/(^|[^a-z])ask([^a-z]|$)|vendor|confirm with/`.

22. **Setup failure and check failure use the same exit code (line 18).** Both exit 1.
    Fix: exit 2 on setup failure.

23. **Maintainability.**
    - The banned-phrase logic is written twice (lines 100-103 and 351).
    - The "cited IDs" block appears 4 times.
    - The connectivity and automation awk preambles repeat `NR>2 && NF==12` (or 13) throughout.

    Fix:
    - Add `banned_phrases FILE...` and `cited_check ID FILE` helpers.
    - Store the table bounds and column count once per matrix, for example `CONN_NF=12`.
    - Add a short column map in a comment, as on line 160, for the ledger as well.

## S-01 sample count (question 2)

The fixed IDs are **added on top of the K drawn, then deduplicated**:
- line 366 appends `E-SAGE-007` and `E-AI-053`;
- line 367 runs `sort -u`.

Both fixed IDs are in the pool, since both are S1/verified, so `shuf` can also draw them. The printed total is therefore K + 2 minus any overlap, which means anywhere from 10 to 12 rows.
- In this review's run, 11 rows were printed: one fixed ID had also been drawn.
- In the run you saw, 10 rows were printed: both fixed IDs had been drawn among the 10.

The header text "10 drawn, plus fixed E-SAGE-007 and E-AI-053" is correct about K = 10. It is misleading about the total, because the "plus" is not always additive.

Fix (lines 359-368):
- Draw K from the pool with the fixed IDs taken out: `grep -vxF -e E-SAGE-007 -e E-AI-053 "$T/s1pool" | shuf -n "$K"`. The total is then always K + 2.
- Print the real count: `$(wc -l < "$T/sample.u") rows`.
- Mark the fixed rows in the table.

The pool also differs from the spec and the plan:

| Source | Pool | Rows | K |
|---|---|---|---|
| Spec §11.7 | "20% of S1 entries" | 77 | 16 |
| Plan Task 9 | every S1 row | 77 | 16 |
| Script (line 358) | S1 rows with status verified | 47 | 10 |

The project rule "snippet-only rows count as S4" (findings-summary.md) only accounts for 27 of the 30 hypothesis S1 rows. The script also drops 3 hypothesis S1 rows that are not snippet only: E-AI-051, E-SAGE-025 and E-SAGE-026.

The owner should decide which pool is correct. If the snippet-only rule is the reason, filter on that rule instead:
`$11 ~ /S1/ && tolower($0) !~ /snippet only/`.

## Robustness, portability, security (questions 3 and 4)

- **Quoting:** correct throughout. The path with spaces works both as the default and as an argument.
- **set -e / pipefail:** neither is set. That is appropriate, because the checks rely on grep's exit status of 1. The cost is finding 1: errors are silent. Pipelines such as `grep | grep | cut > "$OFF"` lose upstream errors either way.
- **Temp handling:** `mktemp -d` is safe, with a private directory and random name, and cleanup runs on EXIT. See finding 11 for the gaps. No leftover temp directories were found from this script.
- **Exit code:** 0 when clean, 1 on any FAIL. See finding 22 for the setup case.
- **Portability:**
  - The script needs GNU awk for `{n}` intervals. Git Bash ships gawk 5, which is fine.
  - It needs GNU coreutils for `shuf --random-source`, `sort -c` and `paste -sd`. These are present in Git Bash and on Linux, but not on macOS by default.
  - Process substitution `<(yes "$SEED")` needs bash, which the shebang gives.
  - Reproducibility with SEED holds only for the same coreutils version.
- **Security:** no `eval`, no unquoted expansion of file content, and no file content is run as code. The only residual risks are findings 12 and 13, both low.

## Negative-control results

Method:
- For each control, ../drafts was copied **once, at the start of the control**, into a fresh `mktemp -d` directory.
- Exactly one rule was broken with `sed -i -E` on the copy. NC2, NC4, NC8, NC14-NC16 needed two or three sed edits: one to break the rule and one to defeat the check or keep A-03 satisfied.
- `bash verify.sh <tmpdir>` was run from verification/, and the copy was deleted afterwards.
- ../drafts was never written to.
- The harness checked that each sed changed the file. The target lines were re-checked against the current drafts after the parallel edits started.

Baseline on a fresh copy: 45 PASS, 0 FAIL, 1 SKIP.

| # | Rule broken | Check | Result | Verdict |
|---|---|---|---|---|
| NC1 | RC-4: E-AI-021 pricing row moved S1 to S2, unlabelled | L-04 | FAIL | correct |
| NC2 | Same as NC1, plus Claim type written `Pricing` | L-04 | **PASS** | **false PASS** (finding 2) |
| NC3 | RC-5: "Needs login" added to Limitations of a verified row | L-05 | FAIL | correct |
| NC4 | Same as NC3, plus Status written `Verified` | L-05 | **PASS** | **false PASS** (finding 2) |
| NC5 | RC-2: "not supported" added to findings-summary.md | L-02 | FAIL | correct |
| NC6 | RC-2 with a non-breaking space: `not<U+00A0>supported` | L-02 | **PASS** | **false PASS** (finding 6) |
| NC7 | E-SAGE-001 (D1) has A-01 replaced by `none` | L-12 | FAIL | correct |
| NC8 | Same as NC7, plus Claim prefixed `DELTA:` | L-12 | **PASS** | **false PASS** (finding 4) |
| NC9 | POC-03's "Fail criteria:" line removed | P-03 | FAIL | correct |
| NC10 | Same as NC9, plus "Fail criteria" mentioned in POC-01 | P-03 | **PASS** | **false PASS** (finding 5) |
| NC11 | Blank line inserted before the last ledger row (E-SHIP-037) | L-* | PASS (A-08 FAIL by chance) | gap (finding 8) |
| NC12 | Partially-supported connectivity row set to Recommended for PoC | C-07, C-08 | FAIL, FAIL | correct |
| NC13 | E-AI-008 drops its back-reference to E-AI-007 | L-09 | FAIL | correct |
| NC14 | Finalization row: approach Agentic, approval "None" | A-05 | FAIL | correct |
| NC15 | Same as NC14, label capitalised `Finalization` | A-05 | **PASS** | **false PASS** (finding 3) |
| NC16 | Same as NC14, approval cell "No human approval" | A-05 | **PASS** | **false PASS** (finding 3) |

One harness mistake was found and corrected:
- The first NC3 and NC14 attempts had the field index off by one.
- The first NC3 attempt edited the wrong column, so that run did not test L-05.
- The first NC14 attempt also removed the E- IDs from the cells, so A-03 failed instead of A-05.
- Only the corrected runs are reported.

The harness script is in the session scratchpad; it is not in the project.
