#!/usr/bin/env python

"""Extract error profile (read_length, mismatch, insertion, deletion) from a bam

"""

import os
import sys
import argparse
import pysam

def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument("-i", "--input",
                        required="True",
                        dest="inFile",
                        help="Input BAM file (use - for stdin)")
    parser.add_argument('-o', '--outfile',
                        dest="outFile",
                        help="Output file",
                        default=sys.stdout,
                        type=argparse.FileType('w'))

    args = parser.parse_args(arguments)

    if args.inFile == '-':
        #inH = sys.stdin
	samfile = pysam.Samfile("-", "rb")
    else:
	samfile = pysam.Samfile(args.inFile, "rb")
      	#inH = open(args.inFile, 'rU')

    #samfile = pysam.Samfile(args.inFile, "rb")
    indelmisList=[]
    
    for read in samfile:
    
        #list of cigar tuples
        cigar = read.cigar
    
        alignlen = 0
        querylen = read.rlen
    
        #readlenth mismatch insertion deletion
        indelmisTuple = [querylen, 0.0, 0.0, 0.0]
    
        #skip when cigar is none
        if cigar == None or read.is_secondary or read.flag & 0x800 == 2048:	
            	
		continue
    
        for cigartuple in cigar:


            if cigartuple[0]==4 or cigartuple[0]==5:
            	continue
		
            alignlen+=cigartuple[1]
            if cigartuple[0]==1:
		indelmisTuple[2]+=cigartuple[1]
		
            elif cigartuple[0]==2:
                indelmisTuple[3]+=cigartuple[1]
    		
        NM = dict(read.tags)["NM"] 
        indelmisTuple[1]+= NM - indelmisTuple[2] - indelmisTuple[3]

        indelmisTuple[2]/=alignlen
        indelmisTuple[3]/=alignlen
	   
        indelmisTuple[1]/=alignlen
	
        args.outFile.write("\t".join(map(str, indelmisTuple)) + "\n")
    
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
