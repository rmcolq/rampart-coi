TAXA = config["taxon_names"].split(" ")
TAXIDS = config["taxids"].split(" ")

rule assemble:
    input:
        expand(config["output_path"] + "assembled/barcode_{barcode}/list_assembled_fastq", barcode=config["barcode"])

rule assemble_barcode:
    input:
        expand(config["output_path"] + "assembled/barcode_{{barcode}}/{taxon}_{taxid}/racon1.fasta", zip, taxon=TAXA, taxid=TAXIDS),
    params:
        output_path=config["output_path"],
        barcode="{barcode}",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/list_assembled_fastq"
    shell:
        """
        ls {params.output_path}/assembled/barcode_{params.barcode}/*_*/racon1.fasta > {output}
        """

rule minimap2_racon0:
    input:
        reads=config["output_path"] + "/binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        ref=config["output_path"] + "/assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta",
    output:
        config["output_path"] + "/assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.paf"
    shell:
        "minimap2 -x map-ont {input.ref} {input.reads} > {output}"

rule racon1:
    input:
        reads=config["output_path"] + "/binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        fasta=config["output_path"] + "/assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta",
        paf= config["output_path"] + "/assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.paf"
    output:
        config["output_path"] + "/assembled/barcode_{barcode}/{taxon}_{taxid}/racon1.fasta"
    shell:
        "../racon/build/bin/racon --no-trimming -t 1 {input.reads} {input.paf} {input.fasta} > {output}"
