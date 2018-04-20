#!/usr/bin/env python

"""Split Nanopore reads into multiple folders

"""

import os
import sys
import argparse
from glob import glob
from shutil import copyfile

def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('inFolder', 
                        help='Input folder')    
    parser.add_argument("-n", "--num_reads",
                        required=False,
                        dest="n_reads",
                        default=10000,
                        type=int,
                        help="Number of reads per folder (Default: 10K)")
    parser.add_argument("-t", "--target_folder",
                        required=False,
                        dest="targetFolder",
                        default='./',
                        help="Target folder")

    args = parser.parse_args(arguments)

    file_list = sorted(glob(args.inFolder+"/*fast5"))

    
    counter = 0
    folder_id = 0
    for f in file_list:
        counter += 1
        if counter > args.n_reads:
            counter = 1
            folder_id += 1
        cur_folder = os.path.join(args.targetFolder, str(folder_id))
        if not os.path.exists(cur_folder):
            sys.stderr.write("Start to transfer to folder " + str(folder_id) +'\n')
            os.mkdir(cur_folder)
        copyfile(f, os.path.join(cur_folder, os.path.basename(f)) )

        
    
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
