library(data.table)
library(coloc)

dir.create("results/coloc", recursive = TRUE, showWarnings = FALSE)

x <- fread("data/ref/SORT1_eqtl_CAD_strict_harmonized.tsv")

d_eqtl <- list(
  beta = x$b,
  varbeta = x$SE^2,
  snp = x$SNP,
  position = x$BP,
  type = "quant",
  sdY = 1
)

d_cad <- list(
  beta = x$beta_gwas_aligned,
  varbeta = x$standard_error^2,
  snp = x$SNP,
  position = x$BP,
  type = "cc",
  s = 181522 / 1165690
)

check_dataset(d_eqtl)
check_dataset(d_cad)
res <- coloc.abf(dataset1 = d_eqtl, dataset2 = d_cad)

cat("\n===== COLOC SUMMARY =====\n")
print(res$summary)

summary_dt <- data.table(
  metric = names(res$summary),
  value = as.numeric(res$summary)
)
fwrite(summary_dt, "results/coloc/SORT1_Liver_CAD_coloc_summary.tsv", sep = "\t")

# Full per-SNP output is generated locally but ignored by .gitignore.
fwrite(
  as.data.table(res$results),
  "results/coloc/SORT1_Liver_CAD_coloc_snps.tsv",
  sep = "\t"
)
