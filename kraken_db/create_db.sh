mkdir bold
gunzip data/BOLD-Animalia-COI5p.fasta.gz
kraken2-build --download-taxonomy --db bold    
kraken2-build --add-to-library data/BOLD-Animalia-COI5p.fasta --db bold
kraken2-build --build --db bold    
