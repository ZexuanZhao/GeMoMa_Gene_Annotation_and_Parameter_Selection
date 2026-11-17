# Gene annotation and parameter evaluation with GeMoMa

A Snakemake workflow for homology-based gene annotation using multiple reference species and BUSCO evaluation across GeMoMa Annotation Filter (GAF) `score/aa` thresholds. RNA-seq evidence is optional.

Used in the study below; see the [main project repository](https://github.com/ZexuanZhao/Pegoscapus-hoffmeyeri-sp.A-genome-paper) for other analyses.

## Setup

Requires Snakemake and Conda. Tool dependencies are specified in [gemoma.yaml](gemoma.yaml).

1. Prepare `database.csv` with the header `Species,Genome,GFF` and one reference species per row. Use only letters and underscores in species names.
2. Edit [config.yaml](config.yaml):
   - `database`, `genome`: reference table and target genome FASTA.
   - `mapped_reads`: mapped RNA-seq BAM; use `""` if unused.
   - `busco_lineage`, `outdir`: BUSCO lineage and output directory.
   - `ratios`: GAF score/aa thresholds to evaluate.
   - `cpu`, `mem`: thread count and Java memory limit.

## Run

Run from the repository root, replacing `48` with your available CPU count:

```bash
snakemake --cores 48 --use-conda
```

## Outputs and parameter selection

Within `outdir`:

- `final_annotation.gff`: initial GeMoMa annotation.
- `ratio_<r>/final_annotation.gff` and `proteins.fasta`: annotation and proteins for each threshold.
- `busco/first/` and `busco/ratio_<r>/`: BUSCO evaluations.

Compare the BUSCO summaries and select the desired threshold manually. In the published study, thresholds ranged from 0.8 to 2.0 in steps of 0.1, and 1.5 was selected. The example configuration currently uses 1.1–1.7.

## Citation

Zhao Z, Quinteros K, Machado CA. (2025). **Evolutionary Consequences of Unusually Large Pericentric TE-rich Regions in the Genome of a Neotropical Fig Wasp.** *Genome Biology and Evolution* 17(9): evaf158. https://doi.org/10.1093/gbe/evaf158

Please also cite GeMoMa and BUSCO when using this workflow.

## Authors

Kevin Quinteros (<kquinter@umd.edu>) and Zexuan Zhao (<zzhao127@umd.edu>).
