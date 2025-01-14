rule gaf:
    input:
        expand(os.path.join(config["outdir"],"unfiltered_predictions_from_species_{d}.gff"),
            d = range(db.shape[0]))
    output:
        os.path.join(config["outdir"], "ratio_{r}", "filtered_predictions.gff")
    params:
        opts = generate_gaf_params(db),
        out_dir = os.path.join(config["outdir"], "ratio_{r}")
    conda:
        os.path.join(workflow.basedir,"gemoma.yaml")
    shell:
        """
        GeMoMa GAF \
            {params.opts} \
            f="start=='M' and stop=='*' and (isNaN(score) or score/aa>={wildcards.r})" \
            outdir={params.out_dir}
        """

rule finalizer:
    input:
        g = config["genome"],
        filtered_annotation = os.path.join(config["outdir"], "ratio_{r}", "filtered_predictions.gff")
    output:
        os.path.join(config["outdir"],"ratio_{r}", "final_annotation.gff")
    params:
        out_dir=os.path.join(config["outdir"],"ratio_{r}")
    conda:
        os.path.join(workflow.basedir,"gemoma.yaml")
    shell:
        """
        GeMoMa AnnotationFinalizer \
            g={input.g} \
            a={input.filtered_annotation} \
            rename=NO \
            outdir={params.out_dir}
        """
rule extract_protein:
    input:
        g = config["genome"],
        final_annotation = os.path.join(config["outdir"],"ratio_{r}","final_annotation.gff")
    output:
        os.path.join(config["outdir"],"ratio_{r}", "proteins.fasta")
    params:
        out_dir=os.path.join(config["outdir"],"ratio_{r}")
    conda:
        os.path.join(workflow.basedir,"gemoma.yaml")
    shell:
        """
        GeMoMa Extractor \
            a={input.final_annotation} \
            g={input.g} \
            p=true \
            outdir={params.out_dir}
        """

rule busco_ratio:
    input:
        os.path.join(config["outdir"],"ratio_{r}", "proteins.fasta")
    params:
        lineage = config["busco_lineage"],
        out_dir = os.path.join(config["outdir"],"busco")
    output:
        os.path.join(config["outdir"],"busco", "ratio_{r}", "short_summary.specific."+ config["busco_lineage"] + ".ratio_{r}.txt")
    threads:
        config["cpu"]
    conda:
        os.path.join(workflow.basedir,"gemoma.yaml")
    shell:
        """
        busco -i {input} \
            -l {params.lineage} \
            -o ratio_{wildcards.r} \
            --out_path {params.out_dir} \
            --download_path {params.out_dir} \
            -m proteins \
            -c {threads} \
            -f 
            
        """