rule assemble:
    input:
        config["output_path"] + "taxon/barcode_{barcode}/{taxon}.fastq"
    output:
        config["output_path"] + "assembly/barcode_{barcode}/{taxon}.fasta"
    conda:
        workflow.current_basedir + "/flye.yml"
    shell:
        """
         flye --nano-raw annotations/taxon/barcode_none/Noctuoidea.fastq --genome-size 3k --out-dir annotations/assembled/barcode_none/Noctuoidea --meta --threads 2 --plasmids
        """
