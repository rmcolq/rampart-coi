rule minimap2_racon0:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.ref.paf"
    shell:
        "minimap2 -n 1 -m 1 {input.ref} {input.reads} > {output}"

rule racon1:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        fasta=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta",
        paf= config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.ref.paf"
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon1.fasta"
    shell:
        """
        if [ -s {input.paf} ]
        then
            racon --no-trimming -t 1 {input.reads} {input.paf} {input.fasta} > {output}
        else
            touch {output}
        fi
        """

rule minimap2_racon1:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon1.fasta",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon1.paf"
    shell:
        "minimap2 -n 1 -m 1 {input.ref} {input.reads} > {output}"

rule racon2:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        fasta=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon1.fasta",
        paf= config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon1.paf"
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon2.fasta"
    shell:
        """
        if [ -s {input.paf} ]
        then
            racon --no-trimming -t 1 {input.reads} {input.paf} {input.fasta} > {output}
        else
            touch {output}
        fi
        """

rule minimap2_racon2:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon2.fasta",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon2.paf"
    shell:
        "minimap2 -n 1 -m 1 {input.ref} {input.reads} > {output}"

rule racon3:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        fasta=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon2.fasta",
        paf= config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon2.paf"
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon3.fasta"
    shell:
        """
        if [ -s {input.paf} ]
        then
            racon --no-trimming -t 1 {input.reads} {input.paf} {input.fasta} > {output}
        else
            touch {output}
        fi
        """

rule minimap2_racon3:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon3.fasta",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon3.paf"
    shell:
        "minimap2 -n 1 -m 1 {input.ref} {input.reads} > {output}"

rule racon4:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        fasta=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon3.fasta",
        paf= config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon3.paf"
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon4.fasta"
    shell:
        """
        if [ -s {input.paf} ]
        then
            racon --no-trimming -t 1 {input.reads} {input.paf} {input.fasta} > {output}
        else
            touch {output}
        fi
        """

rule minimap2_racon4:
    input:
        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon4.fasta",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon4.paf"
    shell:
        "minimap2 -n 1 -m 1 {input.ref} {input.reads} > {output}"

rule medaka:
    input:
        basecalls=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
        draft=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/racon4.fasta",
        paf= config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/mapped.racon4.paf"
    params:
        outdir=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/medaka",
    output:
        consensus= config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/medaka/consensus.fasta"
    threads:
        2
    shell:
        """
        if [ -s {input.paf} ]
        then
            medaka_consensus -i {input.basecalls} -d {input.draft} -o {params.outdir} -t 2
        else
            touch {output.consensus}
        fi
        """

#rule minimap2_medaka:
#    input:
#        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
#        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/medaka/consensus.fasta",
#    output:
#        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/medaka/consensus.mapped.fasta",
#    shell:
#        "minimap2 -ax map-ont -n 1 -m 1 {input.ref} {input.reads} > {output}"

