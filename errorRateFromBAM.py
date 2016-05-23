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

    # if args.inFile == '-':
    #     inH = sys.stdin
    # else:
    #     inH = open(args.inFile, 'rU')

    samfile = pysam.Samfile(args.inFile, "rb")
    indelmisList=[]
    counter = 0
    for read in samfile:
        counter+=1
    
        #list of cigar tuples
        cigar = read.cigar
    
        alignlen = read.qlen
        querylen = read.rlen
    
        #error rate for del insert mismatch
        indelmisTuple = [querylen, 0.0, 0.0, 0.0]
    
        #skip when cigar is none
        if cigar == None:
            error.append(counter)	
            continue
    
        for cigartuple in cigar:
            if cigartuple[0]==1:
		indelmisTuple[2]+=cigartuple[1]
		
            elif cigartuple[0]==2:
                indelmisTuple[3]+=cigartuple[1]
    
    
        indelmisTuple[1]+=(read.tags[0][1]) - indelmisTuple[2] - indelmisTuple[3]
        indelmisTuple[2]/=alignlen
        indelmisTuple[3]/=alignlen
	   
        indelmisTuple[1]/=alignlen

        args.outFile.write("\t".join(map(str, indelmisTuple)) + "\n")
    
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
