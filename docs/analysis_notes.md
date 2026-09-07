# Analysis notes

These notes record the main checkpoints from the completed learning analysis.

## Harmonisation checkpoints

- SORT1 Liver cis-eQTL records extracted: **5,661**
- CAD regional records: **13,041**
- Position-overlapping records: **5,183**
- Direct allele matches: **2,917**
- Swapped allele matches: **2,250**
- Incompatible (`other`) records: **16**
- Strict harmonised set: **5,167**

## Colocalisation

- Variants analysed: **5,167**
- PP.H4: **0.9998312**
- PP.H3: **~0.0001688**
- rs12740374 SNP.PP.H4: **0.9999925**

## Strong eQTL / LD checkpoints

- Strong cis-eQTL (`P < 5e-8`): **25**
- Present in the 1000 Genomes EUR regional panel: **24**
- Missing strong variant: `rs3832016`
- LD clumping (`r² = 0.01`, 10 Mb): **1 independent instrument**
- Independent instrument: `rs12740374`

For the regional LD plot (all harmonised variants):

- Harmonised SNP IDs: 5,167
- Present in EUR reference: 5,147
- Biallelic variants retained for phased r²: 5,117
- Pairwise r² values returned against rs12740374: 4,934 (excluding header/self)
- `No LD estimate` in the final merged plot: 232

LD-group counts used in the plotted dataset:

| LD group | N |
|---|---:|
| r² < 0.2 | 4,904 |
| No LD estimate | 232 |
| 0.2 ≤ r² < 0.4 | 16 |
| r² ≥ 0.8 | 8 |
| 0.4 ≤ r² < 0.6 | 5 |
| Lead: rs12740374 | 1 |
| 0.6 ≤ r² < 0.8 | 1 |

## Wald-ratio MR

For rs12740374 (T allele):

- exposure beta: 1.27256
- exposure SE: 0.0820609
- outcome beta (aligned): -0.09548326
- outcome SE: 0.005969089
- F-statistic: 240.4828
- Wald beta: -0.07503242
- Wald SE: 0.006738883
- Wald OR: 0.9277134
- 95% CI: 0.9155405-0.9400048
- P: 8.545934e-29

## Reconstructed scripts

The uploaded review archive contained the final R scripts for harmonisation, coloc and plotting, but did **not** contain the original one-off shell blocks used for input preparation / PLINK LD steps, nor the one-off Wald-ratio calculation block.

Therefore:

- `scripts/00_prepare_inputs.sh`
- `scripts/04_ld_analysis_and_clumping.sh`
- `scripts/05_wald_ratio.R`

are **public reconstructed versions based on the executed command history and recorded outputs**, not claims of byte-for-byte recovery of an original script file.
