#mkdir bold
#kraken2-build --download-taxonomy --db bold    
kraken2-build --add-to-library data/BOLD-Animalia-COI5p.fasta --db bold
#kraken2-build --add-to-library data/NCBI_Animalia_BOLD_COI_250819.fasta --db bold
kraken2-build --build --db bold    
