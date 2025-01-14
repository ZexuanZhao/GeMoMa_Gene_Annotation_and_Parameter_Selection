# Gene Annotation and Parameter Selection Using GeMoMa

Main project repository is [here](https://github.com/ZexuanZhao/Pegoscapus-hoffmeyeri-sp.A-genome-paper/tree/main).

## Description:
 - Annotate genes using a customized  database of various genetic distances to the reference genome.
 - Measure the BUSCO completeness within a range of `score/aa` ratios.
 - RNAseq is optional.

## Files to prepare:
 - A database sheet:
   - Species: names of the species
   - Genome: path to the `.fasta` genome assembly files
   - GFF: path to the `.gff` annotation files
 - Modify configuration file - config.yaml:
   - database: path to the database sheet

## Environment:
 - An environmtnt with `snakemake` installed.

## Usage:
`snakemake --cores [cpu] --use-conda`
