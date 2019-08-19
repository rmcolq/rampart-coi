rule binlorry:
    input:
        demuxed=config["output_path"] + "temp/{filename_stem}.fastq"
    params:
        min_length=config["min_length"],
        max_length=config["max_length"],
        out_prefix=config["output_path"]+ "temp/binned/{filename_stem}"
    output:
        expand(config["output_path"]+ "temp/binned/{{filename_stem}}_{barcode}.fastq", barcode=BARCODES, filename_stem="{filename_stem}")
    shell:
        """
        binlorry -i {input.demuxed} \
        -n {params.min_length} \
        -x {params.max_length} \
        --output {params.out_prefix} \
        --bin-by barcode \
        --force-output \
        """
