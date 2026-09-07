library(data.table)

# PUBLIC RECONSTRUCTED VERSION
# The original analysis used a one-off calculation block that was not included
# in the uploaded review archive. This reproduces the recorded Wald-ratio result.

x <- fread("data/ref/SORT1_eqtl_CAD_strict_harmonized.tsv")
d <- x[SNP == "rs12740374"]
stopifnot(nrow(d) == 1)

bx <- d$b
sex <- d$SE
by <- d$beta_gwas_aligned
sey <- d$standard_error

beta_mr <- by / bx
se_mr <- sqrt(sey^2 / bx^2 + (by^2 * sex^2) / bx^4)
z_mr <- beta_mr / se_mr
p_mr <- 2 * pnorm(-abs(z_mr))

or_mr <- exp(beta_mr)
ci_lo <- exp(beta_mr - 1.96 * se_mr)
ci_hi <- exp(beta_mr + 1.96 * se_mr)
f_stat <- (bx / sex)^2

out <- data.table(
  SNP = d$SNP,
  effect_allele = d$A1,
  exposure_beta = bx,
  exposure_SE = sex,
  outcome_beta = by,
  outcome_SE = sey,
  F_statistic = f_stat,
  Wald_beta = beta_mr,
  Wald_SE = se_mr,
  Wald_z = z_mr,
  Wald_P = p_mr,
  Wald_OR = or_mr,
  Wald_CI95_low = ci_lo,
  Wald_CI95_high = ci_hi
)

print(out)
dir.create("results/generated", recursive = TRUE, showWarnings = FALSE)
fwrite(out, "results/generated/SORT1_Wald_ratio.tsv", sep = "\t")
