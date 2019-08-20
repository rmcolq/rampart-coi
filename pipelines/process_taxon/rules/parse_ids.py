import glob
import argparse

def is_sub_order(taxon1, taxon2):
    """
    Checks if taxon2 could is a sub order of taxon1 (assuming that taxon2 
    is the next line in kraken report after an unbroken run of lines that
    were sub orders).
    """
    taxon_order = ["U", "R", "D", "K", "P", "C", "O", "F", "G", "S"]
    if taxon_order.index(taxon1[0]) < taxon_order.index(taxon2[0]):
        return True
    elif taxon_order.index(taxon1[0]) > taxon_order.index(taxon2[0]):
        return False

    sub_taxon_number1 = taxon1[1:]
    sub_taxon_number2 = taxon2[1:]
    if not sub_taxon_number2:
        return False
    elif not sub_taxon_number1 or int(sub_taxon_number1) < int(sub_taxon_number2):
       return True
    return False 

def get_ids_from_file(infile, taxon):
    taxids = []
    with open(infile, "r") as f:
        for line in f:
            if not found_taxon and taxon in line:
                found_taxon = True
                taxon_order = line.split()[3]
                taxids.add(line.split()[4])
                print(line, found_taxon, taxon_order)
            elif found_taxon:
                current_taxon_order = line.split()[3]
                if is_sub_order(taxon_order, current_taxon_order):
                    print(line)
                    taxids.add(line.split()[4])
                else:
                    print(taxon_order, current_taxon_order, is_sub_order(taxon_order, current_taxon_order))
                    print(taxids)
                    return taxids

def parse_ids(indir, taxon):
    list_kraken_files = glob.glob("%s/*.kreport2" %indir)
    print(list_kraken_files)

    taxids = set()

    for f in list_kraken_files:
        taxids.add(get_ids_from_file(f,taxon))

parser = argparse.ArgumentParser(description='Get list of kraken ids relevant to a taxon name')
parser.add_argument('--indir',
                    help='input directory containing kraken reports')
parser.add_argument('--taxon',
                    help='name of taxon we are looking for')

args = parser.parse_args()

parse_ids(args.indir, args.taxon)
