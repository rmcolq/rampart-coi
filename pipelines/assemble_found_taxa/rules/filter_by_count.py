import glob
from Bio import SeqIO
from collections import Counter
import argparse

def update_counts(infile, taxid_counts):
    """
    Parses read headers for taxids and keeps counts
    """
    for record in SeqIO.parse(infile, "fastq"):
        try:
            id = record.description.split("taxid|")[1].split()[0]
            taxid_counts[id] += 1
        except:
            pass

def parse_ids(indir, min_count):
    list_kraken_files = glob.glob("%s/*.fastq" %indir)

    taxid_counts = Counter()
    
    for f in list_kraken_files:
        update_counts(f, taxid_counts)

    remove_ids = []
    for key in taxid_counts.keys():
        if taxid_counts[key] < min_count:
            remove_ids.append(key)
    for id in remove_ids:
        taxid_counts.pop(id, None)

    print(" ".join(taxid_counts.keys()))

parser = argparse.ArgumentParser(description='Get list of kraken ids relevant to a taxon name')
parser.add_argument('--indir',
                    help='input directory for kraken fastq')
parser.add_argument('--min_count', type=int, default=10,
                    help='min number of reads to be classified as this regex to keep')


args = parser.parse_args()

parse_ids(args.indir, args.min_count)

