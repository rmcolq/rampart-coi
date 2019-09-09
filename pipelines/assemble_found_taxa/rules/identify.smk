rule make_bin_config:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        path_to_script= workflow.current_basedir,
        outdir=config["output_path"] + "binned/barcode_{barcode}",
        min_length=config["min_length"],
        max_length=config["max_length"],
        min_count=config["min_count"],
        barcode="{barcode}",
    output:
        config["output_path"] + "binned/barcode_{barcode}/config.yaml"
    shell:
        """
        mkdir -p {params.outdir}

        taxids=$(python3 {params.path_to_script}/filter_by_count.py \
            --indir {input} \
            --min_count {params.min_count})

        cp "{params.path_to_script}/../config.yaml" {params.outdir}/config.yaml
        echo "barcode: {params.barcode}" >> {params.outdir}/config.yaml

        python3 {params.path_to_script}/taxid_to_taxa.py \
                --indir {input} \
                --taxids $taxids >> {params.outdir}/config.yaml
        """

