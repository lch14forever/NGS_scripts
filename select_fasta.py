#!/usr/bin/python

import sys

# usage: python select_fasta.py <SELECTOR> <FASTA FILE> 
#out = sys.argv[3]
fasta_file = sys.argv[2]
selector_file = sys.argv[1]

# handle input from pipe
if selector_file == '-':
    f = sys.stdin
else:
    f = open(selector_file, 'rU')
selector = f.read().splitlines()
f.close()

sel_dict = {}
for i in selector:
    sel_dict[i] = True

with open(fasta_file, 'rU') as f:
    select = False
    for line in f:
        l = line.strip()
        # the header line
        if l.startswith('>'):
            if (l.split(' ')[0])[1:] in sel_dict:
                select = True
                print l
            else:
                select = False
        else:
            if select == True:
                print l
        

