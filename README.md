# rampart-coi
RAMPART protocol for classifier

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
