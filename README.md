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
```           
cd kraken_db/
bash create_db.sh 
cd ..
```
4. Run and have fun, e.g.
```
cd example_data/millport
node ../../../../rampart.js 
  --basecalledPath basecalled/pass 
  --annotatedPath annotated 
  --protocol ../../../rampart-coi
```
