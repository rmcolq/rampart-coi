rule prepare_krona:
    output:
        config["output_path"] + "temp/classified/taxonomy.tab"
    shell:
        """
        if [ ! -f {output} ]; then
        ktpath=$(which ktImportTaxonomy) 
        ktroot=${{ktpath%?????????????????}}     
        bash $ktroot/../opt/krona/updateTaxonomy.sh
        ln -s $ktroot/../opt/krona/taxonomy/taxonomy.tab {output}
        fi
        """
    
rule kraken_classify:
    input:
        db=config["kraken_db"],
        binned=config["output_path"] + "temp/binned/{filename_stem}_{barcode}.fastq",
        taxonomy=config["output_path"] + "temp/classified/taxonomy.tab"
    output:
        kraken=config["output_path"] + "classified/barcode_{barcode}/{filename_stem}.kraken",
    params:
        barcode="{barcode}"
    shell:
        """
        mkdir -p config["output_path"] + "classified/barcode_{params.barcode}"
        kraken2 --db {input.db} \
            --memory-mapping \
            {input.binned} \
            > {output.kraken};
        cat {output.kraken} >> config["output_path"] + "classified/barcode_{params.barcode}/barcode_{params.barcode}.kraken;
        ktImportTaxonomy \
            -q 2 -t 3 config["output_path"] + "classified/*/barcode_*.kraken \
            -o config["output_path"] + "classified/all_krona.html \
            &> config["output_path"] + "classified/krona.log
        """
