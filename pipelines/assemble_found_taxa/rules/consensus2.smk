TAXA = config["taxon_names"].split(" ")
TAXIDS = config["taxids"].split(" ")

rule bin:
    input:
        expand(config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq", barcode=config["barcode"])

rule bin_barcode:
    input:
        expand(config["output_path"] + "binned/barcode_{{barcode}}/{taxon}_{taxid}.fastq", zip, taxon=TAXA, taxid=TAXIDS),
    params:
        output_path=config["output_path"],
        barcode="{barcode}"
    output:
        config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq"
    shell:
        """
        ls {params.output_path}/binned/barcode_{params.barcode}/*_*.fastq > {output}
        """

rule get_taxid_ref:
    input:
        config["output_path"] + "classified/barcode_{barcode}"
    params:
        kraken_fasta=config["kraken_fasta"],
        outdir=config["output_path"] + "refs/barcode_{barcode}",
        taxid="{taxid}",
        taxon="{taxon}",
    output:
        config["output_path"] + "refs/barcode_{barcode}/{taxon}_{taxid}.fastq"       
    shell:
        """
        grep -A1 "kraken:taxid|{params.taxon}" {params.kraken_fasta} | head -n2
        """
