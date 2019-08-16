rule get_kraken_db:
    input:
        config['kraken_db']
    output:
        directory("classified/kraken_db")
    shell:
        'ln -s "{input}" {output}'

rule prepare_krona:
    output:
        config["output_path"] + "/temp/classified/taxonomy.tab"
    shell:
        """
        if [ ! -f {output} ]; then
        ktpath=$(which ktImportTaxonomy) 
        ktroot=${{ktpath%?????????????????}}     
        bash $ktroot/../opt/krona/updateTaxonomy.sh
        ln -s $ktroot/../opt/krona/taxonomy/taxonomy.tab {output}
        fi
        """
    
rule binlorry:
    input:
       demuxed= config["output_path"] + "/temp/{filename_stem}.fastq"
    params:
        min_length= config["min_length"],
        max_length= config["max_length"],
        sample= "{filename_stem}"
        outdir= config["output_path"]+'/temp/binned'
    output:
        expand(config["outputPath"] + "/temp/binned/{{sample}}_{barcode}.fastq",barcode=config["barcode"], sample="{filename_stem}")
    shell:
        """
        binlorry -i {input.demuxed} \
        -n {params.min_length} \
        -x {params.max_length} \
        --o binned/{params.sample} \
        --bin-by barcode
        --filter-by barcode {barcode_string} 
        --out-report
        """

rule kraken_classify:
    input:
        db=config["output_path"] + "/temp/classified/kraken_db",
        binned=config["output_path"] + "/temp/binned/{sample}_{barcode}.fastq",
        taxonomy=config["output_path"] + "/temp/classified/taxonomy.tab"
    output:
        kraken=config["output_path"] + "/classified/barcode_{barcode}/{sample}.kraken",
    params:
        barcode="{barcode}"
    shell:
        """
        mkdir -p config["output_path"] + "/classified/barcode_{params.barcode}"
        kraken2 --db {input.db} \
            --memory-mapping \
            {input.binned} \
            > {output.kraken};
        cat {output.kraken} >> config["output_path"] + "/classified/barcode_{params.barcode}/barcode_{params.barcode}.kraken;
        ktImportTaxonomy \
            -q 2 -t 3 config["output_path"] + "/classified/*/barcode_*.kraken \
            -o config["output_path"] + "/classified/all_krona.html \
            &> config["output_path"] + "/classified/krona.log
        """
