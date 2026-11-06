#!/usr/bin/env bash
# verify.sh - mechanical verification of the sub-project 1 research deliverables.
#
# Usage:  bash verify.sh [DIR]
#   DIR defaults to ../drafts, resolved relative to this script's own directory.
#
# Every check prints exactly one line:  PASS|FAIL|SKIP|INFO <check-id> — <description>
# A FAIL line is followed by up to 20 offending lines, indented.
# INFO lines (P-05, S-01) are manual-review items: they are never counted as PASS.
# A check whose awk/grep command errors out FAILs with "CHECK ERROR" (an error never reads as PASS).
# Totals are printed at the end.
# Exit status: 0 = no FAIL, 1 = at least one check FAILed, 2 = setup failure (nothing was checked).
#
# See TEST-PLAN.md (same folder) for what each check means; test-verify.sh is the regression suite.
# Env: SEED=<text> makes the S-01 spot-check sample reproducible. Leave unset for a fresh draw
#      (the seed that was used is printed, so any draw can be repeated).
#
# Check-ID map (families): X setup, L ledger, C connectivity matrix, A automation matrix,
#   V vendor questions, P PoC tests, F findings summary, W workflow summary, S spot-check.
#   Reserved by TEST-PLAN.md and deliberately unused here: L-16 (G1), L-17 (G13),
#   P-06 (G5), F-05 (G6), F-06 (G2), A-09 (G7), C-11 (G12).
#   L-15 (G4) compares research rows with research-rows.sha256 in this folder (see baseline-research-rows.sh).
#
# Ledger column map (split on '|'; NF==17 for a 15-column row):
#   $2 ID  $3 Domain  $4 Claim  $5 Claim type  $6 Status  $7 Source  $8 Source type  $9 Applies to
#   $10 Accessed  $11 Strength  $12 Assumptions  $13 Limitations  $14 Validation needed
#   $15 Decision supported  $16 Conflicts with

# ---------------------------------------------------------------- setup (exit 2 on failure)
if ! awk --version 2>&1 | head -n 1 | grep -q '^GNU Awk'; then
  echo "FAIL SETUP — GNU awk (gawk) is required: the checks use {n} regex intervals and tolower()/gensub-era behaviour"
  exit 2
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || { echo "FAIL SETUP — cannot resolve the script directory"; exit 2; }
DIR="${1:-$SCRIPT_DIR/../drafts}"
if [ ! -d "$DIR" ]; then
  echo "FAIL SETUP — directory not found: $DIR"
  exit 2
fi
DIR="$(cd "$DIR" && pwd)" || { echo "FAIL SETUP — cannot enter $DIR"; exit 2; }

T="$(mktemp -d)" || { echo "FAIL SETUP — mktemp -d failed"; exit 2; }
[ -n "$T" ] && [ -d "$T" ] || { echo "FAIL SETUP — mktemp -d returned no directory"; exit 2; }
trap 'rm -rf "$T"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

PASS_N=0; FAIL_N=0; SKIP_N=0; INFO_N=0

# ---------------------------------------------------------------- helpers
emit() { # status id description [offender-file]
  local st="$1" id="$2" desc="$3" off="${4:-}" n=0
  if [ "$st" = FAIL ] && [ -n "$off" ] && [ -s "$off" ]; then
    n=$(wc -l < "$off")
    desc="$desc ($n offending)"
  fi
  printf '%s %s — %s\n' "$st" "$id" "$desc"
  case "$st" in
    PASS) PASS_N=$((PASS_N + 1)) ;;
    SKIP) SKIP_N=$((SKIP_N + 1)) ;;
    INFO) INFO_N=$((INFO_N + 1)) ;;
    FAIL) FAIL_N=$((FAIL_N + 1))
          if [ -n "$off" ] && [ -s "$off" ]; then
            head -n 20 "$off" | cut -c1-260 | sed 's/^/    /'
          fi ;;
  esac
}
OFF="$T/off"      # scratch offender file; every check starts from empty and check() empties it again
: > "$OFF"
check() { # id description  -> PASS when the offender file ($OFF) is empty
  if [ -s "$OFF" ]; then emit FAIL "$1" "$2" "$OFF"; else emit PASS "$1" "$2"; fi
  : > "$OFF"
}
csort() { LC_ALL=C sort "$@"; }
ccomm() { LC_ALL=C comm "$@"; }

# Run awk with stdout to a file. Any non-zero exit or any stderr output becomes a "CHECK ERROR" line in
# $OFF (or in $ERRF), which makes the check FAIL. An awk error can therefore never read as PASS.
awkto() { # outfile awk-args...
  local out="$1" rc; shift
  awk "$@" > "$out" 2> "$T/awk.err"; rc=$?
  if [ "$rc" -ne 0 ] || [ -s "$T/awk.err" ]; then
    echo "CHECK ERROR: awk exited $rc: $(head -c 200 "$T/awk.err" | tr '\n' ' ')" >> "${ERRF:-$OFF}"
  fi
}
# grep -q with an error guard: returns grep's status (0 match, 1 no match); status 2+ is recorded as CHECK ERROR.
grepq() {
  grep -q "$@"; local rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep exited $rc (args: ${*:0:4})" >> "$OFF"
  return "$rc"
}
# grep with stdout appended to $OFF, status 2+ recorded as CHECK ERROR.
grepoff() {
  grep "$@" >> "$OFF" 2> "$T/grep.err"; local rc=$?
  if [ "$rc" -gt 1 ] || [ -s "$T/grep.err" ]; then echo "CHECK ERROR: grep exited $rc: $(head -c 200 "$T/grep.err" | tr '\n' ' ')" >> "$OFF"; fi
}
gcount() { # grep -c with an error guard; prints the count
  local n rc
  n=$(grep -c "$@" 2> "$T/grep.err"); rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep -c exited $rc" >> "$OFF"
  echo "${n:-0}"
}

