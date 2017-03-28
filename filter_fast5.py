#!/usr/bin/env python

"""Filter fast5 files, split them into pass/fail folders.

"""

import os
import sys
import argparse
from shutil import copy
import h5py

def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('infiles', metavar='fast5_file', nargs='+',
                        help='multiple input files')    
    parser.add_argument("-q", "--min_mean_quality",
                        default= 9,
                        type= float,
                        dest="min_mean_q",
                        help="Minimal mean quality score required for pass (Default: 9)")
    parser.add_argument("--cleanup",
                        action = "store_true",
                        dest="cleanup",
                        help="Remove original files upon completion (Default: No cleanup). If `--list` is used, this is forced to False.")
    parser.add_argument("--list",
                        action = "store_true",
                        dest="list_files_only",
                        help="List the file status only (Default: Separate the files into pass and fail folders)")        
    parser.add_argument("-o", "--output_dir",
                        default= './',
                        dest="output_dir",
                        help="Output root directory (Default: ./)")

    args = parser.parse_args(arguments)

    dir_pass = args.output_dir + '/pass'
    dir_fail = args.output_dir + '/fail'

    if not args.list_files_only:
        if (not os.path.exists(dir_pass)) and (not os.path.exists(dir_fail)):
            os.makedirs(dir_pass)
            os.makedirs(dir_fail)
        else:
            sys.stderr.write("There is existing pass/fail folder, please start with a clean directory!\n")
            sys.exit("Cowardly refusing to overwrite existing directory structures...\n")

    for fast5 in args.infiles:
        with h5py.File(fast5, 'r') as f:
            f_target = dir_pass
            status = '1D'  ## ["1D", "2D_pass", "2D_fail"]
            if not '/Analyses/Basecall_2D_000/BaseCalled_2D' in f:
                ## 2D calling failed
                f_target = dir_fail
                status = '1D'
            else:
                mean_qscore = f['/Analyses/Basecall_2D_000/Summary/basecall_2d/'].attrs['mean_qscore']
                if mean_qscore >= args.min_mean_q:
                    f_target = dir_pass
                    status = '2D_pass'
                else:
                    ## 2D read does not pass quality filter
                    f_target = dir_fail
                    status = '2D_fail'
        if args.list_files_only:
            basename = fast5.split("/")[-1]
            folder = f_target.split("/")[-1]
            sys.stdout.write("\t".join([basename, folder, status])+ "\n")
        else:
            copy(fast5, f_target)

    if args.cleanup and not args.list_files_only:
        sys.stderr.write("Cleaning up...\n")
        for fast5 in args.infiles:
           os.remove(fast5)
        
    
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
