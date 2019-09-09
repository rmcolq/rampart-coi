TAXA = config["taxon_names"].split(" ")
TAXIDS = config["taxids"].split(" ")

rule bin:
    input:
        expand(config["output_path"] + "binned/barcode_{barcode}/list_binned_fastq", barcode=config["barcode"]),
        expand(config["output_path"] + "assembled/barcode_{barcode}/list_assembled_fastq", barcode=config["barcode"]),

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
        outdir=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}",
        barcode="{barcode}",
        taxid="{taxid}",
        taxon="{taxon}",
    output:
        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta"         
    shell:
        """
        mkdir -p {params.outdir}
        grep -A1 "kraken:taxid|{params.taxid}" {params.kraken_fasta} > {output}.tmp
        head -n2 {output}.tmp > {output}
        rm {output}.tmp
        """

#rule make_assembly_config:
#    input:
#        config["output_path"] + "classified/barcode_{barcode}",
#        config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
#        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta",
#    params:
#        path_to_script= workflow.current_basedir,
#        outdir=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}",
#        barcode="{barcode}",
#        taxid="{taxid}",
#        taxon="{taxon}",
#    output:
#        config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/config.yaml"
#    shell:
#        """
#        mkdir -p {params.outdir}
#
#        cp "{params.path_to_script}/../config.yaml" {params.outdir}/config.yaml
#        echo "barcode: {params.barcode}" >> {params.outdir}/config.yaml
#        echo "taxon_names: {params.taxon}" >> {params.outdir}/config.yaml
#        echo "taxids: {params.taxid}" >> {params.outdir}/config.yaml
#        """

#rule run_assembly:
#    input:
#        reads=config["output_path"] + "binned/barcode_{barcode}/{taxon}_{taxid}.fastq",
#        ref=config["output_path"] + "assembled/barcode_{barcode}/{taxon}_{taxid}/ref.fasta",
#        config=config["output_path"] + "binned/barcode_{barcode}/config.yaml"
#    params:
#        path_to_script= workflow.current_basedir,
#        output_path= config["output_path"],
#        barcode = "{barcode}",
#        taxid="{taxid}",
#        taxon="{taxon}",
#    output:
#        config["output_path"] + "assembled/barcode_{barcode}/list_assembled_fastq"
#    shell:
#        """
#        snakemake --nolock --snakefile {params.path_to_script}/rules/consensus2.smk \
#        --configfile {input.config} \
#        --config \
#        output_path={params.output_path} \
#        barcode={params.barcode} \
#        taxids={params.taxid} \
#        taxon_names={params.taxon}
#        """
