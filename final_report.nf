//module 5: process to generate the final report wth sample identifier and tumor fraction in a .tsv

process FINAL_REPORT {
  tag "final"
  publishDir "results", mode: 'copy'

  input:
  path ichor_files   // we don't use the var; it just stages the files here

  output:
  path "tumor_fraction_report.tsv"

  shell: '''
  set -euo pipefail
  printf "sample_identifier\ttumor_fraction\n" > tumor_fraction_report.tsv

  shopt -s nullglob
  for f in *.params.txt *_params*.txt; do
    # take 2nd line, keep 1st two TAB-separated columns
    sed -n '2p' "$f" | cut -f1,2 >> tumor_fraction_report.tsv || true
  done
  '''
}

