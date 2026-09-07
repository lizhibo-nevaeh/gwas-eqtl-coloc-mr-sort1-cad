#!/usr/bin/env bash
set -euo pipefail

# PUBLIC RECONSTRUCTED VERSION
# The original analysis used one-off commands that were not included in the
# uploaded review archive. This script reconstructs the equivalent preparation
# steps from the recorded command history.

: "${SMR:?Set SMR to the SMR executable, e.g. /path/to/smr}"
: "${GTEX_LIVER_PREFIX:?Set GTEX_LIVER_PREFIX to the BESD prefix, e.g. /path/to/Liver}"
: "${CAD_GWAS_GRCH37:?Set CAD_GWAS_GRCH37 to the downloaded GCST90132314 GRCh37 TSV}"

mkdir -p data/eqtl data/gwas

# Extract SORT1 cis-eQTL summary statistics from GTEx v8 Liver BESD.
"$SMR" \
  --beqtl-summary "$GTEX_LIVER_PREFIX" \
  --query 1 \
  --probe ENSG00000134243 \
  --out data/eqtl/SORT1_GTExV8_Liver

# Extract the SORT1 region from the CAD GWAS summary-statistics file.
awk -F'\t' 'NR==1 || ($2==1 && $3>=108961428 && $3<=110940197)' \
  "$CAD_GWAS_GRCH37" \
  > data/gwas/SORT1_CAD_GRCh37.tsv

printf 'Prepared:\n  data/eqtl/SORT1_GTExV8_Liver.txt\n  data/gwas/SORT1_CAD_GRCh37.tsv\n'
