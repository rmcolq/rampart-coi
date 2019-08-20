rule get_taxids:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        taxon="{taxon}",
        path_to_script= workflow.current_basedir
    output:
        config["output_path"] + "taxon/barcode_{barcode}/{taxon}.ids"
    shell:
        """
        touch {output}
        python3 {params.path_to_script}/parse_ids.py \
            --indir {input} \
            --taxon {params.taxon}
        """
