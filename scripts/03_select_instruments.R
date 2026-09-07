library(data.table)

dir.create("data/ref", recursive = TRUE, showWarnings = FALSE)

x <- fread("data/ref/SORT1_eqtl_CAD_strict_harmonized.tsv")

strong <- x[p < 5e-8, .(
  SNP,
  P = p,
  beta = b,
  SE = SE,
  F = (b / SE)^2
)]
setorder(strong, P)

fwrite(strong, "data/ref/SORT1_strong_eqtl.tsv", sep = "\t")
fwrite(strong[, .(SNP)], "data/ref/SORT1_strong_eqtl.ids",
       sep = "\t", col.names = FALSE)

fwrite(unique(x[, .(SNP)]), "data/ref/SORT1_all_harmonized_snps.ids",
       sep = "\t", col.names = FALSE)

cat("Strong cis-eQTL:", nrow(strong), "\n")
print(strong)
