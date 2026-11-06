#!/usr/bin/env bash
# baseline-research-rows.sh - (re)write the frozen-row baseline that check L-15 in verify.sh compares against.
# TEST-PLAN.md gap G4.
#
# Usage:  bash baseline-research-rows.sh "<ruling>" [LEDGER]
#   <ruling>  the controller ruling that authorizes the change, e.g. "Ruling 52". Required: research rows may
#             change only through a ruling, so every re-baseline names one.
#   LEDGER    defaults to ../drafts/evidence-ledger.md, relative to this script.
#
# Update path (TEST-PLAN.md G4): when a ruling changes a research row, edit the row, run this script with that
# ruling in the same change, and commit the ledger and research-rows.sha256 together. The script prints the IDs
# whose hash changed, appeared or disappeared, and records them with the ruling in the baseline's history, so
# every listed ID can be matched to a ruling later.
#
# Output file: research-rows.sha256 (same folder). Lines starting with '#' are the history; every other line is
# "<ID> <sha256>", sorted by ID (LC_ALL=C).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 2
RULING="${1:-}"
LEDGER="${2:-$SCRIPT_DIR/../drafts/evidence-ledger.md}"
BASE="$SCRIPT_DIR/research-rows.sha256"

[ -n "$RULING" ] || { echo "usage: bash baseline-research-rows.sh \"<ruling>\" [LEDGER]   (a ruling is required)"; exit 2; }
awk --version 2>&1 | head -n 1 | grep -q '^GNU Awk' || { echo "GNU awk (gawk) is required"; exit 2; }
command -v sha256sum >/dev/null || { echo "sha256sum is required"; exit 2; }
[ -f "$LEDGER" ] || { echo "ledger not found: $LEDGER"; exit 2; }
# shellcheck source=research-rows.lib.sh
. "$SCRIPT_DIR/research-rows.lib.sh" || exit 2

T="$(mktemp -d)" || exit 2
trap 'rm -rf "$T"' EXIT

research_hashes "$LEDGER" > "$T/new" || { echo "hashing failed"; exit 2; }
N=$(wc -l < "$T/new")
[ "$N" -gt 0 ] || { echo "no research rows found in $LEDGER; refusing to write an empty baseline"; exit 2; }

if [ -f "$BASE" ]; then
  grep -v '^#' "$BASE" | LC_ALL=C sort > "$T/old"
  grep '^#' "$BASE" > "$T/history"
else
  : > "$T/old"
  printf '%s\n' \
    "# Frozen research-row baseline for check L-15 (TEST-PLAN.md G4). Do not edit by hand:" \
    "# run baseline-research-rows.sh \"<ruling>\" in the same change as the ruling's ledger edit." \
    "# History (date | ruling | rows | changed IDs):" > "$T/history"
fi

CHANGED=$(LC_ALL=C join "$T/old" "$T/new" | awk '$2!=$3{print $1}' | paste -sd' ' -)
ADDED=$(cut -d' ' -f1 "$T/new" | LC_ALL=C comm -13 <(cut -d' ' -f1 "$T/old") - | paste -sd' ' -)
REMOVED=$(cut -d' ' -f1 "$T/new" | LC_ALL=C comm -23 <(cut -d' ' -f1 "$T/old") - | paste -sd' ' -)

if [ -s "$T/old" ] && [ -z "$CHANGED$ADDED$REMOVED" ]; then
  echo "baseline already matches the ledger ($N research rows); nothing written"
  exit 0
fi

if [ -s "$T/old" ]; then
  DELTA="changed: ${CHANGED:-none}; added: ${ADDED:-none}; removed: ${REMOVED:-none}"
else
  DELTA="initial baseline"
fi
{
  cat "$T/history"
  printf '# %s | %s | %s | %s\n' "$(date +%Y-%m-%d)" "$RULING" "$N" "$DELTA"
  cat "$T/new"
} > "$T/out" && mv "$T/out" "$BASE" || { echo "could not write $BASE"; exit 2; }

echo "wrote $BASE: $N research rows under $RULING"
echo "  $DELTA"

# G11: every changed or removed row's citations need a manual re-review, because a cell can keep citing a row that no
# longer supports it (the E-SAGE-023 lesson of 2026-11-06). Print them now, while the ruling is being written.
REVIEW="$(printf '%s %s' "$CHANGED" "$REMOVED" | xargs)"
if [ -n "$REVIEW" ]; then
  echo
  echo "Re-review every citation below against the changed rows (verify.sh --impact):"
  # shellcheck disable=SC2086
  IMPACT_DIR="$(dirname "$LEDGER")" bash "$SCRIPT_DIR/verify.sh" --impact $REVIEW
fi
