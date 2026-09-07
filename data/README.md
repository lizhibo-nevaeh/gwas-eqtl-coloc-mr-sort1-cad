# Data inputs

Raw third-party datasets are intentionally **not included** in this repository.

The analysis expects the following local files after data acquisition/preparation:

```text
data/
├── eqtl/
│   └── SORT1_GTExV8_Liver.txt
├── gwas/
│   └── SORT1_CAD_GRCh37.tsv
└── ld_ref/
    └── 1000G_phase3_EUR_chr1/
        ├── SORT1_EUR_region.pgen
        ├── SORT1_EUR_region.pvar.zst
        └── SORT1_EUR_region.psam
```

## 1. GTEx v8 Liver cis-eQTL

Source: Yang Lab SMR data resources, GTEx v8 cis-eQTL summary data in BESD format.

- SMR software/data page: https://yanglab.westlake.edu.cn/software/smr
- GTEx v8 cis-eQTL data table: https://yanglab.westlake.edu.cn/data/SMR/GTEx_V8_cis_eqtl_summary.html

The project used the Liver BESD prefix and SMR 1.4.2 to query:

```text
ENSG00000134243 (SORT1)
```

The resulting extracted text file is expected at:

```text
data/eqtl/SORT1_GTExV8_Liver.txt
```

## 2. Coronary artery disease GWAS

GWAS Catalog accession:

```text
GCST90132314
```

Study page:

https://www.ebi.ac.uk/gwas/studies/GCST90132314

Publication:

Aragam KG et al. *Discovery and systematic characterization of risk variants and genes for coronary artery disease in over a million participants.* Nature Genetics (2022). DOI: 10.1038/s41588-022-01233-6

This project used the GRCh37 summary-statistics file and extracted the SORT1 region:

```text
chr1:108,961,428-110,940,197
```

The regional file is expected at:

```text
data/gwas/SORT1_CAD_GRCh37.tsv
```

## 3. LD reference

PLINK2 currently provides 1000 Genomes Phase 3 resources, including GRCh37 chromosome-specific datasets:

https://www.cog-genomics.org/plink/2.0/resources

The project used chromosome 1, retained `SuperPop == EUR`, and restricted to the SORT1 region. The PLINK2 resource is distributed with a compressed `.pgen.zst`; prepare a local PLINK2 prefix before running the LD script. For the no-annotation chromosome-1 files used in this project, the equivalent setup is:

```bash
plink2 --zst-decompress chr1_phase3.pgen.zst chr1_phase3.pgen
mv chr1_phase3_noannot.pvar.zst chr1_phase3.pvar.zst
ln -s phase3_corrected.psam chr1_phase3.psam
```

Then set `PHASE3_CHR1_PREFIX` to the prepared `chr1_phase3` prefix. The final regional LD prefix created by the workflow is:

```text
data/ld_ref/1000G_phase3_EUR_chr1/SORT1_EUR_region
```

with 503 European-ancestry samples.

## Redistribution note

This repository intentionally avoids redistributing raw GTEx, CAD GWAS, or 1000 Genomes data. Obtain each dataset from its original provider and follow the provider's terms of use.
