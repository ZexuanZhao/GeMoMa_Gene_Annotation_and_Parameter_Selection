# GeMoMa gene prediction pipeline
A snakemake pipeline to predict gene structure using GeMoMa. GeMoMa will integrate annotations from multiple species.

# Files to prepare:
- `database.csv`: store reference genome assemblies and annotations with 3 columns:
  - `Species`: species name. Only letters and underscores are allowed in the name!
  - `Genome`: path to genome assembly
  - `GFF`: path to genome annotation gff file
- config.yaml: running parameters:
  - `database`: path to `database.csv`
  - `genome`: path to the genome assembly to be annotated
  - `outdir`: path to output directory.
  - `cpu`: number of threads to run the pipeline
  - `mem`: mamximum memory given to the pipeline
  
# Usage:

```
snakemake --cores [cpu] --use-conda
```

# Author:
Kevin Quinteros: <kquinter@umd.edu>
Zexuan Zhao: <zzhao127@umd.edu>
