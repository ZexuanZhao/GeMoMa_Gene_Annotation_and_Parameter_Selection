## Util function
def generate_db_params(db):
    parameters=""
    species = db.index
    for s in species:
        parameters+= "s=own" + " "
        parameters+= "i=" + s + " "
        parameters+= "a=" + db.loc[s, "GFF"] + " "
        parameters+= "g=" + db.loc[s, "Genome"] + " "
    return parameters

def generate_rna_params(mapped_reads):
    parameters=""
    if mapped_reads == "":
        return parameters
    parameters+="r=MAPPED" + " "
    parameters+="ERE.s=FR_FIRST_STRAND" + " "
    parameters+="ERE.m=" + mapped_reads + " "
    return parameters

def generate_gaf_params(db):
    parameters=""
    for index in range(db.shape[0]):
        parameters += "g="
        parameters += os.path.join(config["outdir"], "unfiltered_predictions_from_species_{d}.gff".format(d = index))
        parameters += " "
    return parameters
