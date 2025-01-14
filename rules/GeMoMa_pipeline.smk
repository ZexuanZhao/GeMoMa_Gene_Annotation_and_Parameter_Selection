rule run_GeMoMaPipeline:
    input:
        db["Genome"].tolist(),
        db["GFF"].tolist(),
        genome=config["genome"],
        mapped_reads=config["mapped_reads"]
    output:
        os.path.join(config["outdir"],"final_annotation.gff"),
        os.path.join(config["outdir"],"predicted_proteins.fasta"),
        expand(os.path.join(config["outdir"],"unfiltered_predictions_from_species_{d}.gff"),
            d = range(db.shape[0]))
    threads:
        config["cpu"]
    params:
        mem = config["mem"],
        out_dir = config["outdir"],
        ref_opts = generate_db_params(db),
        rna_opts = generate_rna_params(config["mapped_reads"])
    log:
        os.path.join(config["outdir"],"logs","GeMoMa_pipeline.log")
    conda:
        os.path.join(workflow.basedir, "gemoma.yaml")
    shell:
        """
            GeMoMa GeMoMaPipeline \
                -Xmx{params.mem} \
                threads={threads} \
                t={input.genome} \
                outdir={params.out_dir} \
                {params.ref_opts} \
                {params.rna_opts} \
                o=true \
                Extractor.r=true \
                GeMoMa.sil=false \
                AnnotationFinalizer.r=NO \
                >{log} 2>{log}
            rm -rf GeMoMa_temp
        """
## Parameter comments:
    ## o - output individual predictions (If *true*, returns the predictions for each reference species, default = false)
    ## Extractor.r: repair (if a transcript annotation can not be parsed, the program will try to infer the phase of the CDS parts to repair the annotation, default = false)
    ## GeMoMa.sil: set intron length to be dynamic
    ## AnnotationFinalizer.r - rename (allows to generate generic gene and transcripts names (cf. parameter &quot;name attribute&quot;), range={COMPOSED, SIMPLE, NO}, default = COMPOSED)

rule busco:
    input:
        os.path.join(config["outdir"],"predicted_proteins.fasta")
    params:
        lineage = config["busco_lineage"],
        out_dir = os.path.join(config["outdir"],"busco")
    output:
        os.path.join(config["outdir"],"busco", "first", "short_summary.specific."+ config["busco_lineage"] + ".first.txt")
    threads:
        config["cpu"]
    conda:
        os.path.join(workflow.basedir,"gemoma.yaml")
    shell:
        """
        busco -i {input} \
            -l {params.lineage} \
            -o first \
            --out_path {params.out_dir} \
            --download_path {params.out_dir} \
            -m proteins \
            -c {threads} \
            -f

        """

rule busco_recomputer:
    input:
        b = os.path.join(config["outdir"],"busco", "first", "run_"+ config["busco_lineage"], "full_table.tsv"),
        i = os.path.join(config["outdir"], "reference_gene_table.tabular")
    output:
        os.path.join(config["outdir"],"busco", "recomputed.txt")
    params:
        out_dir = os.path.join(config["outdir"],"busco")
    conda:
        os.path.join(workflow.basedir,"gemoma.yaml")
    shell:
        """
        GeMoMa BUSCORecomputer \
            b={input.b} \
            i={input.i} \
            outdir={params.out_dir}
        """
