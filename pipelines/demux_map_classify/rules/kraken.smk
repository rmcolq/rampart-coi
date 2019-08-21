rule prepare_krona:
    output:
        temp(config["output_path"] + "temp/classified/taxonomy.tab")
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
        kraken=temp(config["output_path"] + "classified/barcode_{barcode}/{filename_stem}.kraken"),
    params:
        barcode="{barcode}",
        filename_stem="{filename_stem}",
        outdir=config["output_path"] + "classified/barcode_{barcode}",
        classified=config["output_path"] + "classified"
    threads:
        2
    shell:
        """
        mkdir -p {params.outdir}
        kraken2 --db {input.db} \
            --report {params.outdir}/{params.filename_stem}.kreport2 \
            --classified-out {params.outdir}/{params.filename_stem}.fastq \
            --memory-mapping \
            {input.binned} \
            > {output.kraken};
        cat {output.kraken} >> {params.outdir}/barcode_{params.barcode}.kraken;
        ktImportTaxonomy \
            -q 2 -t 3 {params.classified}/*/barcode_*.kraken \
            -o {params.classified}/all_krona.html \
            &> {params.classified}/krona.log
        """
