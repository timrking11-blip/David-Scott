#!/usr/bin/env bash
# test-verify.sh - regression suite for verify.sh (TEST-PLAN.md gap G8).
#
# Usage:  bash test-verify.sh          (no arguments; works in Git Bash)
# Env:    JOBS=<n>   parallel verify.sh runs (default 6; each run takes about 20 s in Git Bash)
#         KEEP=1     keep the per-case temp dirs and outputs (for debugging)
#         ONLY="NC1 FX-07"   run just these cases (plus BASELINE)
#
# How it works
#   1. The drafts (../drafts, read-only) are copied once into a snapshot, so a concurrent edit by someone
#      else cannot change the baseline halfway through the run.
#   2. BASELINE: verify.sh runs on an untouched copy. It must exit 0, or exit 1 with only the FAILs listed in
#      KNOWN_DRAFT_FAILS below (real defects in the drafts, not in the script). It must print no "CHECK ERROR".
#   3. Every mutation case copies the snapshot into a fresh mktemp dir, applies its edits (sed, or an awk cell
#      edit for table cells), asserts each edit changed the file, runs verify.sh on the copy and asserts the
#      named check ID FAILs. A check that already FAILs in the baseline counts only if its FAIL block (count and
#      offender lines) differs from the baseline block, so a known draft issue can never mask a mutation.
#   4. The temp dir is deleted. Target rows are looked up in the drafts at run time, not hard-coded.
#
# Output: one line per case, "OK <case> — <check> FAILed as expected" or "BAD <case> — <check> did not FAIL",
# then totals. Exit 1 if any case is BAD, else 0.
#
# Fixture map (TEST-PLAN.md section 5): FX-01..FX-05, FX-07..FX-13, FX-16 are cases below under those names.
#   FX-06 is the same mutation as NC13 (delete one side of a Conflicts-with pair), so it is run once, as NC13.
#   FX-14 tests L-15 (G4), with L15-RETYPE, L15-NEW and L15-SR-EXEMPT. FX-15 (needs P-06) is reported SKIP: not built yet.

V="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 2
D="$V/../drafts"
[ -d "$D" ] && [ -f "$V/verify.sh" ] || { echo "BAD SETUP — need $V/verify.sh and $D"; exit 2; }
JOBS="${JOBS:-6}"

# FAILs that the current drafts are known to produce. Empty since Controller Ruling 51: the five former draft FAILs
# (L-19 L-20 L-22 L-23 L-26) came from stakeholder-reported (SR) and analyst-inference rows, which those checks now
# exempt, so the untouched drafts must produce no FAIL at all.
KNOWN_DRAFT_FAILS=""

