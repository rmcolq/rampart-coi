rule get_taxids:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        taxon="{taxon}",
        path_to_script= workflow.current_basedir,
        out_prefix=config["output_path"] + "taxon/barcode_{barcode}/{taxon}",
        min_length=config["min_length"],
        max_length=config["max_length"]
    output:
        config["output_path"] + "taxon/barcode_{barcode}/{taxon}.fastq"
    shell:
        """
        touch {output}
        taxids=$(python3 {params.path_to_script}/parse_ids.py \
            --indir {input} \
            --taxon {params.taxon})
        echo $taxids
        binlorry -i {input} \
        -n {params.min_length} \
        -x {params.max_length} \
        --output {params.out_prefix} \
        --filter-by kraken:taxid $taxids \
        """
