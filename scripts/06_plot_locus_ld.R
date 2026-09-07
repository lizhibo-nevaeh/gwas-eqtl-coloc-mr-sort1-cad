library(data.table)
library(ggplot2)

x <- fread("data/ref/SORT1_eqtl_CAD_strict_harmonized.tsv")
ld <- fread("data/ld_ref/1000G_phase3_EUR_chr1/rs12740374_vs_all_harmonized.vcor")

ld <- ld[, .(SNP = ID_B, LD_r2 = PHASED_R2)]
x <- merge(x, ld, by = "SNP", all.x = TRUE)
x[SNP == "rs12740374", LD_r2 := 1]

x[, LD_group :=
  fifelse(SNP == "rs12740374", "Lead: rs12740374",
  fifelse(is.na(LD_r2), "No LD estimate",
  fifelse(LD_r2 >= 0.8, "r² ≥ 0.8",
  fifelse(LD_r2 >= 0.6, "0.6 ≤ r² < 0.8",
  fifelse(LD_r2 >= 0.4, "0.4 ≤ r² < 0.6",
  fifelse(LD_r2 >= 0.2, "0.2 ≤ r² < 0.4", "r² < 0.2"))))))
]

eqtl <- x[, .(SNP, BP, LD_group, trait = "SORT1 Liver eQTL", logP = -log10(p))]
cad <- x[, .(SNP, BP, LD_group, trait = "CAD GWAS", logP = -log10(p_value))]
d <- rbind(eqtl, cad)
d[, position_mb := BP / 1e6]

p <- ggplot(d, aes(position_mb, logP, color = LD_group)) +
  geom_point(size = 1.3, alpha = 0.75) +
  geom_vline(xintercept = 109817590 / 1e6, linetype = "dashed") +
  facet_wrap(~trait, ncol = 1, scales = "free_y") +
  labs(
    x = "Chromosome 1 position (Mb, GRCh37)",
    y = "-log10(P)",
    color = "LD with rs12740374",
    title = "SORT1 liver eQTL and CAD association signals",
    subtitle = "Variants colored by European-ancestry LD with rs12740374"
  ) +
  theme_bw(base_size = 12) +
  theme(legend.position = "right")

dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)
ggsave("results/figures/SORT1_Liver_CAD_locus_LD.png", p,
       width = 10, height = 7, dpi = 300)

cat("Variants:", nrow(x), "\n")
print(x[, .N, by = LD_group][order(-N)])
