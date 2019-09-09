# rampart-coi
RAMPART protocol for classifier. This currently assumes that you have already downloaded and installed [RAMPART](https://github.com/rmcolq/rampart/tree/isolated_from_bioinformatics) (this branch has a couple of different parameters set to enable metagenomic heatmaps).
Inside the RAMPART directory, create a subdirectory called `protocols` and clone this repository.
```
cd protocols
git clone https://github.com/rmcolq/rampart-coi.git
```


1. Setup conda environment
```
conda env create -f environment.yml
```
2. Activate conda environment
```
source activate rampart-coi
```
3. Build kraken database (takes about 10 minutes)
   
   First copy two big files   
     - `BOLD-Animalia-COI5p_old.fasta`  
     - `NCBI_Animalia_BOLD_COI_250819.fasta`
   from dropbox to `kraken_db/data`
      
```           
cd kraken_db/
bash create_db.sh 
cd ..
```
4. Copy references file `BOLD_COI_references_by_phylum.fasta.gz` from dropbox 
5. Run and have fun, e.g.
```
cd example_data/millport
node ../../../../rampart.js 
  --basecalledPath basecalled/pass 
  --protocol ../../../rampart-coi
  --referencesPath ../../BOLD_COI_references_by_phylum.fasta.gz 
```
NB you need to run this from your run directory and have a `run_configuration.json` file in this local directory.
To view and explore the Krona plot, open `annotations/classified/all_krona.html` in your browser.

6. Assemble the classified sequences where more than 100 reads have mapped to a species, e.g.
```
snakemake 
  --snakefile /path/to/rampart-coi/pipelines/assemble_found_taxa/Snakefile 
  --configfile /path/to/rampart-coi/pipelines/assemble_found_taxa/config.yaml 
  --config output_path=annotations/ 
  kraken_fasta=/path/to/rampart-coi/kraken_db/data/BOLD-Animalia-COI5p_old.fasta 
```
