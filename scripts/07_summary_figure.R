library(ggplot2)

p <- ggplot() +
  xlim(0, 12) + ylim(0, 7) + theme_void() +
  annotate("label", x = 2, y = 4.5,
           label = "rs12740374\nT allele", size = 5, linewidth = 0.7) +
  annotate("label", x = 6, y = 4.5,
           label = "SORT1\nLiver expression", size = 5, linewidth = 0.7) +
  annotate("label", x = 10, y = 4.5,
           label = "Coronary artery\ndisease", size = 5, linewidth = 0.7) +
  annotate("segment", x = 3.1, xend = 4.8, y = 4.5, yend = 4.5,
           arrow = arrow(length = unit(0.25, "cm"))) +
  annotate("segment", x = 7.2, xend = 8.8, y = 4.5, yend = 4.5,
           arrow = arrow(length = unit(0.25, "cm"))) +
  annotate("text", x = 4, y = 5.3,
           label = "cis-eQTL", fontface = "bold", size = 4.5) +
  annotate("text", x = 4, y = 3.55,
           label = "beta = +1.273\nP = 3.09e-54\nF = 240.5", size = 4) +
  annotate("text", x = 8, y = 5.35,
           label = "Wald ratio MR", fontface = "bold", size = 4.5) +
  annotate("text", x = 8, y = 3.85,
           label = "Colocalisation\nPP.H4 = 0.9998\nLead-variant posterior = 0.9999925", size = 3.8) +
  annotate("text", x = 8, y = 2.9,
           label = "Wald MR OR = 0.928\n95% CI = 0.916-0.940", size = 4) +
  annotate("text", x = 6, y = 6.4,
           label = "SORT1 liver expression and coronary artery disease",
           fontface = "bold", size = 6) +
  annotate("text", x = 6, y = 1.2,
           label = "Strong colocalisation + directionally consistent single-instrument MR",
           fontface = "bold", size = 4.4) +
  annotate("text", x = 6, y = 0.55,
           label = "Learning case study; genetic evidence supports a shared signal but does not prove causality.",
           size = 3.7)

dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)
ggsave("results/figures/SORT1_CAD_summary.png", p,
       width = 11, height = 6, dpi = 300, bg = "white")
