## Snakemake 
##
## @Kevin Quinteros
##
from snakemake.utils import validate
import pandas as pd
import os

##--- Importing Configuration Files ---##
configfile: 'config.yaml'

##--- Read database file
db=pd.read_csv(config["database"]).set_index("Species", drop = False)

##--- Validate database table ---##
validate(db, schema="database.yaml")

include: "rules/utils.smk"
include: "rules/GeMoMa_pipeline.smk"
include: "rules/GAF_tuning.smk"

rule all:
    input:
        os.path.join(config["outdir"],"final_annotation.gff"),
        os.path.join(config["outdir"],"busco", "first", "short_summary.specific."+ config["busco_lineage"] + ".first.txt"),
        expand(os.path.join(config["outdir"],"busco", "ratio_{r}", "short_summary.specific."+ config["busco_lineage"] + ".ratio_{r}.txt"), r = config["ratios"])

