#!/usr/bin/env python3

import argparse
from Bio import SeqIO,SeqRecord

def save_references_file(infile, outfile):
    updated = []
    records = SeqIO.index(infile, "fasta")
    for record in records:
        description = records[record].description
        l = description.split(",")[0].split()
        accession, genus, species, remain = l[0], l[1], "%s_%s" %(l[1], l[2]), "_".join(l[1:])
        new_description = "accession=%s genus=%s species=%s description=%s" %(accession, genus, species, remain)
        s = records[record]
        s.description = new_description
        s.id = genus
        updated.append(s)
    SeqIO.write(updated, outfile, "fasta")
    
parser = argparse.ArgumentParser(description='Formats references file downloaded from NCBI')
parser.add_argument("infile", help="References file downloaded from NCBI")
parser.add_argument('--outfile', '-o', type=str, default="references.fasta",
                    help="Output file name, default:references.fasta")
args = parser.parse_args()

save_references_file(args.infile, args.outfile)
