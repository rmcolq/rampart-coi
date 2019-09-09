TAXA = config["taxon_names"].split(" ")
TAXIDS = config["taxids"].split(" ")

rule bin_assemble:
    input:
        #expand(config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq", barcode=config["barcode"]),
        expand(config["output_path"] + "assembled/barcode_{barcode}/assembled.fastq", barcode=config["barcode"]),

rule bin_barcode:
    input:
        expand(config["output_path"] + "binned/barcode_{{barcode}}/{taxon}_{taxid}.fastq", zip, taxon=TAXA, taxid=TAXIDS),
        expand(config["output_path"] + "assembled/barcode_{{barcode}}/{taxon}_{taxid}/ref.fasta", zip, taxon=TAXA, taxid=TAXIDS),
    params:
        output_path=config["output_path"],
        barcode="{barcode}"
    output:
        config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq"
    shell:
        """
        ls {params.output_path}/binned/barcode_{params.barcode}/*_*.fastq > {output}
        """

rule assemble_barcode:
    input:
        expand(config["output_path"] + "assembled/barcode_{{barcode}}/{taxon}_{taxid}/medaka/consensus.fasta", zip, taxon=TAXA, taxid=TAXIDS),
        expand(config["output_path"] + "binned/barcode_{{barcode}}/{taxon}_{taxid}.fastq", zip, taxon=TAXA, taxid=TAXIDS),
        expand(config["output_path"] + "assembled/barcode_{{barcode}}/{taxon}_{taxid}/ref.fasta", zip, taxon=TAXA, taxid=TAXIDS),
    params:
        output_path=config["output_path"],
        barcode="{barcode}",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/assembled.fastq"
    shell:
        """
        cat {params.output_path}/assembled/barcode_{params.barcode}/*_*/medaka/consensus.fasta > {output}
        """

##### Modules #####
include: "bin.smk"
include: "consensus.smk"
