# Gene Annotation and Parameter Selection Using GeMoMa

Main project repository is [here](https://github.com/ZexuanZhao/Pegoscapus-hoffmeyeri-sp.A-genome-paper/tree/main).

# Description:
 - Annotate genes using a customized  database of various genetic distances to the reference genome.
 - Measure the BUSCO completeness within a range of `score/aa` ratios.
 - RNAseq is optional.

# Files to prepare:
- `database.csv`: store reference genome assemblies and annotations with 3 columns:
  - `Species`: species name. Only letters and underscores are allowed in the name!
  - `Genome`: path to genome assembly
  - `GFF`: path to genome annotation gff file
- config.yaml: running parameters:
  - `database`: path to `database.csv`
  - `genome`: path to the genome assembly to be annotated
  - `mapped_reads`: path to the `bam` file of RNAseq mapped to the genome assembly
  - `busco_lineage`: busco lineage that should be used to evaluate completeness
  - `outdir`: path to output directory
  - `ratios`: a list of `score/aa` ratios to be evaluated
  - `cpu`: number of threads to run the pipeline
  - `mem`: mamximum memory given to the pipeline

# Environment:
 - An environmtnt with `snakemake` installed.

# Usage:

```
snakemake --cores [cpu] --use-conda
```

# Author:
Kevin Quinteros: <kquinter@umd.edu>
Zexuan Zhao: <zzhao127@umd.edu>

