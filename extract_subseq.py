#!/usr/bin/env python

"""A simple python script template.

"""

import os
import sys
import argparse


def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-i', '--infile', required='True', help="Input file",dest='infile')
    parser.add_argument("-s", "--start_pos",
                        dest="start",
                        default = 1,
                        type = int,
                        help="Starting position [0 indexing]")
    parser.add_argument("-e", "--end_pos",
                        dest="end",
                        default = -1,
                        type = int,
                        help="End position [1 indexing]")
    parser.add_argument('-o', '--outfile', help="Output file",dest='outfile',
                        default=sys.stdout, type=argparse.FileType('w'))

    args = parser.parse_args(arguments)
    from Bio import SeqIO
    from Bio.SeqRecord import SeqRecord
    
    if args.infile == '-':
        h = sys.stdin
    else:
        h = open(args.infile, 'rU')

    record = list(SeqIO.parse(args.infile, "fasta"))[0]
    qrecord = SeqRecord(record.seq[args.start:args.end], record.id + ':'+ str(args.start) + '-' + str(args.end), description= "")
    SeqIO.write(qrecord, args.outfile, "fasta")
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
