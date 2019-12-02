# rampart-coi
RAMPART protocol for mitochondrial COI based classifier. 

## Installing and set up
1. First clone the repository
```
git clone https://github.com/rmcolq/rampart-coi.git
cd rampart-coi
```
2. Setup and activate the conda environment
```
conda env create -f environment.yml
source activate rampart-coi
```
3. Download (large) reference files and build kraken database (takes about 10 minutes)
   
   First copy two big files   
     - `BOLD-Animalia-COI5p_old.fasta`  
     - `NCBI_Animalia_BOLD_COI_250819.fasta`
   from dropbox (`VirusEvolution Dropbox/Group/Seawater_WIMP/kraken_data/`) to `kraken_db/data`
      
```           
cd kraken_db/
bash create_db.sh 
cd ..
```
4. (Optional) Copy references file `BOLD_COI_references_by_phylum.fasta.gz` from dropbox (`VirusEvolution Dropbox/Group/Seawater_WIMP/heatmap_references/`)

## Running 

Create run folder:
```
mkdir [run_name]
cd [run_name]
```
Where `[run_name]` is whatever you are calling todays run (as specified in MinKNOW).

Create a basic `run_configuration.json` file in this run directory, e.g.
```
{
  "title": "My metagenomic run",
  "basecalledPath": "~/MinKNOW/data/reads/[run_name]/pass",
  "samples": [
    {
      "name": "Dummy",
      "description": "",
      "barcodes": [ "NB01" ]
    }
  ]
}
```
NB This must contain at least one sample with a specified barcode. If this is an unbarcoded run, use the dummy sample from the example config.

Run RAMPART from this run directory:
```
rampart --protocol /path/to/rampart-coi
```

Open a web browser to view http://localhost:3000 the RAMPART run.
Open `/path/to/[run_name]/annotations/classified/all_krona.html` in a second browser tab. Refresh this page periodically to view the latest krona results as they come in.

## Example dataset

```
cd example_data/millport
node ../../../../rampart.js 
  --protocol ../../../rampart-coi
  --basecalledPath basecalled/pass 
  --referencesPath ../../BOLD_COI_references_by_phylum.fasta.gz 
```
NB you need to run this from your run directory and have a `run_configuration.json` file in this local directory.
To view and explore the Krona plot, open `annotations/classified/all_krona.html` in your browser.

You can assemble the classified sequences where more than 100 reads have mapped to a species, e.g.
```
snakemake 
  --snakefile /path/to/rampart-coi/pipelines/assemble_found_taxa/Snakefile 
  --configfile /path/to/rampart-coi/pipelines/assemble_found_taxa/config.yaml 
  --config output_path=annotations/ 
  kraken_fasta=/path/to/rampart-coi/kraken_db/data/BOLD-Animalia-COI5p_old.fasta 
```