# awk preamble: t() trims, n() folds NBSP (U+00A0), narrow NBSP (U+202F) and tab to a space and collapses runs of
# spaces, lc() is a trimmed lower-case, uc() a trimmed upper-case. Define once, use everywhere.
TRIM='function n(s){gsub(/\302\240|\342\200\257|\t/," ",s);gsub(/ +/," ",s);return s}
function t(s){s=n(s);gsub(/^ +| +$/,"",s);return s}
function lc(s){return tolower(t(s))}
function uc(s){return toupper(t(s))}
function ex(s){return lc(s) ~ /^(stakeholder|analyst inference)$/}   # Ruling 51: SR and analyst-inference rows are exempt from L-19/20/22/23/26
'

# cited_missing FILE: IDs that look like ledger IDs (any digit count) but are not exact ledger row IDs.
cited_missing() {
  grep -oE 'E-[A-Z]+-[0-9]+' "$1" > "$T/cited.raw" 2> "$T/grep.err"
  local rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep exited $rc while reading cited IDs in $1"
  csort -u "$T/cited.raw" | ccomm -23 - "$T/ids" | sed 's/^/cited but not a ledger row ID: /'
}
cited_check() { # check-id file
  if [ "$HAVE_LEDGER" -eq 1 ]; then
    cited_missing "$2" >> "$OFF"
    check "$1" "every ID cited exists in the ledger (exact match)"
  else
    emit SKIP "$1" "ledger unavailable, cited IDs not checked"
  fi
}

