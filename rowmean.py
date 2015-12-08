#!/mnt/software/unstowable/anaconda/bin/python
# rowmean.py <INPUT>

import sys

#cutoff = sys.argv[0]
profile = sys.argv[1]

with open(profile, 'rU') as f:
    h = f.readline().strip()
    print h.split()[0] + '\t' + 'Mean'
    for line in f:
        fields = line.strip().split('\t')
        num = map(float, fields[1:])
        print fields[0]+'\t' + str(sum(num)/len(num))
        
        
        
        
