#!/usr/bin/env bash
set -euo pipefail

# PUBLIC RECONSTRUCTED VERSION
# Equivalent to the PLINK2 command sequence used in the completed analysis.

: "${PLINK2:?Set PLINK2 to the PLINK2 executable}"
: "${PHASE3_CHR1_PREFIX:?Set PHASE3_CHR1_PREFIX to chr1_phase3 (with .pgen, .pvar.zst, .psam)}"

LD_DIR="data/ld_ref/1000G_phase3_EUR_chr1"
REGION_PREFIX="$LD_DIR/SORT1_EUR_region"
mkdir -p "$LD_DIR" results/generated

# 1) Build the EUR SORT1 regional reference panel.
"$PLINK2" \
  --pfile "$PHASE3_CHR1_PREFIX" vzs \
  --keep-if 'SuperPop==EUR' \
  --chr 1 \
  --from-bp 108961428 \
  --to-bp 110940197 \
  --make-pgen vzs \
  --out "$REGION_PREFIX"

# 2) Extract all harmonised SNP IDs present in the reference panel.
"$PLINK2" \
  --pfile "$REGION_PREFIX" vzs \
  --extract data/ref/SORT1_all_harmonized_snps.ids \
  --make-pgen vzs \
  --out "$LD_DIR/SORT1_all_harmonized_in_EUR"

# 3) Compute phased r^2 between the lead SNP and biallelic harmonised variants.
"$PLINK2" \
  --pfile "$LD_DIR/SORT1_all_harmonized_in_EUR" vzs \
  --max-alleles 2 \
  --ld-snp rs12740374 \
  --r2-phased \
  --ld-window-kb 2000 \
  --ld-window-r2 0 \
  --out "$LD_DIR/rs12740374_vs_all_harmonized"

# 4) Strict clumping among strong cis-eQTL variants.
"$PLINK2" \
  --pfile "$REGION_PREFIX" vzs \
  --clump data/ref/SORT1_strong_eqtl.tsv \
  --clump-p1 5e-8 \
  --clump-p2 5e-8 \
  --clump-r2 0.01 \
  --clump-kb 10000 \
  --out results/generated/SORT1_eqtl_r2_001

printf 'Expected independent lead instrument: rs12740374\n'
