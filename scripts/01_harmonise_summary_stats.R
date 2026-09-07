library(data.table)

dir.create("data/ref", recursive = TRUE, showWarnings = FALSE)

eqtl <- fread("data/eqtl/SORT1_GTExV8_Liver.txt")
gwas <- fread("data/gwas/SORT1_CAD_GRCh37.tsv")

eqtl[, `:=`(A1 = toupper(A1), A2 = toupper(A2))]
gwas[, `:=`(
  effect_allele = toupper(effect_allele),
  other_allele = toupper(other_allele)
)]

m <- merge(
  eqtl, gwas,
  by.x = c("Chr", "BP"),
  by.y = c("chromosome", "base_pair_location")
)

m[, allele_status :=
  fifelse(A1 == effect_allele & A2 == other_allele, "direct",
  fifelse(A1 == other_allele & A2 == effect_allele, "swapped", "other"))
]

clean <- m[allele_status != "other"]
clean[, beta_gwas_aligned :=
  fifelse(allele_status == "direct", beta, -beta)
]

cat("eQTL records:", nrow(eqtl), "\n")
cat("CAD regional records:", nrow(gwas), "\n")
cat("Position overlap:", nrow(m), "\n\n")
print(m[, .N, by = allele_status][order(-N)])
cat("\nStrict harmonised:", nrow(clean), "\n")

fwrite(
  clean,
  "data/ref/SORT1_eqtl_CAD_strict_harmonized.tsv",
  sep = "\t"
)
