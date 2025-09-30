#!/usr/bin/env bash
# check_passwords.sh
# Usage: ./check_passwords.sh [-i input_file] [-o output_file] [-m]
#   -i input_file   (default: passwords_plain.txt)
#   -o output_file  (default: results.txt)
#   -m              mask passwords in the output (show only first 2 and last 2 chars)

set -euo pipefail

INPUT_FILE="passwords_plain.txt"
OUTPUT_FILE="results.txt"
MASK=0

while getopts ":i:o:m" opt; do
  case "$opt" in
    i) INPUT_FILE="$OPTARG" ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    m) MASK=1 ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
  esac
done

# header
printf '# Results generated: %s\n' "$(date -u +"%Y-%m-%d %H:%M:%SZ")" > "$OUTPUT_FILE"
printf '# Input: %s\n\n' "$INPUT_FILE" >> "$OUTPUT_FILE"

mask_pw() {
  local pw="$1"
  # remove CR if present
  pw=${pw%$'\r'}
  local len=${#pw}
  if [ "$len" -le 4 ]; then
    printf '%s' "$(printf '%*s' "$len" '' | tr ' ' '*')"
  else
    local first=${pw:0:2}
    local last=${pw: -2}
    local mid_len=$((len-4))
    printf '%s' "$first"
    printf '%*s' "$mid_len" '' | tr ' ' '*'
    printf '%s' "$last"
  fi
}

# Read file line-by-line (preserves spaces) and skip comments/blank lines
while IFS= read -r line || [ -n "$line" ]; do
  # strip CR
  line=${line%$'\r'}
  # skip comments and empty lines
  case "$line" in
    ""|#*) continue ;;
  esac

  pw="$line"

  # run cracklib-check non-interactively; printf avoids echo builtin differences
  result=$(printf '%s\n' "$pw" | cracklib-check 2>&1) || true
  rc=$?

  if [ "$MASK" -eq 1 ]; then
    display_pw=$(mask_pw "$pw")
  else
    display_pw="$pw"
  fi

  # Normalize result if cracklib-check prints to stdout/stderr
  # If cracklib-check returns 0 (accepted) it may print nothing; mark as OK
  if [ $rc -eq 0 ]; then
    out="OK"
  else
    # trim trailing newlines
    out=$(printf '%s' "$result")
  fi

  # Write to output file and to stdout
  printf '%s: %s\n' "$display_pw" "$out" | tee -a "$OUTPUT_FILE"

done < "$INPUT_FILE"

printf '\n# Completed: %s\n' "$(date -u +"%Y-%m-%d %H:%M:%SZ")" >> "$OUTPUT_FILE"

exit 0
