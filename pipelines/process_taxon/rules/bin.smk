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
        -d "|="
        """

rule bin_by_taxids:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        path_to_script= workflow.current_basedir,
        outdir=config["output_path"] + "taxids/old_barcode_{barcode}",
        out_prefix=config["output_path"] + "taxids/old_barcode_{barcode}/taxid",
        min_length=config["min_length"],
        max_length=config["max_length"],
        min_count=config["min_count"],
    output:
        directory(config["output_path"] + "taxids/old_barcode_{barcode}")
    shell:
        """
        mkdir -p {params.outdir}
        taxids=$(python3 {params.path_to_script}/filter_by_count.py \
            --indir {input} \
            --min_count {params.min_count})
        echo $taxids
        binlorry -i {input} \
        -n {params.min_length} \
        -x {params.max_length} \
        --output {params.out_prefix} \
        --bin-by kraken:taxid \
        --filter-by kraken:taxid $taxids \
        -d "|="
        """

rule bin_by_taxids_named:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        path_to_script= workflow.current_basedir,
        outdir=config["output_path"] + "taxids/barcode_{barcode}/",
        out_prefix=config["output_path"] + "taxids/barcode_{barcode}/taxid",
        min_length=config["min_length"],
        max_length=config["max_length"],
        min_count=config["min_count"],
    output:
        config["output_path"] + "taxids/barcode_{barcode}/config.yaml"
    shell:
        """
        mkdir -p {params.outdir}
        taxids=$(python3 {params.path_to_script}/filter_by_count.py \
            --indir {input} \
            --min_count {params.min_count})
        echo $taxids
        for id in $taxids
        do
          names=$(python3 {params.path_to_script}/taxid_to_taxa.py \
                --indir {input} \
                --taxids $id)
          echo $names
          for name in $names
          do
            binlorry -i {input} \
              -n {params.min_length} \
              -x {params.max_length} \
              --output {params.outdir}$name \
              --bin-by kraken:taxid \
              --filter-by kraken:taxid $id \
              -d "|="
          done
        done
        """

