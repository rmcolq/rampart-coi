configfile: config["output_path"] + "taxids/barcode_{barcode}/config.yaml"

rule bin_by_taxids:
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
              --output {params.outdir}/$name \
              --bin-by kraken:taxid \
              --filter-by kraken:taxid $id \
              -d "|="
          done
        done
        echo "output_path: {params.outdir}" >> {params.outdir}/config.yaml
        echo "taxids: $taxids" >> {params.outdir}/config.yaml
        echo "taxon_names: $names" >> {params.outdir}/config.yaml
        """

