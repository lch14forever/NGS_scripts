#!/usr/bin/python

# select a set of columns based on input file
# usage: 
# select_col.py <selectors: each column as a line> <input_file>
# the input file should not contain row names
# or put the [0,0] entry in the selector

# FIXME: make it flexible to accept data with the row names

import sys

queryFILE = sys.argv[1]
targetFILE = sys.argv[2]

# handle input from pipe
if queryFILE == '-':
    f = sys.stdin
else:
    f = open(queryFILE, 'rU')

# build an array of queries
query_list = []
for l in f:
    # skip the lines masked as command, may be header
    # if not l.startswith('#'):
    query_list += [l.strip()]
f.close()


not_in_list = []

with open(targetFILE) as inH:
    header = inH.readline().strip()
    colnames = header.split('\t')
    # build a dict for the column names
    colnames_dict = {}
    index = 0
    for i in colnames:
        colnames_dict[i] = index
        index += 1
    # identify the index to print
    sel = []
    colNames = []
    for i in query_list:
        if i in colnames_dict:
            sel.append(colnames_dict[i])
            colNames.append(i)
        else:
            not_in_list += [i]
    print '\t'.join(colNames)
    # read the rest of the file, only print selected columns           
    for l in inH:
        print '\t'.join([l.strip().split('\t')[i] for i in sel])
        
if not_in_list :
    sys.stderr.write("=======================================================\n")
    sys.stderr.write("Queries cannot be found in the file:\n")
    sys.stderr.write('\t'.join(not_in_list)+'\n')
    sys.stderr.write("=======================================================\n")
    sys.stderr.write("\n\n\n")
