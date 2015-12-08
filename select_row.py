#!/usr/bin/python

# select a set of rows based on input file
# usage: 
# select_row.py <selectors: each row as a line> <input_file>

import sys

queryFILE = sys.argv[1]
targetFILE = sys.argv[2]

# handle input from pipe
if queryFILE == '-':
    f = sys.stdin
else:
    f = open(queryFILE, 'rU')

# build a dict of queries
query_dict = {}
for l in f:
    # skip the lines masked as command, may be header
    if not l.startswith('#'):
        query_dict[l.strip()] = 1
f.close()

target_dict = {}
with open(targetFILE) as inH:
    #header = inH.readline().strip()
    #print header
    
    for line in inH:
        fields = line.strip().split()

        if fields[0] in query_dict:
            print line.strip()
            query_dict[fields[0]]=2
        
        
not_in_list = []        
for i in query_dict:
    if query_dict[i] == 1:
        not_in_list += [i]

if not_in_list:
    sys.stderr.write("=======================================================\n")
    sys.stderr.write("Queries cannot be found in the file:\n")
    sys.stderr.write('\t'.join(not_in_list)+'\n')
    sys.stderr.write("=======================================================\n")
    sys.stderr.write("\n\n\n")
