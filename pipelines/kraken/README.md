# bin to fastq

A snakemake pipeline that takes in a csv report containing barcode information and mapping information, and bins a directory of basecalled fastq files by a specified barcode. Follows on from the rampart_demux_map snakemake pipeline.

(``BinLorry``)[https://github.com/rambaut/binlorry] does the binning and bins by barcode and min and max read length. 

### CSV format

The CSV report includes the following header fields: 

- read_name
- read_len
- start_time
- barcode
- best_reference
- start_coords
- end_coords
- ref_len
- num_matches
- aln_block_len

The required csv fields to run this pipeline are ``read_name`` and ``barcode``.

### Dependencies

In addition to the ``RAMPART`` dependencies, this snakemake pipeline also requires ``snakemake=5.4.3`` and ``BinLorry``.

### Usage

Install ``BinLorry``:
```
git clone https://github.com/rambaut/binlorry.git
pip3 install ./binlorry
```

You can either run this pipeline by editing the config file, providing your own config file or by explicitly stating the config parameters on the command line. 

To provide your own config file: 
```
snakemake --cores 2 --configfile=your_config_file.yaml
```

The config file can be in yaml or json format. 

To overwrite values via the command line:
```
snakemake --snakefile pipelines/bin_to_fastq/Snakefile \
--config barcode=NBXX \
output_path=examples/data/pipeline_output \
input_path=examples/data/basecalled
```

This pipeline will result in files produced in examples/data/pipeline_output under ``binned``.
