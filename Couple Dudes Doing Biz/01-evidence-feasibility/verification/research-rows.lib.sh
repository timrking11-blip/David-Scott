# research-rows.lib.sh - shared by verify.sh (check L-15) and baseline-research-rows.sh (TEST-PLAN.md gap G4).
# Source it; do not run it. Both scripts must use this one definition of "research row" and of the row hash,
# so the baseline and the check can never disagree.
#
# A research row is a well-formed ledger row (15 columns, NF==17 split on '|') whose ID starts E- and whose
# Source type ($8) is NOT "stakeholder" or "analyst inference" (case-insensitive, NBSP/tab folded). This is the
# same exemption as Ruling 51 (function ex() in verify.sh).
#
# The hash is sha256 of the whole row line exactly as written, after CR is stripped. Any edit to any cell,
# including whitespace, changes it. Needs GNU awk and sha256sum (both present in Git Bash).

RR_AWK='function n(s){gsub(/\302\240|\342\200\257|\t/," ",s);gsub(/ +/," ",s);return s}
function t(s){s=n(s);gsub(/^ +| +$/,"",s);return s}
function ex(s){return tolower(t(s)) ~ /^(stakeholder|analyst inference)$/}
NF==17 && t($2) ~ /^E-[A-Z]+-[0-9]+$/ && !ex($8) {print t($2) "\t" $0}'

# research_hashes LEDGER  ->  "ID sha256" per research row, sorted by ID (LC_ALL=C). Exit 1 if awk or sha256sum fails.
research_hashes() {
  local ledger="$1" id row h
  local rows; rows="$(tr -d '\r' < "$ledger" | awk -F'|' "$RR_AWK")" || return 1
  [ -n "$rows" ] || return 0
  while IFS=$'\t' read -r id row; do
    h="$(printf '%s\n' "$row" | sha256sum)" || return 1
    printf '%s %s\n' "$id" "${h%% *}"
  done <<< "$rows" | LC_ALL=C sort
  return "${PIPESTATUS[0]}"
}
