rule make_config:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        path_to_script= workflow.current_basedir,
        outdir=config["output_path"] + "taxids/barcode_{barcode}",
        min_length=config["min_length"],
        max_length=config["max_length"],
        min_count=config["min_count"],
    output:
        config["output_path"] + "taxids/barcode_{barcode}/config.yaml"
    shell:
        """
        mkdir -p {params.outdir}
        echo "output_path: {params.outdir}" >> {params.outdir}/config.yaml
        echo "min_length: {params.min_length}" >> {params.outdir}/config.yaml
        echo "max_length: {params.max_length}" >> {params.outdir}/config.yaml

        taxids=$(python3 {params.path_to_script}/filter_by_count.py \
            --indir {input} \
            --min_count {params.min_count})
        python3 {params.path_to_script}/taxid_to_taxa.py \
                --indir {input} \
                --taxids $taxids >> {params.outdir}/config.yaml
        """

