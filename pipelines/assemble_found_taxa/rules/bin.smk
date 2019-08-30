TAXA = config["taxon_names"].split(" ")
TAXIDS = config["taxids"].split(" ")

rule bin:
    input:
        expand(config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq", barcode=config["barcode"])

rule bin_barcode:
    input:
        expand(config["output_path"] + "binned/barcode_{{barcode}}/{taxon}_{taxid}.fastq", zip, taxon=TAXA, taxid=TAXIDS),
        expand(config["output_path"] + "refs/barcode_{{barcode}}/{taxon}_{taxid}.fasta", zip, taxon=TAXA, taxid=TAXIDS),
    params:
        output_path=config["output_path"],
        barcode="{barcode}"
    output:
        config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq"
    shell:
        """
        ls {params.output_path}/binned/barcode_{params.barcode}/*_*.fastq > {output}
        """

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
        binned=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq"       
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
        outdir=config["output_path"] + "refs/barcode_{barcode}",
        barcode="{barcode}",
        taxid="{taxid}",
        taxon="{taxon}",
    output:
        config["output_path"] + "refs/barcode_{barcode}/{taxon}_{taxid}.fasta"         
    shell:
        """
        mkdir -p {params.outdir}
        grep -A1 "kraken:taxid|{params.taxid}" {params.kraken_fasta} > {output}.tmp
        head -n2 {output}.tmp > {output}
        rm {output}.tmp
        """

