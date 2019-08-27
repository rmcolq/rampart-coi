import glob
import argparse

def get_taxa_from_file(infile, taxid, min_level):
    taxon_order = ["U", "R", "D", "K", "P", "C", "O", "F", "G", "S"]

    with open(infile, "r") as f:
        for line in f:
            if str(taxid) in line:
                found_taxon_order = line.split()[3][0]
                found_taxid = line.split()[4]
                found_taxon_name = line.split()[5:]

                if taxid != int(found_taxid):
                    continue
                if taxon_order.index(found_taxon_order) >= taxon_order.index(min_level):
                    return "_".join(found_taxon_name)
    return None

def parse_ids(indir, taxids, min_level):

    list_kraken_files = glob.glob("%s/*.kreport2" %indir)
    current_taxids = taxids
    taxa = {}

    for taxid in current_taxids:
        for f in list_kraken_files[:1]:
            taxa_name = get_taxa_from_file(f, taxid, min_level)
            if taxa_name:
                taxa[taxid] = taxa_name
                break
    
    print(" ".join([taxa[taxid] for taxid in taxa]))

parser = argparse.ArgumentParser(description='Get list of kraken ids relevant to a taxon name')
parser.add_argument('--indir',
                    help='input directory containing kraken reports')
parser.add_argument('--taxids', type=int, nargs='+',
                    help='space separated list of taxids')
parser.add_argument('--min_level', default="S",
                     help='specify what taxon level to allow from ["U", "R", "D", "K", "P", "C", "O", "F", "G", "S"]')

args = parser.parse_args()

parse_ids(args.indir, args.taxids, args.min_level)
