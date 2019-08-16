SAMPLES = [config['sample']]
BARCODES = config['barcodes'].strip().split(",")

rule all:
    input:
        expand("classified/barcode_{barcode}/{sample}.kraken", sample=SAMPLES, barcode=BARCODES)

rule get_kraken_db:
    input:
        config['kraken_db']
    output:
        directory("classified/kraken_db")
    shell:
        'ln -s "{input}" {output}'

rule prepare_krona:
    output:
        "classified/taxonomy.tab"
    shell:
        """
        if [ ! -f classified/taxonomy.tab ]; then
        ktpath=$(which ktImportTaxonomy) 
        ktroot=${{ktpath%?????????????????}}     
        bash $ktroot/../opt/krona/updateTaxonomy.sh
        ln -s $ktroot/../opt/krona/taxonomy/taxonomy.tab classified/taxonomy.tab
        fi
        """
    
rule binlorry:
    input:
        demuxed="demuxed/{sample}.fastq"
    params:
        min_length=config["min_length"],
        max_length=config["max_length"],
        sample="{sample}"
    output:
        expand("binned/{{sample}}_{barcode}.fastq", barcode=BARCODES, sample="{sample}")
    shell:
        """
        binlorry -i {input.demuxed} \
        -n {params.min_length} \
        -x {params.max_length} \
        --o binned/{params.sample} \
        --bin-by barcode
        """

rule kraken_classify:
    input:
        db="classified/kraken_db",
        binned="binned/{sample}_{barcode}.fastq",
        taxonomy="classified/taxonomy.tab"
    output:
        kraken="classified/barcode_{barcode}/{sample}.kraken",
    params:
        barcode="{barcode}"
    shell:
        """
        mkdir -p "classified/barcode_{params.barcode}"
        kraken2 --db {input.db} \
            --memory-mapping \
            {input.binned} \
            > {output.kraken};
        cat {output.kraken} >> classified/barcode_{params.barcode}/barcode_{params.barcode}.kraken;
        ktImportTaxonomy -q 2 -t 3 classified/*/barcode_*.kraken -o classified/all_krona.html &> classified/krona.log
        """