SNAP="$(mktemp -d)" || exit 2
RES="$(mktemp -d)" || exit 2
SHIM="$(mktemp -d)" || exit 2
cleanup() { [ -n "${KEEP:-}" ] || rm -rf "$SNAP" "$RES" "$SHIM"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
cp "$D"/*.md "$SNAP"/ || { echo "BAD SETUP — cannot snapshot $D"; exit 2; }

REAL_AWK="$(command -v awk)"
ST='function t(s){gsub(/^[ \t]+|[ \t]+$/,"",s);return s}
function lc(s){return tolower(t(s))}
function uc(s){return toupper(t(s))}
'

# ---------------------------------------------------------------- edit helpers (operate on $W)
SETUP_MSG=""
fail_setup() { SETUP_MSG="$*"; return 1; }
changed() { # file -> 0 when $W/file differs from the saved pre-edit copy
  cmp -s "$W/.pre" "$W/$1" && { fail_setup "edit did not change $1"; return 1; }
  return 0
}
sedi() { # file sed-args... : sed -i on $W/file, and assert the file changed
  local f="$1"; shift
  cp "$W/$f" "$W/.pre" || return 1
  sed -i "$@" "$W/$f" || { fail_setup "sed failed on $f: $*"; return 1; }
  changed "$f"
}
cellmod() { # file key col mode value [value2] : edit one table cell in the row whose trimmed 2nd field == key
  local f="$1" key="$2" col="$3" mode="$4" val="$5" val2="${6:-}"
  cp "$W/$f" "$W/.pre" || return 1
  CK="$key" CV="$val" CV2="$val2" "$REAL_AWK" -F'|' -v OFS='|' -v C="$col" -v M="$mode" "$ST"'
    t($2)==ENVIRON["CK"] && !done {
      done=1
      if (M=="set")          $C=" " ENVIRON["CV"] " "
      else if (M=="append")  $C=" " t($C) ENVIRON["CV"] " "
      else if (M=="prepend") $C=" " ENVIRON["CV"] t($C) " "
      else if (M=="sub")     { x=$C; sub(ENVIRON["CV"], ENVIRON["CV2"], x); $C=x }
    }
    {print}
    END{ if (!done) exit 3 }' "$W/$f" > "$W/.new" || { fail_setup "no row '$key' in $f"; return 1; }
  mv "$W/.new" "$W/$f" || return 1
  changed "$f"
}
pick() { # file awk-condition -> trimmed 2nd field of the first matching table row (empty if none)
  "$REAL_AWK" -F'|' "$ST"'NF>5 && t($2) !~ /^(ID|Path|Task|---.*)$/ && ('"$2"') {print t($2); exit}' "$W/$1"
}
need() { [ -n "$2" ] || { fail_setup "no row found in the drafts for: $1"; return 1; }; }
sed_lit() { printf '%s' "$1" | sed 's/[][\.*^$/#]/\\&/g'; }   # escape a literal for a BRE with # as delimiter
LROW='NF==17 && t($2) ~ /^E-/ && '

# ---------------------------------------------------------------- cases
CASES=()
add() { CASES+=("$1"); }

# Run once, in the baseline job: no edits.
add BASELINE;  case_BASELINE() { MODE=baseline; EXPECT=""; }

# --- the 16 negative controls from verify-sh-review.md
add NC1; case_NC1() { # RC-4: pricing row moved S1 -> S2, unlabelled
  local id; id=$(pick evidence-ledger.md "${LROW}"'lc($5)=="pricing" && uc($11)=="S1" && lc($4) !~ /quoted, unverified|estimate/'); need "S1 pricing row without a label" "$id" || return 1
  cellmod evidence-ledger.md "$id" 11 set S2 || return 1; EXPECT="L-04"; }
add NC2; case_NC2() { # same, plus Claim type written 'Pricing' (case drift)
  local id; id=$(pick evidence-ledger.md "${LROW}"'lc($5)=="pricing" && uc($11)=="S1" && lc($4) !~ /quoted, unverified|estimate/'); need "S1 pricing row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 11 set S2 && cellmod evidence-ledger.md "$id" 5 set Pricing || return 1; EXPECT="L-04"; }
add NC3; case_NC3() { # RC-5: 'Needs login' added to Limitations of a verified row
  local id; id=$(pick evidence-ledger.md "${LROW}"'lc($6)=="verified" && lc($13) !~ /registration|sign-in|login/'); need "verified row without login wording" "$id" || return 1
  cellmod evidence-ledger.md "$id" 13 append " Needs login." || return 1; EXPECT="L-05"; }
add NC4; case_NC4() { # same, plus Status written 'Verified'
  local id; id=$(pick evidence-ledger.md "${LROW}"'lc($6)=="verified" && lc($13) !~ /registration|sign-in|login/'); need "verified row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 13 append " Needs login." && cellmod evidence-ledger.md "$id" 6 set Verified || return 1; EXPECT="L-05"; }
add NC5; case_NC5() { # RC-2: 'not supported' added to findings-summary.md
  sedi findings-summary.md '$ a\The CSV import path is not supported.' || return 1; EXPECT="L-02"; }
add NC6; case_NC6() { # RC-2 with a non-breaking space
  sedi findings-summary.md "\$ a\\The CSV import path is not$(printf '\xc2\xa0')supported." || return 1; EXPECT="L-02"; }
add NC7; case_NC7() { # D1 row loses A-01
  local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D1" && $12 ~ /A-01/ && lc($4) !~ /delta:/'); need "D1 row with A-01" "$id" || return 1
  cellmod evidence-ledger.md "$id" 12 set none || return 1; EXPECT="L-12"; }
add NC8; case_NC8() { # same, plus Claim prefixed DELTA: (the exemption that was removed)
  local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D1" && $12 ~ /A-01/ && lc($4) !~ /delta:/'); need "D1 row with A-01" "$id" || return 1
  cellmod evidence-ledger.md "$id" 12 set none && cellmod evidence-ledger.md "$id" 4 prepend "DELTA: " || return 1; EXPECT="L-12"; }
add NC9; case_NC9() { # POC-03 loses its Fail criteria line
  sedi poc-tests.md '/^## POC-03 — /,/^## POC-04 — /{/^Fail criteria/d}' || return 1; EXPECT="P-03"; }
add NC10; case_NC10() { # same, plus 'Fail criteria' mentioned elsewhere (POC-01) so a line count still matches
  sedi poc-tests.md '/^## POC-03 — /,/^## POC-04 — /{/^Fail criteria/d}' && sedi poc-tests.md '/^## POC-01 — /a\Fail criteria are listed at the end of this section.' || return 1; EXPECT="P-03"; }
add NC11; case_NC11() { # blank line before the last ledger row
  local n; n=$("$REAL_AWK" '/^\| E-[A-Z]+-[0-9]+ \|/{n=NR} END{print n}' "$W/evidence-ledger.md"); need "last ledger row" "$n" || return 1
  sedi evidence-ledger.md "${n}{x;p;x;}" || return 1; EXPECT="L-00b"; }
add NC12; case_NC12() { # Partially-supported connectivity row set to Recommended for PoC
  local k; k=$(pick connectivity-matrix.md '$11 !~ /Recommended for PoC/ && $2 !~ /UI automation/'); need "connectivity row" "$k" || return 1
  cellmod connectivity-matrix.md "$k" 3 set "Partially supported [E-SAGE-023]" && cellmod connectivity-matrix.md "$k" 11 set "Recommended for PoC" || return 1; EXPECT="C-07 C-08"; }
add NC13; case_NC13() { # E-xx drops its back-reference (also FX-06)
  local id; id=$(pick evidence-ledger.md "${LROW}"'$16 ~ /^ *E-[A-Z]+-[0-9]{3} *$/'); need "row with exactly one conflict" "$id" || return 1
  cellmod evidence-ledger.md "$id" 16 set none || return 1; EXPECT="L-09"; }
agentic_row() { pick automation-feasibility-matrix.md 'tolower($2) ~ /finali[sz]ation/'; }
add NC14; case_NC14() { # finalization row: approach Agentic, approval None
  local k; k=$(agentic_row); need "finalization row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 9 set "Agentic orchestration of the whole step [E-SAGE-043]" && cellmod automation-feasibility-matrix.md "$k" 7 set "None [E-SAGE-043]" || return 1; EXPECT="A-05"; }
add NC15; case_NC15() { # same, label capitalised 'Finalization'
  local k; k=$(agentic_row); need "finalization row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 9 set "Agentic orchestration of the whole step [E-SAGE-043]" && cellmod automation-feasibility-matrix.md "$k" 7 set "None [E-SAGE-043]" \
    && cellmod automation-feasibility-matrix.md "$k" 2 sub 'finalization' 'Finalization' || return 1; EXPECT="A-05"; }
add NC16; case_NC16() { # same as NC14, approval cell 'No human approval'
  local k; k=$(agentic_row); need "finalization row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 9 set "Agentic orchestration of the whole step [E-SAGE-043]" && cellmod automation-feasibility-matrix.md "$k" 7 set "No human approval [E-SAGE-043]" || return 1; EXPECT="A-05"; }
add NC14b; case_NC14b() { # Ruling 47: approval cell untouched, approach agentic -> still FAIL
  local k; k=$(agentic_row); need "finalization row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 9 set "Agentic orchestration of the whole step [E-SAGE-043]" || return 1; EXPECT="A-05"; }
add NC14c; case_NC14c() { # same rule for issuance and supplier-PO rows
  local k j; k=$(pick automation-feasibility-matrix.md 'tolower($2) ~ /issuance/'); j=$(pick automation-feasibility-matrix.md 'tolower($2) ~ /supplier po/'); need "issuance row" "$k" || return 1; need "supplier PO row" "$j" || return 1
  cellmod automation-feasibility-matrix.md "$k" 9 set "Agentic orchestration [E-SHIP-037]" && cellmod automation-feasibility-matrix.md "$j" 9 set "AGENTIC orchestration [E-SAGE-052]" || return 1; EXPECT="A-05"; }

# --- TEST-PLAN.md section 5 fixtures
add FX-01; case_FX-01() { sedi automation-feasibility-matrix.md '/Inventory position = on hand/ s/−/-/g' || return 1; EXPECT="A-07"; }
add FX-02; case_FX-02() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1
  cellmod connectivity-matrix.md "$k" 6 append " not supported" || return 1; EXPECT="L-02"; }
add FX-03; case_FX-03() { local id; id=$(pick evidence-ledger.md "${LROW}1"); need "ledger row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 10 set "11/06/2026" || return 1; EXPECT="L-03"; }
add FX-03b; case_FX-03b() { local id; id=$(pick evidence-ledger.md "${LROW}1"); need "ledger row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 10 set "2026-13-45" || return 1; EXPECT="L-03"; }
add FX-03c; case_FX-03c() { local id; id=$(pick evidence-ledger.md "${LROW}1"); need "ledger row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 10 set "2026-02-30" || return 1; EXPECT="L-03"; }
add FX-04; case_FX-04() { # non-S1 pricing row loses its 'quoted, unverified' / 'estimate' label
  local id; id=$(pick evidence-ledger.md "${LROW}"'lc($5)=="pricing" && uc($11)!="S1" && lc($4) ~ /quoted, unverified|estimate/')
  if [ -n "$id" ]; then
    cellmod evidence-ledger.md "$id" 4 sub '[Qq]uoted, unverified|[Ee]stimate[sd]?' 'listed' || return 1
  else
    id=$(pick evidence-ledger.md "${LROW}"'lc($5)=="pricing" && uc($11)=="S1"'); need "pricing row" "$id" || return 1
    cellmod evidence-ledger.md "$id" 11 set S3 && cellmod evidence-ledger.md "$id" 4 sub '[Qq]uoted, unverified|[Ee]stimate[sd]?' 'listed' || return 1
  fi
  EXPECT="L-04"; }
add FX-05; case_FX-05() { # swap two adjacent ledger rows
  local a b; a=$("$REAL_AWK" '/^\| E-[A-Z]+-[0-9]+ \|/{print NR; exit}' "$W/evidence-ledger.md"); b=$((a + 1)); need "first ledger row" "$a" || return 1
  sedi evidence-ledger.md "${a}{h;d};${b}{G}" || return 1; EXPECT="L-07"; }
add FX-07; case_FX-07() { # CSV row: Supported -> Partially supported, verdict stays Recommended for PoC
  cellmod connectivity-matrix.md "Sage: CSV import/export" 3 set "Partially supported [E-SAGE-023]" || return 1
  cellmod connectivity-matrix.md "Sage: CSV import/export" 11 set "Recommended for PoC" || true   # may already be Recommended
  EXPECT="C-07|C-08"; }
add FX-08; case_FX-08() { cellmod connectivity-matrix.md "Sage: UI automation (last resort)" 11 set "Viable with conditions" || return 1; EXPECT="C-09"; }
add FX-09; case_FX-09() { local k; k=$(pick automation-feasibility-matrix.md '1'); need "automation row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 4 append " [E-SAGE-999]" || return 1; EXPECT="A-08"; }
add FX-10; case_FX-10() { local k; k=$(pick automation-feasibility-matrix.md '$2 ~ /Inventory/'); need "Inventory row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 7 sub '[Hh]uman authorizes' 'person decides' || return 1; EXPECT="A-06"; }
add FX-11; case_FX-11() { sedi poc-tests.md 's/^## POC-03 — SAGE-ODBC/## POC-03 — SAGE-READ/' || return 1; EXPECT="P-02"; }
add FX-12; case_FX-12() { sedi findings-summary.md 's/confirmed by stakeholder report 2026-11-06 (E-SAGE-053)/CONFIRMED/g' || return 1; EXPECT="F-02 F-03"; }
add FX-13; case_FX-13() { # remove a ledger ID that V-01 requires from vendor-questions.md
  local id c; for c in E-SAGE-007 $("$REAL_AWK" -F'|' "$ST"'NF==17 && lc($14) ~ /(^|[^a-z])ask([^a-z]|$)|vendor|confirm with/ {print t($2)}' "$W/evidence-ledger.md"); do
    "$REAL_AWK" -F'|' "$ST"'NF==17 && t($2)=="'"$c"'" && lc($14) ~ /(^|[^a-z])ask([^a-z]|$)|vendor|confirm with/ {f=1} END{exit !f}' "$W/evidence-ledger.md" && grep -qF -- "$c" "$W/vendor-questions.md" && { id="$c"; break; }
  done; need "ledger row named in vendor-questions.md" "$id" || return 1
  sedi vendor-questions.md "s/$id//g" || return 1; EXPECT="V-01"; }
RROW="${LROW}"'lc($8) !~ /^(stakeholder|analyst inference)$/'   # research row (research-rows.lib.sh, Ruling 51)
add FX-14; case_FX-14() { # G4: change one word in a research row's Claim
  local id; id=$(pick evidence-ledger.md "$RROW"); need "research row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 4 sub '[A-Za-z]+' 'Altered' || return 1; EXPECT="L-15"; }
add L15-RETYPE; case_L15-RETYPE() { # G4: a research row retyped as stakeholder escapes the freeze and Ruling 51 checks
  local id; id=$(pick evidence-ledger.md "$RROW"); need "research row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 8 set "stakeholder" || return 1; EXPECT="L-15"; }
add L15-NEW; case_L15-NEW() { # G4: a new research row with no baseline (copy of the last research row under a fresh ID)
  local n; n=$("$REAL_AWK" -F'|' "$ST"'NF==17 && t($2) ~ /^E-/ && lc($8) !~ /^(stakeholder|analyst inference)$/ {n=NR} END{print n}' "$W/evidence-ledger.md"); need "last research row" "$n" || return 1
  sedi evidence-ledger.md "${n}{p;s/| *E-[A-Z]*-[0-9]* *|/| E-ZZZ-999 |/}" || return 1; EXPECT="L-15"; }
add L15-SR-EXEMPT; case_L15-SR-EXEMPT() { # G4: editing a stakeholder row is not a frozen-row change
  local id; id=$(pick evidence-ledger.md "${LROW}"'lc($8)=="stakeholder"'); need "stakeholder row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 13 append " Reconfirm with Brad." || return 1; MODE=nofail; EXPECT="L-15"; }
add FX-15; case_FX-15() { MODE=skip; EXPECT="P-06 (live-system and cost gates) is not built yet"; }
add FX-16; case_FX-16() { # clean run with CRLF line endings must look exactly like the baseline
  local f; for f in "$W"/*.md; do cp "$f" "$W/.pre"; sed -i 's/$/\r/' "$f"; cmp -s "$W/.pre" "$f" && { fail_setup "CRLF edit did not change $f"; return 1; }; done
  MODE=same; EXPECT=""; }

# --- further mutations, one per check that had no fixture
add L01; case_L01() { local id; id=$(pick evidence-ledger.md "${LROW}1"); need "ledger row" "$id" || return 1
  cp "$W/evidence-ledger.md" "$W/.pre"; "$REAL_AWK" -F'|' -v OFS='|' -v K="$id" "$ST"'t($2)==K && !d {d=1; $16=$17; NF=16} {print}' "$W/evidence-ledger.md" > "$W/.new" && mv "$W/.new" "$W/evidence-ledger.md"; changed evidence-ledger.md || return 1; EXPECT="L-01"; }
add L06; case_L06() { local n; n=$("$REAL_AWK" '/^\| E-[A-Z]+-[0-9]+ \|/{print NR; exit}' "$W/evidence-ledger.md"); need "first ledger row" "$n" || return 1
  sedi evidence-ledger.md "${n}p" || return 1; EXPECT="L-06"; }
add L08; case_L08() { local id; id=$(pick evidence-ledger.md "${LROW}1"); need "ledger row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 16 set "E-SAGE-998" || return 1; EXPECT="L-08"; }
add L10; case_L10() { local id; id=$(pick evidence-ledger.md "${LROW}"'uc($11)=="S1"'); need "S1 row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 7 set "Sage help page" || return 1; EXPECT="L-10"; }
add L11; case_L11() { local id; id=$(pick evidence-ledger.md "${LROW}"'lc($6)=="hypothesis" && tolower($0) !~ /snippet only/'); need "hypothesis row without snippet-only wording" "$id" || return 1
  cellmod evidence-ledger.md "$id" 13 set "Based on a search extract" || return 1; EXPECT="L-11"; }
add L13; case_L13() { local id; id=$(pick evidence-ledger.md "${LROW}"'lc($4) ~ /supergrok/ && $12 ~ /A-02/'); need "SuperGrok row with A-02" "$id" || return 1
  cellmod evidence-ledger.md "$id" 12 set "none" || return 1; EXPECT="L-13"; }
add L14; case_L14() { sedi evidence-ledger.md 's/MAIL\.Q2//g' || return 1; EXPECT="L-14"; }
add L18a; case_L18a() { local id; id=$(pick evidence-ledger.md "${LROW}"'lc($6)=="verified"'); need "verified row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 6 set "verifed" || return 1; EXPECT="L-18"; }
add L18b; case_L18b() { local id; id=$(pick evidence-ledger.md "${LROW}"'uc($11)=="S1"'); need "S1 row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 11 set "S5" && cellmod evidence-ledger.md "$id" 5 set "price" || return 1; EXPECT="L-18"; }
add L19; case_L19() { local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D1" && $9 ~ /US/ && lc($4) !~ /delta:/'); need "D1 row naming US" "$id" || return 1
  cellmod evidence-ledger.md "$id" 9 set "Canada 2026" || return 1; EXPECT="L-19"; }
add L20; case_L20() { local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D1"'); need "D1 row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 9 set "US" && cellmod evidence-ledger.md "$id" 13 set "Plain limitation." || return 1; EXPECT="L-20"; }
add L21; case_L21() { local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D2" && uc($11)=="S1"'); need "D2 S1 row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 13 append " Local franchise page." || return 1; EXPECT="L-21"; }
add L22; case_L22() { local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D2" && $15 ~ /D2\.Q5/ && lc($4) ~ /comparison only/'); need "D2.Q5 comparison-only row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 4 sub '[Cc]omparison only' 'Competitor' || return 1; EXPECT="L-22"; }
add L23; case_L23() { # Ruling 51: only research D3 rows count, so move enough research D2 rows to D3 to reach 13
  local id n; n=$("$REAL_AWK" -F'|' "$ST"'NF==17 && t($3)=="D3" && lc($8) !~ /^(stakeholder|analyst inference)$/ {c++} END{print 13-c}' "$W/evidence-ledger.md")
  while [ "$n" -gt 0 ]; do
    id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D2" && lc($8) !~ /^(stakeholder|analyst inference)$/'); need "research D2 row" "$id" || return 1
    cellmod evidence-ledger.md "$id" 3 set "D3" || return 1; n=$((n - 1))
  done; EXPECT="L-23"; }
add L24; case_L24() { local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="D4" && $4 ~ /xAI|Grok|Anthropic|Claude|OpenAI/ && lc($9) ~ /consumer|api/'); need "D4 vendor row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 9 set "Global" || return 1; EXPECT="L-24"; }
add L25; case_L25() { sedi evidence-ledger.md 's/Textract/AWS OCR/g' || return 1; EXPECT="L-25"; }
add L26; case_L26() { local id; id=$(pick evidence-ledger.md "${LROW}"'t($3)=="MAIL" && t($4) ~ /^If /'); need "MAIL conditional row" "$id" || return 1
  cellmod evidence-ledger.md "$id" 4 sub '^ *If ' 'Maybe ' || return 1; EXPECT="L-26"; }
add SR-EXEMPT; case_SR-EXEMPT() { # Ruling 51: a stakeholder D1 row with no US and no version must not trip L-19 or L-20
  cellmod evidence-ledger.md "E-SAGE-054" 9 set "Brad's business" || return 1; MODE=nofail; EXPECT="L-19 L-20"; }
add RESEARCH-STILL-CAUGHT; case_RESEARCH-STILL-CAUGHT() { # a vendor docs/terms D1 row that loses US still FAILs L-19
  local id; id=$(pick evidence-ledger.md "${LROW}"'t($2)=="E-SAGE-001" && t($3)=="D1" && lc($8)=="vendor docs/terms" && $9 ~ /US/ && lc($4) !~ /delta:/'); need "E-SAGE-001 as a vendor docs/terms D1 row naming US" "$id" || return 1
  cellmod evidence-ledger.md "$id" 9 sub 'US ?' '' || return 1; EXPECT="L-19"; }
add C01; case_C01() { local n; n=$("$REAL_AWK" 'NR>2 && /^\|/ {print NR; exit}' "$W/connectivity-matrix.md"); sedi connectivity-matrix.md "${n}d" || return 1; EXPECT="C-01 C-03"; }
add C02; case_C02() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1
  cp "$W/connectivity-matrix.md" "$W/.pre"; "$REAL_AWK" -F'|' -v OFS='|' -v K="$k" "$ST"'t($2)==K && !d {d=1; $11=$12; NF=11} {print}' "$W/connectivity-matrix.md" > "$W/.new" && mv "$W/.new" "$W/connectivity-matrix.md"; changed connectivity-matrix.md || return 1; EXPECT="C-02"; }
add C03; case_C03() { sedi connectivity-matrix.md 's/Sage: manual entry (baseline)/Sage: manual typing (baseline)/' || return 1; EXPECT="C-03"; }
add C04; case_C04() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1
  cellmod connectivity-matrix.md "$k" 6 set "TBD" || return 1; EXPECT="C-04"; }
add C05; case_C05() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1
  cellmod connectivity-matrix.md "$k" 3 set "Probably workable [E-SAGE-001]" || return 1; EXPECT="C-05"; }
add C06; case_C06() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1
  cellmod connectivity-matrix.md "$k" 11 set "Maybe" || return 1; EXPECT="C-06"; }
add C10; case_C10() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1
  cellmod connectivity-matrix.md "$k" 4 append " [E-SAGE-999]" || return 1; EXPECT="C-10"; }
add C10b; case_C10b() { local k; k=$(pick connectivity-matrix.md '1'); need "connectivity row" "$k" || return 1  # prefix match must not hide a 4-digit ID
  cellmod connectivity-matrix.md "$k" 4 append " [E-SAGE-0071]" || return 1; EXPECT="C-10"; }
add C-TBL; case_C-TBL() { # prose after the table with two pipes must not count as a data row
  sedi connectivity-matrix.md -e '$ a\' -e '' -e '$ a\See a | b | c for the key.' || return 1; EXPECT=""; MODE=same; }
add A01; case_A01() { local n; n=$("$REAL_AWK" 'NR>2 && /^\|/ {print NR; exit}' "$W/automation-feasibility-matrix.md"); sedi automation-feasibility-matrix.md "${n}d" || return 1; EXPECT="A-01"; }
add A02; case_A02() { local k; k=$(pick automation-feasibility-matrix.md '1'); need "automation row" "$k" || return 1
  cp "$W/automation-feasibility-matrix.md" "$W/.pre"; "$REAL_AWK" -F'|' -v OFS='|' -v K="$k" "$ST"'t($2)==K && !d {d=1; $12=$13; NF=12} {print}' "$W/automation-feasibility-matrix.md" > "$W/.new" && mv "$W/.new" "$W/automation-feasibility-matrix.md"; changed automation-feasibility-matrix.md || return 1; EXPECT="A-02"; }
add A03; case_A03() { local k; k=$(pick automation-feasibility-matrix.md '1'); need "automation row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 5 set "Looks fine" || return 1; EXPECT="A-03"; }
add A04; case_A04() { local k; k=$(pick automation-feasibility-matrix.md '1'); need "automation row" "$k" || return 1
  cellmod automation-feasibility-matrix.md "$k" 2 set "Customer PO and supplier PO handling" || return 1; EXPECT="A-04"; }
add V02; case_V02() { sedi vendor-questions.md '$ a\We emailed Unishippers last week.' || return 1; EXPECT="V-02"; }
add V03; case_V03() { sedi vendor-questions.md '$ a\See also E-SAGE-999.' || return 1; EXPECT="V-03"; }
add P01; case_P01() { sedi poc-tests.md 's/^## POC-07 — /### POC-07 — /' || return 1; EXPECT="P-01"; }
add P04; case_P04() { local k lit; k=$(pick connectivity-matrix.md '$11 ~ /Recommended for PoC|Viable with conditions/'); need "viable path" "$k" || return 1
  lit=$(sed_lit "$k"); sedi poc-tests.md "s#$lit#${k/:/;}#g" || return 1; EXPECT="P-04"; }
add P07; case_P07() { sedi poc-tests.md '$ a\Depends on E-SAGE-999.' || return 1; EXPECT="P-07"; }
add F01; case_F01() { sedi findings-summary.md 's/^## Handoffs/## Hand-offs/' || return 1; EXPECT="F-01"; }
add F04; case_F04() { sedi findings-summary.md '$ a\Cites E-SAGE-999.' || return 1; EXPECT="F-04"; }
add F04b; case_F04b() { sedi findings-summary.md '$ a\Cites E-SAGE-0071 (four digits).' || return 1; EXPECT="F-04"; }
add X00; case_X00() { rm -f "$W/poc-tests.md" || return 1; EXPECT="X-00 P-00"; }
add W05; case_W05() { # workflow-summary.md present: its checks activate and the banned wording is caught (NBSP included)
  { echo "Assessment view — not an approved v1 design (Stage B)"; echo; for h in "Current workflow" "Assessed workflow" "Where customer data lives" "Low-cost options" "Open questions"; do echo "## $h"; echo; done; printf 'The tool is not\xc2\xa0supported.\n'; } > "$W/workflow-summary.md" || return 1
  EXPECT="W-05 L-02"; }
# The cases below edit the real workflow-summary.md (Task 11); each needs it in the drafts.
wneed() { [ -f "$W/workflow-summary.md" ] || { fail_setup "workflow-summary.md is not in the drafts"; return 1; }; }
add W01; case_W01() { wneed || return 1; sedi workflow-summary.md 's/Assessment view — not an approved v1 design (Stage B)/Assessment view/' || return 1; EXPECT="W-01"; }
add W02; case_W02() { wneed || return 1; sedi workflow-summary.md 's/^## Where customer data lives/## Customer data/' || return 1; EXPECT="W-02"; }
add W03; case_W03() { wneed || return 1; sedi workflow-summary.md '$ a\A CRM such as HubSpot would hold the customer history.' || return 1; EXPECT="W-03"; }
add W04; case_W04() { wneed || return 1; sedi workflow-summary.md '$ a\See also E-SAGE-997.' || return 1; EXPECT="W-04"; }
add W06; case_W06() { # a verdict that differs from the connectivity matrix
  wneed || return 1; sedi workflow-summary.md 's/Unresolved \[Flow: tracking back to Sage\]/Viable with conditions [Flow: tracking back to Sage]/' || return 1; EXPECT="W-06"; }
add W06b; case_W06b() { # a bracketed path label that is not in the matrix
  wneed || return 1; sedi workflow-summary.md 's/\[Flow: email intake\]/[Flow: inbox intake]/' || return 1; EXPECT="W-06"; }
add W07; case_W07() { # a priority that differs from the automation matrix
  wneed || return 1; sedi workflow-summary.md '/^| Tracking retrieval and Sage update/ s/| P3 |/| P2 |/' || return 1; EXPECT="W-07"; }
add W07b; case_W07b() { # an automation-matrix task with no Assessed-workflow row
  wneed || return 1; sedi workflow-summary.md '/^| Inventory monitoring and supplier PO recommendation/d' || return 1; EXPECT="W-07"; }

# --- script-level cases (environment, not file edits)
mkshims() {
  cat > "$SHIM/shuf" <<'EOF'
#!/usr/bin/env bash
echo "shuf: simulated failure" >&2
exit 1
EOF
  mkdir -p "$SHIM/awkerr" "$SHIM/mawk"
  cat > "$SHIM/awkerr/awk" <<EOF
#!/usr/bin/env bash
for a in "\$@"; do case "\$a" in *'quoted, unverified'*) echo "awk: simulated internal error" >&2; exit 2 ;; esac; done
exec "$REAL_AWK" "\$@"
EOF
  cat > "$SHIM/mawk/awk" <<EOF
#!/usr/bin/env bash
if [ "\$1" = "--version" ] || [ "\$1" = "-W" ]; then echo "mawk 1.3.3 Nov 1996"; exit 0; fi
exec "$REAL_AWK" "\$@"
EOF
  mkdir -p "$SHIM/shuffail"; mv "$SHIM/shuf" "$SHIM/shuffail/shuf"
  chmod +x "$SHIM/shuffail/shuf" "$SHIM/awkerr/awk" "$SHIM/mawk/awk"
}
mkshims
add S-SHUF;  case_S-SHUF()  { EXTRA_PATH="$SHIM/shuffail"; EXPECT="S-01"; }
add S-AWKERR; case_S-AWKERR() { EXTRA_PATH="$SHIM/awkerr"; MODE=error; EXPECT="L-04"; }
add S-MAWK;  case_S-MAWK()  { EXTRA_PATH="$SHIM/mawk"; MODE=exit2; EXPECT="SETUP"; }
add S-NODIR; case_S-NODIR() { ARG="$W/does-not-exist"; MODE=exit2; EXPECT="SETUP"; }
add S-SEED;  case_S-SEED()  { MODE=seed; EXPECT=""; }

# ---------------------------------------------------------------- run all jobs (parallel)
run_job() {
  local name="$1" W rc
  W="$(mktemp -d)" || { echo "mktemp failed" > "$RES/$name.setup"; return; }
  cp "$SNAP"/*.md "$W"/
  MODE=fail; EXPECT=""; EXTRA_PATH=""; ARG="$W"; SETUP_MSG=""
  if ! "case_$name"; then
    echo "${SETUP_MSG:-setup failed}" > "$RES/$name.setup"; rm -rf "$W"; return
  fi
  echo "$MODE" > "$RES/$name.mode"; echo "$EXPECT" > "$RES/$name.expect"
  if [ "$MODE" != skip ]; then
    PATH="${EXTRA_PATH:+$EXTRA_PATH:}$PATH" SEED=suite-seed bash "$V/verify.sh" "$ARG" > "$RES/$name.out" 2>&1; echo $? > "$RES/$name.rc"
    if [ "$MODE" = seed ]; then
      PATH="$PATH" SEED=suite-seed bash "$V/verify.sh" "$ARG" > "$RES/$name.out2" 2>&1
    fi
  fi
  [ -n "${KEEP:-}" ] || rm -rf "$W"
}
if [ -n "${ONLY:-}" ]; then NEW=(BASELINE); for c in $ONLY; do NEW+=("$c"); done; CASES=("${NEW[@]}"); fi
for name in "${CASES[@]}"; do
  while [ "$(jobs -rp | wc -l)" -ge "$JOBS" ]; do wait -n; done
  run_job "$name" &
done
wait

# ---------------------------------------------------------------- evaluation
OK_N=0; BAD_N=0; SKIP_N=0
ok()  { printf 'OK %s — %s\n' "$1" "$2"; OK_N=$((OK_N + 1)); }
bad() { printf 'BAD %s — %s\n' "$1" "$2"; BAD_N=$((BAD_N + 1)); }
fail_ids() { grep -E '^FAIL ' "$1" 2>/dev/null | awk '{print $2}' | LC_ALL=C sort -u; }
fail_block() { # file id -> the FAIL line and its indented offender lines
  awk -v id="$2" '$0 ~ "^FAIL " id " " {p=1; print; next} p && /^    / {print; next} {p=0}' "$1"
}
BASE_OUT="$RES/BASELINE.out"; BASE_IDS="$RES/base.ids"
fail_ids "$BASE_OUT" > "$BASE_IDS"

# BASELINE
eval_baseline() {
  local rc unexpected="" id
  if [ -f "$RES/BASELINE.setup" ]; then bad BASELINE "setup failed: $(cat "$RES/BASELINE.setup")"; return; fi
  rc=$(cat "$RES/BASELINE.rc")
  while read -r id; do
    case " $KNOWN_DRAFT_FAILS " in *" $id "*) ;; *) unexpected="$unexpected $id" ;; esac
  done < "$BASE_IDS"
  if [ "$rc" -ne 0 ] && [ "$rc" -ne 1 ]; then bad BASELINE "verify.sh exited $rc"
  elif [ "$rc" -eq 1 ] && [ ! -s "$BASE_IDS" ]; then bad BASELINE "exit 1 but no FAIL line"
  elif [ -n "$unexpected" ]; then bad BASELINE "unexpected FAIL on the untouched drafts:$unexpected (a script defect or a new draft defect)"
  elif grep -q 'CHECK ERROR' "$BASE_OUT"; then bad BASELINE "CHECK ERROR in the baseline output"
  elif ! grep -q '^Totals: ' "$BASE_OUT"; then bad BASELINE "no Totals line"
  else local ids; ids="$(tr '\n' ' ' < "$BASE_IDS" | sed 's/ $//')"; ok BASELINE "exit $rc; FAILs are only known draft issues: ${ids:-none}"; fi
}
# S-01 count consistency and INFO accounting, on the baseline output
eval_baseline_s01() {
  local line total drawn rows fixed
  line=$(grep '^INFO S-01 ' "$BASE_OUT")
  total=$(echo "$line" | sed -n 's/.*sample of \([0-9]*\) rows.*/\1/p'); drawn=$(echo "$line" | sed -n 's/.*= \([0-9]*\) drawn.*/\1/p')
  rows=$(grep -cE '^    E-[A-Z]+-[0-9]+( \[FIXED\])? \|' "$BASE_OUT"); fixed=$(grep -c '^    E-[A-Z]*-[0-9]* \[FIXED\] |' "$BASE_OUT")
  if [ -z "$line" ]; then bad BASELINE-S01 "no INFO S-01 line"
  elif [ "$((drawn + 2))" -ne "$total" ] || [ "$total" -ne "$rows" ] || [ "$fixed" -ne 2 ]; then bad BASELINE-S01 "stated total $total, K $drawn, $rows rows printed, $fixed marked fixed (need total = K+2 = rows, 2 fixed)"
  elif ! echo "$line" | grep -q 'SEED=suite-seed'; then bad BASELINE-S01 "SEED not printed"
  elif grep -qE '^PASS (S-01|P-05) ' "$BASE_OUT"; then bad BASELINE-S01 "S-01 or P-05 counted as PASS"
  elif ! grep -qE '^Totals: [0-9]+ PASS, [0-9]+ FAIL, [0-9]+ SKIP, 2 INFO$' "$BASE_OUT"; then bad BASELINE-S01 "Totals line does not show 2 INFO"
  else ok BASELINE-S01 "INFO S-01: $total rows = $drawn drawn + 2 fixed, SEED printed, P-05 and S-01 counted as INFO"; fi
}

