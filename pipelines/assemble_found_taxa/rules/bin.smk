rule bin_by_taxid:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        outdir=config["output_path"] + "binned/barcode_{barcode}",
        min_length=config["min_length"],
        max_length=config["max_length"],
        taxid="{taxid}",
        taxon="{taxon}",
    output:
        config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq"       
    shell:
        """
        binlorry -i {input} \
          -n {params.min_length} \
          -x {params.max_length} \
          --output {params.outdir}/{params.taxon} \
          --bin-by kraken:taxid \
          --filter-by kraken:taxid {params.taxid} \
          -d "|="
        """

rule get_taxid_ref:
    params:
        kraken_fasta=config["kraken_fasta"],
        outdir=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}",
        barcode="{barcode}",
        taxid="{taxid}",
        taxon="{taxon}",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta"         
    shell:
        """
        mkdir -p {params.outdir}
        grep -A1 "kraken:taxid|{params.taxid}" {params.kraken_fasta} > {output}
        """