# banned_phrases FILE...: appends to $OFF every line that says "not supported"/"unsupported" (any case, NBSP/tab
# folded), after removing the one allowed phrase "No supported method found in sources checked".
banned_phrases() {
  local f files=()
  for f in "$@"; do [ -f "$f" ] && files+=("$f"); done
  [ "${#files[@]}" -gt 0 ] || return 0
  awkto "$T/banned.out" "$TRIM"'{
    l=tolower(n($0)); gsub(/no supported method found in sources checked/,"",l)
    if (l ~ /not supported|unsupported/) { fn=FILENAME; sub(/^.*\//,"",fn); print fn ":" FNR ": " substr($0,1,200) }
  }' "${files[@]}"
  cat "$T/banned.out" >> "$OFF"
}

# ---------------------------------------------------------------- normalise inputs (strip CR)
for f in "$DIR"/*.md; do
  [ -f "$f" ] || continue
  tr -d '\r' < "$f" > "$T/$(basename "$f")" || { echo "FAIL SETUP — cannot copy $f"; exit 2; }
done

LEDGER="$T/evidence-ledger.md"
CONN="$T/connectivity-matrix.md"
AUTO="$T/automation-feasibility-matrix.md"
VEND="$T/vendor-questions.md"
POC="$T/poc-tests.md"
FIND="$T/findings-summary.md"
WORK="$T/workflow-summary.md"

# Deliverables that must be present (workflow-summary.md is optional until Task 11).
for f in evidence-ledger.md connectivity-matrix.md automation-feasibility-matrix.md vendor-questions.md poc-tests.md findings-summary.md; do
  [ -f "$T/$f" ] || echo "missing file: $f" >> "$OFF"
done
check X-00 "all six required deliverables are present in $DIR"

# ---------------------------------------------------------------- ledger extraction
# Table starts at the first line matching ^\| ID \| and ends at the first blank line.
# Data rows follow the header and the separator row; a well-formed row has NF==17 when split on '|'.
HAVE_LEDGER=0
if [ -f "$LEDGER" ] && grep -q '^| ID |' "$LEDGER"; then
  HAVE_LEDGER=1
  ERRF="$T/setup.err" awkto "$T/ledger.all" '!f && /^\| ID \|/{f=1; h=NR; next} f && /^$/{exit} f && NR>h+1 {print}' "$LEDGER"
  ERRF="$T/setup.err" awkto "$T/ledger.rows" -F'|' 'NF==17' "$T/ledger.all"
  ERRF="$T/setup.err" awkto "$T/ids.unsorted" -F'|' "$TRIM"'{print t($2)}' "$T/ledger.rows"
  csort -u "$T/ids.unsorted" > "$T/ids"
fi
# Matrix tables: start at the header row, end at the first blank line (line 1 = header, line 2 = separator).
CONN_NF=12; AUTO_NF=13   # 10 and 11 columns plus the two empty fields around the outer pipes
HAVE_CONN=0; HAVE_AUTO=0
if [ -f "$CONN" ] && grep -q '^| Path |' "$CONN"; then
  HAVE_CONN=1
  ERRF="$T/setup.err" awkto "$T/conn.table" '!f && /^\| Path \|/{f=1} f && /^$/{exit} f {print}' "$CONN"
  CONN_OFF=$(awk '/^\| Path \|/{print NR-1; exit}' "$CONN")
fi
if [ -f "$AUTO" ] && grep -q '^| Task |' "$AUTO"; then
  HAVE_AUTO=1
  ERRF="$T/setup.err" awkto "$T/auto.table" '!f && /^\| Task \|/{f=1} f && /^$/{exit} f {print}' "$AUTO"
  AUTO_OFF=$(awk '/^\| Task \|/{print NR-1; exit}' "$AUTO")
fi
if [ -s "$T/setup.err" ]; then
  cp "$T/setup.err" "$OFF"
  emit FAIL X-01 "table extraction errored (no check below can be trusted)" "$OFF"; : > "$OFF"
fi

# ================================================================ LEDGER (L-)
if [ "$HAVE_LEDGER" -eq 0 ]; then
  emit FAIL L-00 "evidence-ledger.md missing or has no table starting with '| ID |'; every L-, C-, A-, V-, F- ID check needs it"
else
  R="$T/ledger.rows"

  # L-00b: every ledger-style ID row in the file must be inside the extracted table (a stray blank line would
  # otherwise hide every row after it from all L- checks).
  awkto "$OFF" '/^\| ID \|/ && s==0 {s=1; next} s==1 && /^$/ {s=2} s!=1 && /^\| *E-[A-Z]+-[0-9]+ *\|/ {print "line " NR " is an ID row outside the extracted table: " substr($0,1,90)}' "$LEDGER"
  check L-00b "every '| E-...' ID row in the ledger file sits inside the extracted table (no blank line cuts it short)"

  awkto "$OFF" -F'|' "$TRIM"'NF!=17 {print "table row " NR ": " (NF-2) " columns (need 15): " substr($0,1,90)}' "$T/ledger.all"
  check L-01 "RC-1: every ledger row has exactly 15 columns"

  banned_phrases "$T"/evidence-ledger.md "$T"/connectivity-matrix.md "$T"/automation-feasibility-matrix.md \
    "$T"/vendor-questions.md "$T"/poc-tests.md "$T"/findings-summary.md "$T"/workflow-summary.md \
    "$T"/sources-ai.md "$T"/sources-ecom.md "$T"/sources-mail.md "$T"/sources-sage.md "$T"/sources-ship.md
  check L-02 "RC-2: no banned phrasing (\"not supported\"/\"unsupported\", any case, NBSP/tab folded) in any deliverable"

  awkto "$OFF" -F'|' "$TRIM"'
    function valid(d,   a,y,m,dd,dim) {
      if (d !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/) return 0
      split(d,a,"-"); y=a[1]+0; m=a[2]+0; dd=a[3]+0
      if (m<1 || m>12) return 0
      dim=31; if (m==4||m==6||m==9||m==11) dim=30
      else if (m==2) dim=((y%4==0 && y%100!=0) || y%400==0) ? 29 : 28
      return (dd>=1 && dd<=dim)
    }
    !valid(t($10)) {print t($2) ": Accessed = \"" t($10) "\" (need a real YYYY-MM-DD date)"}' "$R"
  check L-03 "RC-3: Accessed date is a valid YYYY-MM-DD (month 01-12, day valid for the month)"

  awkto "$OFF" -F'|' "$TRIM"'lc($5) ~ /pricing/ && uc($11) != "S1" && lc($4) !~ /quoted, unverified|estimate/ {print t($2) ": pricing row is " t($11) " and not labelled quoted, unverified / estimate"}' "$R"
  check L-04 "RC-4: a pricing row is S1, or its Claim says \"quoted, unverified\" or \"estimate\" (case-insensitive)"

  awkto "$OFF" -F'|' "$TRIM"'lc($13) ~ /registration|sign-in|login/ && lc($6) == "verified" {print t($2) ": Limitations mention registration/sign-in/login but status is " t($6)}' "$R"
  check L-05 "RC-5: a row whose Limitations mention registration, sign-in or login is not status verified"

  awkto "$T/ids.list" -F'|' "$TRIM"'{print t($2)}' "$R"
  csort "$T/ids.list" | uniq -d > "$OFF"
  check L-06 "ledger IDs are unique"

  if LC_ALL=C sort -c "$T/ids.list" 2> "$T/sortmsg"; then : > "$OFF"; else cat "$T/sortmsg" > "$OFF"; fi
  check L-07 "ledger IDs are sorted (LC_ALL=C)"

  # pairs: "<row id> <conflicting id>" for every ID cited in the Conflicts-with column
  awkto "$T/pairs" -F'|' "$TRIM"'{
    id=t($2); s=$16
    while (match(s, /E-[A-Z]+-[0-9]{3}/)) { print id, substr(s,RSTART,RLENGTH); s=substr(s,RSTART+RLENGTH) }
  }' "$R"
  awk '{print $2}' "$T/pairs" | csort -u | ccomm -23 - "$T/ids" > "$OFF"
  check L-08 "every ID named in Conflicts-with exists in the ledger"

  csort -u "$T/pairs" > "$T/pairs.s"
  awk '{print $2, $1}' "$T/pairs" | csort -u > "$T/pairs.rev"
  ccomm -13 "$T/pairs.s" "$T/pairs.rev" | awk '{print $2 " cites " $1 " as a conflict, but " $1 " does not cite " $2 " back"}' > "$OFF"
  check L-09 "Conflicts-with is symmetric (A names B, so B names A)"

  awkto "$OFF" -F'|' "$TRIM"'$11 ~ /S1|S2/ && $7 !~ /https:\/\// {print t($2) ": " t($11) " row has no https:// source"}' "$R"
  check L-10 "S1 and S2 rows have an https:// source"

  awkto "$OFF" -F'|' "$TRIM"'lc($6) == "hypothesis" && lc($13) ~ /search extract|excerpt/ && tolower($0) !~ /snippet only/ {print t($2) ": hypothesis row mentions search extract/excerpt but never says \"snippet only\""}' "$R"
  check L-11 "hypothesis rows whose Limitations mention \"search extract\"/\"excerpt\" also say \"snippet only\""

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D1" && $12 !~ /A-01/ {print t($2) ": D1 row lacks A-01 (Assumptions = \"" t($12) "\")"}' "$R"
  check L-12 "every D1 row carries A-01 (no DELTA exemption, Ruling 49)"

  awkto "$OFF" -F'|' "$TRIM"'lc($4) ~ /supergrok/ && $12 !~ /A-02/ {print t($2) ": Claim mentions SuperGrok but Assumptions = \"" t($12) "\""}' "$R"
  check L-13 "every row whose Claim mentions SuperGrok carries A-02"

  awkto "$T/decisions" -F'|' '{print $15}' "$R"
  for q in D1.Q1 D1.Q2 D1.Q3 D1.Q4 D1.Q5 D2.Q1 D2.Q2 D2.Q3 D2.Q4 D2.Q5 D3.Q1 D3.Q2 D4.Q1 D4.Q2 D4.Q3 D4.Q4 MAIL.Q1 MAIL.Q2; do
    grepq -F -- "$q" "$T/decisions" || echo "question $q appears in no row's Decision supported column" >> "$OFF"
  done
  check L-14 "all 18 question IDs appear (D1.Q1-5, D2.Q1-5, D3.Q1-2, D4.Q1-4, MAIL.Q1-2)"

  # L-18: controlled vocabularies (plan, "Ledger row format"). Case-insensitive equality; offenders reported as written.
  awkto "$OFF" -F'|' "$TRIM"'
    BEGIN {
      split("verified stakeholder-reported assumption hypothesis unknown", a, " "); for (i in a) st[a[i]]=1
      split("capability licensing pricing limitation process", a, " ");              for (i in a) ct[a[i]]=1
      split("s1 s2 s3 s4 sr", a, " ");                                               for (i in a) sg[a[i]]=1
    }
    !(lc($6) in st) {print t($2) ": Status = \"" t($6) "\" is not one of verified, stakeholder-reported, assumption, hypothesis, unknown"}
    !(lc($5) in ct) {print t($2) ": Claim type = \"" t($5) "\" is not one of capability, licensing, pricing, limitation, process"}
    !(lc($11) in sg) {print t($2) ": Strength = \"" t($11) "\" is not one of S1, S2, S3, S4, SR"}' "$R"
  check L-18 "Status, Claim type and Strength are each an allowed literal (case-insensitive)"

  # L-19..L-26: the plan's Step 1 coverage checks (Tasks 1-4), run on the merged ledger by Domain.
  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D1" && !ex($8) && $9 !~ /US/ && lc($4) !~ /delta:/ {print t($2) ": D1 row does not name US in Applies to (\"" substr(t($9),1,50) "\")"}' "$R"
  check L-19 "Task 1: every D1 row names US in Applies to (DELTA: rows excepted) (research rows)"

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D1" && !ex($8) && $9 !~ /20[0-9][0-9]|Pro|Premium|Quantum/ && lc($13) !~ /version unspecified/ {print t($2) ": D1 row names no version and does not say \"version unspecified\""}' "$R"
  check L-20 "Task 1: every D1 row names a version or says \"version unspecified\" in Limitations (research rows)"

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D2" && lc($7 " " $13) ~ /franchise/ && t($11) ~ /S1|S2/ {print t($2) ": franchise source graded " t($11) " (must be S3 or lower)"}' "$R"
  check L-21 "Task 2: a franchise source is graded S3 or lower"

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D2" && !ex($8) && $15 ~ /D2\.Q5/ && lc($4) !~ /comparison only/ {print t($2) ": supports D2.Q5 but Claim does not say \"comparison only\""}' "$R"
  check L-22 "Task 2: every D2.Q5 row says \"comparison only\" (research rows)"

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D3" && !ex($8) {c++} END{if (c>12) print "D3 has " c " rows, cap is 12"}' "$R"
  check L-23 "Task 3: at most 12 D3 rows (research rows)"

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="D4" && $4 ~ /xAI|Grok|Anthropic|Claude|OpenAI|GPT|Google|Gemini/ && lc($9) !~ /consumer|api/ {print t($2) ": D4 vendor row does not say consumer or API in Applies to (\"" substr(t($9),1,50) "\")"}' "$R"
  check L-24 "Task 4: every D4 vendor row says consumer or API in Applies to"

  awkto "$T/d4.rows" -F'|' "$TRIM"'t($3)=="D4"' "$R"
  for v in xAI Anthropic OpenAI Google "Document Intelligence" Textract; do
    grepq -F -- "$v" "$T/d4.rows" || echo "no D4 row mentions comparison vendor: $v" >> "$OFF"
  done
  check L-25 "Task 4: each comparison vendor (xAI, Anthropic, OpenAI, Google, Document Intelligence, Textract) is covered by a D4 row"

  awkto "$OFF" -F'|' "$TRIM"'t($3)=="MAIL" && !ex($8) && t($4) !~ /^If (Microsoft 365|M365|Google Workspace)/ {print t($2) ": MAIL claim is not written as a conditional (\"" substr(t($4),1,50) "\")"}' "$R"
  check L-26 "Task 4: every MAIL claim starts \"If Microsoft 365\"/\"If M365\"/\"If Google Workspace\" (research rows)"

  # L-15 (G4): frozen research rows. Research rows may change only through a ruling, which re-baselines in the same
  # change (baseline-research-rows.sh). Row definition and hash live in research-rows.lib.sh, shared with that script.
  # FAILs on: a changed row; a baselined row that is gone or no longer a research row (e.g. its Source type was
  # retyped to stakeholder, which would also exempt it from Ruling 51 checks); a research row with no baseline.
  BASEF="$SCRIPT_DIR/research-rows.sha256"
  if [ ! -f "$BASEF" ]; then
    echo "baseline missing: $BASEF (run: bash baseline-research-rows.sh \"<ruling>\")" >> "$OFF"
  elif ! . "$SCRIPT_DIR/research-rows.lib.sh" 2> "$T/rr.err" || ! research_hashes "$LEDGER" > "$T/rr.now" 2>> "$T/rr.err" || [ -s "$T/rr.err" ]; then
    echo "CHECK ERROR: research-row hashing failed: $(head -c 200 "$T/rr.err" | tr '\n' ' ')" >> "$OFF"
  else
    grep -v '^#' "$BASEF" | csort > "$T/rr.base"
    cut -d' ' -f1 "$T/rr.base" > "$T/rr.base.ids"
    cut -d' ' -f1 "$T/rr.now" > "$T/rr.now.ids"
    LC_ALL=C join "$T/rr.base" "$T/rr.now" | awk '$2!=$3 {print $1 ": research row changed since the baseline (needs a ruling, then a re-baseline)"}' >> "$OFF"
    ccomm -23 "$T/rr.base.ids" "$T/rr.now.ids" | sed 's/$/: baselined research row is missing, or is no longer a research row (Source type changed?)/' >> "$OFF"
    ccomm -13 "$T/rr.base.ids" "$T/rr.now.ids" | sed 's/$/: research row has no baseline (new row: needs a ruling, then a re-baseline)/' >> "$OFF"
  fi
  check L-15 "frozen research rows: every research row matches research-rows.sha256 (G4)"
fi

# ================================================================ CONNECTIVITY MATRIX (C-)
if [ ! -f "$CONN" ]; then
  emit FAIL C-00 "connectivity-matrix.md missing"
elif [ "$HAVE_CONN" -eq 0 ]; then
  emit FAIL C-00 "connectivity-matrix.md has no table starting with '| Path |'"
else
  # Table = header row, separator row, then rows up to the first blank line. Path = $2 ... Licensing = $5 ... Verdict = $11.
  CT="$T/conn.table"
  N_ROWS=$(awk -F'|' 'NR>2 && NF>2' "$CT" | wc -l)
  [ "$N_ROWS" -eq 14 ] || echo "found $N_ROWS data rows, expected 14" >> "$OFF"
  check C-01 "exactly 14 data rows"

  awkto "$OFF" -F'|' -v O="$CONN_OFF" -v X="$CONN_NF" 'NR>2 && NF>2 && NF!=X {print "line " (NR+O) ": " (NF-2) " columns (need " (X-2) "): " substr($0,1,90)}' "$CT"
  check C-02 "every row has 10 columns (NF==12)"

  awkto "$T/conn.paths" -F'|' "$TRIM"'NR>2 && NF>2 {print t($2)}' "$CT"
  for p in "Sage: manual entry (baseline)" "Sage: CSV import/export" "Sage: SDK or direct data access" "Sage: approved marketplace connector" "Sage: UI automation (last resort)" "Shipping: Unishippers portal" "Shipping: Unishippers API" "Shipping: direct carrier API" "Shipping: multi-carrier tool" "Flow: customer PO to Sage draft sales order" "Flow: Sage sales order to shipment" "Flow: tracking back to Sage" "Flow: Sage to dashboard (read-only)" "Flow: email intake"; do
    grepq -xF -- "$p" "$T/conn.paths" || echo "Path label missing or altered: $p" >> "$OFF"
  done
  check C-03 "the 14 Path labels match the plan's labels exactly"

  awkto "$OFF" -F'|' -v O="$CONN_OFF" -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X {for(i=3;i<=10;i++) if($i !~ /E-[A-Z]+-[0-9]{3}|Unresolved/) print "line " (NR+O) " (" t($2) ") column " (i-1) ": cites no ID and does not say Unresolved"}' "$CT"
  check C-04 "every cell between Path and Verdict cites an E- ID or says Unresolved"

  awkto "$OFF" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X && $3 !~ /^ *(Supported|Partially supported|No supported method found in sources checked|Unresolved)([^A-Za-z]|$)/ {print t($2) ": Supported evidence starts \"" substr(t($3),1,60) "\""}' "$CT"
  check C-05 "Supported evidence is one of the four allowed strings"

  awkto "$OFF" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X && $11 !~ /^ *(Recommended for PoC|Viable with conditions|Fallback only|Not viable|Unresolved)([^A-Za-z]|$)/ {print t($2) ": Verdict starts \"" substr(t($11),1,60) "\""}' "$CT"
  check C-06 "Verdict is one of the five allowed strings"

  awkto "$OFF" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X && $11 ~ /Recommended for PoC/ && $3 !~ /^ *Supported([^A-Za-z]|$)/ {print t($2) ": Recommended for PoC but Supported evidence is \"" substr(t($3),1,50) "\""}' "$CT"
  check C-07 "Recommended for PoC requires Supported evidence"

  awkto "$OFF" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X && $11 ~ /Recommended for PoC/ && ($5 ~ /Unresolved/ || $3 ~ /Partially supported/) {print t($2) ": Recommended for PoC although Licensing is Unresolved or evidence is Partially supported"}' "$CT"
  check C-08 "Unresolved licensing or Partially supported evidence caps the verdict below Recommended for PoC"

  awkto "$OFF" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X && $2 ~ /UI automation/ {seen++; if ($11 !~ /^ *(Fallback only|Not viable|Unresolved)([^A-Za-z]|$)/) print t($2) ": verdict is \"" substr(t($11),1,50) "\""} END{if(!seen) print "no UI automation row found"}' "$CT"
  check C-09 "the UI automation row's verdict is Fallback only, Not viable or Unresolved"

  cited_check C-10 "$CONN"
fi

# ================================================================ AUTOMATION MATRIX (A-)
if [ ! -f "$AUTO" ]; then
  emit FAIL A-00 "automation-feasibility-matrix.md missing"
elif [ "$HAVE_AUTO" -eq 0 ]; then
  emit FAIL A-00 "automation-feasibility-matrix.md has no table starting with '| Task |'"
else
  # Task = $2 ... Human approval = $7, Recommended approach = $9, Evidence IDs = $11, Priority = $12.
  AT="$T/auto.table"
  N_ROWS=$(awk -F'|' 'NR>2 && NF>2' "$AT" | wc -l)
  [ "$N_ROWS" -eq 9 ] || echo "found $N_ROWS data rows, expected 9" >> "$OFF"
  check A-01 "exactly 9 data rows"

  awkto "$OFF" -F'|' -v O="$AUTO_OFF" -v X="$AUTO_NF" 'NR>2 && NF>2 && NF!=X {print "line " (NR+O) ": " (NF-2) " columns (need " (X-2) "): " substr($0,1,90)}' "$AT"
  check A-02 "every row has 11 columns (NF==13)"

  awkto "$OFF" -F'|' -v O="$AUTO_OFF" -v X="$AUTO_NF" "$TRIM"'NR>2 && NF==X {for(i=3;i<=11;i++) if($i !~ /E-[A-Z]+-[0-9]{3}|Unresolved/) print "line " (NR+O) " (" t($2) ") column " (i-1) ": cites no ID and does not say Unresolved"}' "$AT"
  check A-03 "every cell between Task and Priority cites an E- ID or says Unresolved"

  awkto "$OFF" -F'|' -v O="$AUTO_OFF" -v X="$AUTO_NF" "$TRIM"'NR>2 && NF==X {l=tolower(n($2)); c=0; if(l~/customer po/)c++; if(l~/sage (draft )?sales order/)c++; if(l~/supplier po/)c++; if(c>1) print "line " (NR+O) ": row label mixes order types: " t($2)}' "$AT"
  check A-04 "no row label mixes customer PO, Sage sales order and supplier PO"

  # Ruling 47 / spec 7.2 rule 3: no agent may finalize Sage orders, issue shipments or send supplier POs.
  # So for these rows the Recommended approach ($9) must not recommend agentic orchestration, whatever the approval cell says.
  # Negated mentions ("no agentic", "not agentic", "agentic ... not recommended") do not count as a recommendation.
  awkto "$OFF" -F'|' -v O="$AUTO_OFF" -v X="$AUTO_NF" "$TRIM"'NR>2 && NF==X && lc($2) ~ /finali[sz]ation|issuance|supplier po/ {
      a=lc($9)
      gsub(/(^|[^a-z])(no|not|never|without|avoid|excluding|excluded)[^a-z]+(an? |the |any )?agentic/," ",a)
      gsub(/agentic[a-z ]*[:,(-]* *(is |are )?(not recommended|rejected|ruled out|excluded|not used|not allowed)/,"",a)
      if (a ~ /agentic/) print "line " (NR+O) ": " t($2) ": Recommended approach recommends agentic orchestration (approval cell: \"" substr(t($7),1,50) "\")"
    }' "$AT"
  check A-05 "finalization, issuance and supplier-PO rows never recommend agentic orchestration (Ruling 47, spec 7.2 rule 3)"

  awkto "$OFF" -F'|' -v X="$AUTO_NF" "$TRIM"'NR>2 && NF==X && $2 ~ /Inventory/ {seen++; if (lc($7) !~ /human authorizes/) print t($2) ": Human approval cell lacks \"human authorizes\""} END{if(!seen) print "no Inventory row found"}' "$AT"
  check A-06 "the Inventory row's Human approval cell contains \"human authorizes\""

  # Substring match, as in the plan's Task 7 check: the line may carry a list bullet or a full stop.
  grepq -F -- "Inventory position = on hand + on order − allocated − backordered" "$AUTO" \
    || echo "formula not found: Inventory position = on hand + on order − allocated − backordered (note the minus sign U+2212)" >> "$OFF"
  check A-07 "the file contains the exact reorder-formula text"

  cited_check A-08 "$AUTO"
fi

# ================================================================ VENDOR QUESTIONS (V-)
if [ ! -f "$VEND" ]; then
  emit FAIL V-00 "vendor-questions.md missing"
else
  if [ "$HAVE_LEDGER" -eq 1 ]; then
    awkto "$T/v01.ids" -F'|' "$TRIM"'lc($14) ~ /(^|[^a-z])ask([^a-z]|$)|vendor|confirm with/ {print t($2)}' "$T/ledger.rows"
    while read -r id; do
      grepq -F -- "$id" "$VEND" || echo "$id: Validation needed names a vendor question, but the ID is not in vendor-questions.md" >> "$OFF"
    done < "$T/v01.ids"
    check V-01 "every ledger row whose Validation needed says ask/vendor/confirm with appears in vendor-questions.md"
  else
    emit SKIP V-01 "ledger unavailable, coverage not checked"
  fi
  grepoff -inE "we (asked|emailed|contacted)" "$VEND"
  check V-02 "no \"we asked\", \"we emailed\" or \"we contacted\" (nothing has been sent)"

  cited_check V-03 "$VEND"
fi

# ================================================================ POC TESTS (P-)
if [ ! -f "$POC" ]; then
  emit FAIL P-00 "poc-tests.md missing"
else
  grep -E '^## POC-0[1-7] — ' "$POC" > "$T/poc.heads"; rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep exited $rc reading PoC headings" >> "$OFF"
  hn=$(wc -l < "$T/poc.heads")
  [ "$hn" -eq 7 ] || echo "found $hn headings matching '## POC-0[1-7] — ', expected 7" >> "$OFF"
  check P-01 "exactly 7 headings matching ^## POC-0[1-7] — "

  FROZEN="SAGE-CSV SAGE-SDK SAGE-ODBC SHIP-PORTAL SHIP-MULTI MAIL-INTAKE SAGE-TRACKING"
  ACTUAL=$(sed -E 's/^## POC-0[1-7] — +//' "$T/poc.heads" | awk '{print $1}' | paste -sd' ' -)
  NUMS=$(sed -E 's/^## (POC-0[1-7]).*/\1/' "$T/poc.heads" | paste -sd' ' -)
  [ "$ACTUAL" = "$FROZEN" ] || echo "actual order: $ACTUAL" >> "$OFF"
  [ "$NUMS" = "POC-01 POC-02 POC-03 POC-04 POC-05 POC-06 POC-07" ] || echo "actual numbering: $NUMS" >> "$OFF"
  if [ -s "$OFF" ]; then
    emit FAIL P-02 "frozen PoC names in order SAGE-CSV, SAGE-SDK, SAGE-ODBC, SHIP-PORTAL, SHIP-MULTI, MAIL-INTAKE, SAGE-TRACKING (actual: ${ACTUAL// /, })" "$OFF"; : > "$OFF"
  else
    emit PASS P-02 "frozen PoC names in order (actual: ${ACTUAL// /, })"
  fi

  # Each PoC section (from its ## POC-0n heading to the next ## heading) needs its own "Fail criteria" line.
  awkto "$OFF" '/^## /{ if (h && !fc) print h ": no Fail criteria"; h=""; fc=0 } /^## POC-0[1-7] — /{h=$0} h && /^[*_ ]*Fail criteria/{fc=1} END{ if (h && !fc) print h ": no Fail criteria" }' "$POC"
  check P-03 "every PoC section has its own \"Fail criteria\" line"

  if [ "$HAVE_CONN" -eq 1 ]; then
    awkto "$T/p04.paths" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X && $11 ~ /Recommended for PoC|Viable with conditions/ {print t($2)}' "$T/conn.table"
    while IFS= read -r p; do
      grepq -F -- "$p" "$POC" || echo "no PoC mentions the path label verbatim: $p" >> "$OFF"
    done < "$T/p04.paths"
    check P-04 "every Recommended / Viable-with-conditions path label appears verbatim in poc-tests.md"
  else
    emit SKIP P-04 "connectivity-matrix.md missing or has no table, path coverage not checked"
  fi

  # MANUAL-REVIEW list: INFO, never counted as PASS. A person reads the listed lines.
  grep -nEi "live account|Brad['’]s credentials|production tenant|Brad['’]s account|charge|fee|billable" "$POC" > "$T/manual.lines"; rc=$?
  if [ "$rc" -gt 1 ]; then
    echo "CHECK ERROR: grep exited $rc building the P-05 list" >> "$OFF"; check P-05 "MANUAL-REVIEW list could not be built"
  else
    emit INFO P-05 "MANUAL-REVIEW: listed for manual review ($(wc -l < "$T/manual.lines") lines of poc-tests.md mention live accounts, credentials, tenants or chargeable steps)"
    sed 's/^/    /' "$T/manual.lines"
  fi

  cited_check P-07 "$POC"
fi

# ================================================================ FINDINGS SUMMARY (F-)
if [ ! -f "$FIND" ]; then
  emit FAIL F-00 "findings-summary.md missing"
else
  for h in "Assumptions register" "Ranked unknowns" "Questions that change findings" "Handoffs" "Open questions"; do
    grepq -- "^## $h" "$FIND" || echo "missing heading: ## $h" >> "$OFF"
  done
  check F-01 "all five required headings are present"

  grepoff -nw "CONFIRMED" "$FIND"
  check F-02 "no bare \"CONFIRMED\""

  grepq -F -- "confirmed by stakeholder report 2026-11-06 (E-SAGE-053)" "$FIND" \
    || echo "qualifier not found: confirmed by stakeholder report 2026-11-06 (E-SAGE-053)" >> "$OFF"
  check F-03 "the A-01 qualifier \"confirmed by stakeholder report 2026-11-06 (E-SAGE-053)\" is present"

  cited_check F-04 "$FIND"
fi

# ================================================================ WORKFLOW SUMMARY (W-)
if [ ! -f "$WORK" ]; then
  printf 'SKIP W-* — workflow-summary.md not yet built (Task 11)\n'
  SKIP_N=$((SKIP_N + 1))
else
  grepq -F -- "Assessment view — not an approved v1 design (Stage B)" "$WORK" \
    || echo "label not found: Assessment view — not an approved v1 design (Stage B)" >> "$OFF"
  check W-01 "the label \"Assessment view — not an approved v1 design (Stage B)\" is present"

  for h in "Current workflow" "Assessed workflow" "Where customer data lives" "Low-cost options" "Open questions"; do
    grepq -- "^## $h" "$WORK" || echo "missing heading: ## $h" >> "$OFF"
  done
  check W-02 "the five required headings are present"

  grep -inE "hubspot|zoho|crm" "$WORK" > "$T/w03.hits"; rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep exited $rc" >> "$OFF"
  grep -viE "no crm|not a crm|without a crm|crm.*(excluded|out of scope)|DEC-06|E-ECOM-015" "$T/w03.hits" > "$T/w03.bad"; rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep exited $rc" >> "$OFF"
  cut -c1-200 "$T/w03.bad" >> "$OFF"
  check W-03 "no CRM recommendation (every CRM/HubSpot/Zoho mention is an exclusion or cites DEC-06 / E-ECOM-015)"

  cited_check W-04 "$WORK"

  banned_phrases "$WORK"
  check W-05 "banned phrasing is absent (any case, NBSP/tab folded)"

  # W-06 / W-07: plan Task 11 Step 3, "every verdict and priority must match the two matrices exactly".
  # W-06: every "<Verdict> [<Path label>]" pair in the summary matches that path's Verdict in connectivity-matrix.md.
  if [ "$HAVE_CONN" -eq 1 ]; then
    awkto "$T/conn.verdicts" -F'|' -v X="$CONN_NF" "$TRIM"'NR>2 && NF==X {v=t($11); sub(/[^A-Za-z].*$/,"",v); p=t($2); print p "\t" t($11)}' "$T/conn.table"
    awkto "$OFF" -v CV="$T/conn.verdicts" "$TRIM"'
      BEGIN { FS="\t"; while ((getline l < CV) > 0) { split(l, a, "\t"); cv[a[1]]=a[2] } FS=" " }
      {
        s=$0
        while (match(s, /(Recommended for PoC|Viable with conditions|Fallback only|Not viable|Unresolved) \[[^]]+\]/)) {
          m=substr(s, RSTART, RLENGTH); s=substr(s, RSTART+RLENGTH)
          v=m; sub(/ \[.*$/,"",v); p=m; sub(/^[^[]*\[/,"",p); sub(/\]$/,"",p)
          if (!(p in cv)) { if (p ~ /^(Sage|Shipping|Flow): /) print "line " FNR ": [" p "] is not a connectivity-matrix path label" }
          else if (index(cv[p], v) != 1) print "line " FNR ": says " v " for [" p "], the matrix says " substr(cv[p],1,40)
        }
      }' "$WORK"
    check W-06 "every \"Verdict [Path]\" pair matches the connectivity matrix's verdict for that path"
  else
    emit SKIP W-06 "connectivity-matrix.md has no table, verdicts not compared"
  fi
  # W-07: every Assessed-workflow row (first cell = an automation-matrix Task, optionally followed by " (step ...)")
  # carries that task's Priority in its fifth column, and every automation-matrix task has a row.
  if [ "$HAVE_AUTO" -eq 1 ]; then
    awkto "$T/auto.prio" -F'|' -v X="$AUTO_NF" "$TRIM"'NR>2 && NF==X {print t($2) "\t" t($12)}' "$T/auto.table"
    awkto "$OFF" -v AP="$T/auto.prio" "$TRIM"'
      BEGIN { FS="\t"; while ((getline l < AP) > 0) { split(l, a, "\t"); pr[a[1]]=a[2] } FS="|" }
      /^## / { sec=($0 ~ /^## Assessed workflow/) }
      sec && NF>=8 && t($2) !~ /^(Step|-+)$/ {
        k=t($2); sub(/ \(steps? [^)]*\)$/,"",k)
        if (!(k in pr)) print "line " FNR ": Assessed-workflow step \"" k "\" is not an automation-matrix task"
        else { seen[k]=1; if (t($6) != pr[k]) print "line " FNR ": " k ": priority " t($6) ", the matrix says " pr[k] }
      }
      END { for (k in pr) if (!(k in seen)) print "automation-matrix task has no Assessed-workflow row: " k }' "$WORK"
    check W-07 "every Assessed-workflow row names an automation-matrix task with that task's exact priority, and every task has a row"
  else
    emit SKIP W-07 "automation-feasibility-matrix.md has no table, priorities not compared"
  fi
fi

# ================================================================ SPOT-CHECK SAMPLE (S-01)
if [ "$HAVE_LEDGER" -eq 1 ]; then
  FIXED_IDS="E-SAGE-007 E-AI-053"
  # Pool (Ruling 48): S1 rows whose Limitations do NOT say "snippet only" (case-insensitive).
  awkto "$T/s1pool" -F'|' "$TRIM"'uc($11) == "S1" && lc($13) !~ /snippet only/ {print t($2)}' "$T/ledger.rows"
  N=$(wc -l < "$T/s1pool")
  K=$(( (N * 20 + 99) / 100 )); [ "$K" -lt 5 ] && K=5
  # Draw K with the two fixed IDs excluded, then add them: the total is always K+2.
  grep -vxF -e E-SAGE-007 -e E-AI-053 "$T/s1pool" > "$T/s1pool.draw"; rc=$?
  [ "$rc" -le 1 ] || echo "CHECK ERROR: grep exited $rc building the draw pool" >> "$OFF"
  AVAIL=$(wc -l < "$T/s1pool.draw")
  [ "$K" -gt "$AVAIL" ] && K=$AVAIL
  if [ -n "${SEED:-}" ]; then SEED_USED="$SEED"; SEED_NOTE="given"; else SEED_USED="$(date +%s)-$$-$RANDOM"; SEED_NOTE="generated; rerun with SEED=$SEED_USED to repeat this draw"; fi
  shuf -n "$K" --random-source=<(yes "$SEED_USED") "$T/s1pool.draw" > "$T/sample" 2> "$T/shuf.err"; SHUF_RC=$?
  SAMPLE_N=$(wc -l < "$T/sample")
  if [ "$SHUF_RC" -ne 0 ] || [ "$SAMPLE_N" -ne "$K" ]; then
    echo "shuf exited $SHUF_RC and drew $SAMPLE_N of $K rows: $(head -c 200 "$T/shuf.err" | tr '\n' ' ')" >> "$OFF"
    emit FAIL S-01 "spot-check sample could not be drawn (shuf failed)" "$OFF"; : > "$OFF"
  else
    csort -u "$T/sample" > "$T/sample.u"
    TOTAL=$(( K + 2 ))
    emit INFO S-01 "MANUAL: spot-check sample of $TOTAL rows = $K drawn + 2 fixed (E-SAGE-007, E-AI-053). Pool: $N S1 rows without \"snippet only\"; K = 20% rounded up, minimum 5. SEED=$SEED_USED ($SEED_NOTE)"
    printf '    %s\n' "ID | Claim (first 120 chars) | Source URL | Strength/Status"
    { cat "$T/sample.u"; printf '%s\n' E-SAGE-007 E-AI-053; } | awk '!seen[$0]++' > "$T/sample.rows"
    while read -r id; do
      mark=""
      case " $FIXED_IDS " in *" $id "*) mark=" [FIXED]" ;; esac
      ID="$id" MARK="$mark" awk -F'|' "$TRIM"'
        t($2)==ENVIRON["ID"] {
          c=t($4); if (length(c)>120) c=substr(c,1,120) "..."
          u=$7; if (match(u, /https?:\/\/[^ )>\]|;,"]+/)) u=substr(u,RSTART,RLENGTH); else u=t($7)
          sub(/[.:]+$/, "", u)
          print "    " ENVIRON["ID"] ENVIRON["MARK"] " | " c " | " u " | " t($11) "/" t($6); found=1
        }
        END { if (!found) print "    " ENVIRON["ID"] ENVIRON["MARK"] " | (not in ledger - note it) | |" }' "$T/ledger.rows"
    done < "$T/sample.rows"
  fi
else
  emit SKIP S-01 "ledger unavailable, no sample drawn"
fi

# ---------------------------------------------------------------- totals
echo
printf 'Totals: %s PASS, %s FAIL, %s SKIP, %s INFO\n' "$PASS_N" "$FAIL_N" "$SKIP_N" "$INFO_N"
if [ "$FAIL_N" -gt 0 ]; then
  echo "RESULT: NOT CLEAN - fix the FAIL items (see TEST-PLAN.md)"
  exit 1
fi
echo "RESULT: all script checks pass. Still do the S-01 spot check and the manual checklist."
exit 0