eval_case() {
  local name="$1" mode expect out rc grp alt id missing="" okids="" hit alt_hit
  if [ -f "$RES/$name.setup" ]; then bad "$name" "mutation not applied: $(cat "$RES/$name.setup")"; return; fi
  mode=$(cat "$RES/$name.mode"); expect=$(cat "$RES/$name.expect"); out="$RES/$name.out"
  case "$mode" in
    skip) printf 'SKIP %s — %s\n' "$name" "$expect"; SKIP_N=$((SKIP_N + 1)); return ;;
    baseline) eval_baseline; eval_baseline_s01; return ;;
  esac
  rc=$(cat "$RES/$name.rc")
  case "$mode" in
    exit2)
      if [ "$rc" -eq 2 ] && grep -q '^FAIL SETUP' "$out"; then ok "$name" "$expect FAILed as expected (exit 2: $(grep '^FAIL SETUP' "$out" | head -1 | cut -c1-80))"
      else bad "$name" "$expect did not FAIL with exit 2 (exit $rc)"; fi
      return ;;
    nofail)
      for id in $expect; do
        if grep -q "^FAIL $id " "$out" && [ "$(fail_block "$out" "$id")" != "$(fail_block "$BASE_OUT" "$id")" ]; then missing="$missing${missing:+, }$id"; fi
        grep -qE "^(PASS|FAIL) $id " "$out" || missing="$missing${missing:+, }$id (no result line)"
      done
      if grep -q 'CHECK ERROR' "$out"; then bad "$name" "unexpected CHECK ERROR in the output"
      elif [ -z "$missing" ]; then ok "$name" "${expect// /, } did not FAIL and the offender block is unchanged from the baseline"
      else bad "$name" "${missing} FAILed or changed on an exempt row"; fi
      return ;;
    same)
      if [ "$(fail_ids "$out" | tr '\n' ' ')" = "$(tr '\n' ' ' < "$BASE_IDS")" ] && ! grep -q 'CHECK ERROR' "$out" \
         && [ "$(grep -c '^PASS ' "$out")" = "$(grep -c '^PASS ' "$BASE_OUT")" ]; then ok "$name" "run is identical to the baseline (same FAIL set, same PASS count, no CHECK ERROR)"
      else bad "$name" "run differs from the baseline (FAIL set or PASS count changed, or CHECK ERROR present)"; fi
      return ;;
    seed)
      if [ "$(grep -A99 '^INFO S-01' "$out" | grep -v '^Totals')" = "$(grep -A99 '^INFO S-01' "$RES/$name.out2" | grep -v '^Totals')" ] && grep -q '^INFO S-01' "$out"; then ok "$name" "same SEED draws the same S-01 sample twice"
      else bad "$name" "same SEED gave two different S-01 samples"; fi
      return ;;
    error)
      id="$expect"
      if grep -q "^FAIL $id " "$out" && fail_block "$out" "$id" | grep -q 'CHECK ERROR' && ! grep -q "^PASS $id " "$out"; then ok "$name" "$id FAILed as expected (awk error reported as CHECK ERROR, not PASS)"
      else bad "$name" "$id did not FAIL with CHECK ERROR when awk errored"; fi
      return ;;
  esac
  # mode fail: every group of expected IDs must FAIL beyond the baseline; "A|B" means either
  if grep -q 'CHECK ERROR' "$out"; then bad "$name" "${expect// /, } did not FAIL cleanly: unexpected CHECK ERROR in the output"; return; fi
  for grp in $expect; do
    alt_hit=""
    for alt in ${grp//|/ }; do
      if grep -q "^FAIL $alt " "$out"; then
        if ! grep -qx "$alt" "$BASE_IDS" || [ "$(fail_block "$out" "$alt")" != "$(fail_block "$BASE_OUT" "$alt")" ]; then alt_hit="$alt"; break; fi
      fi
    done
    if [ -n "$alt_hit" ]; then okids="$okids${okids:+, }$alt_hit"; else missing="$missing${missing:+, }${grp//|/ or }"; fi
  done
  if [ -z "$missing" ]; then ok "$name" "$okids FAILed as expected"; else bad "$name" "$missing did not FAIL (exit $rc; FAILs seen: $(fail_ids "$out" | tr '\n' ' '))"; fi
}
for name in "${CASES[@]}"; do eval_case "$name"; done

echo
printf 'Totals: %s OK, %s BAD, %s SKIP (results: %s from %s cases, BASELINE gives two; jobs: %s)\n' "$OK_N" "$BAD_N" "$SKIP_N" "$((OK_N + BAD_N + SKIP_N))" "${#CASES[@]}" "$JOBS"
[ "$BAD_N" -eq 0 ] || { echo "RESULT: at least one case is BAD - verify.sh has a hole or a check regressed"; exit 1; }
echo "RESULT: every mutation was caught"
exit 0
