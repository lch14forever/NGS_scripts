#!/usr/bin/env python

"""A script to submit jobs to GIS cluster (UGE?SGE?)

"""

import os
import sys
import argparse
import subprocess

def main(arguments):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('CMD', metavar='commands', nargs='*',
                        help='Commands to run')
    parser.add_argument("-t", "--threads",
                        default='2',
                        type=str,
                        help="Number of threads (default: 2)")
    parser.add_argument("-m", "--memory",
                        default='2',
                        type=str,
                        help="Amount of expected memory in GB (default: 2GB)")
    parser.add_argument("-l", "--run_time",
                        default='24',
                        type=str,
                        help="Duration of expected run time in hours (default: 2hrs)")
    parser.add_argument("-n", "--job_name",
                        default='log',
                        type=str,
                        help="Prefix of log files for stdout and stderr (default: log)")
    parser.add_argument("-q", "--queue",
                        default='interactive',
                        choices=['interactive', 'ionode'],
                        type=str,
                        help="The queue name for the session (default: interactive.q). If '--submit' flag is used, this is ignored unless set to 'ionode'")
    parser.add_argument("--submit",
                        action = "store_true",
                        dest="submit",
                        help="Submit to cluster with qsub (default: interactive session with qrsh)")
    # parser.add_argument("-e", "--extra_args",
    #                     default='',
    #                     help="Extra variables")

    args = parser.parse_args(arguments)

    jname = '-N ' + args.job_name
    cpu = '-pe OpenMP ' + args.threads
    mem = 'mem_free=' + args.memory + 'G'
    hrt = 'h_rt=' + args.run_time + ':00:00'
    limits = '-l ' + ','.join([mem, hrt])
    queue = '-q ' + args.queue + '.q'
    # cmd
    if args.submit:
        ## qsub
        if args.queue != 'ionode':
            queue = ''
        default_flags = '-cwd -V -b y'
        cmd = ' '.join(['qsub', jname, default_flags, limits, cpu, queue])
        cmd = ' '.join([cmd] + args.CMD)
        print cmd
    else :
        ## qrsh
        cmd = ' '.join(['qrsh', limits, cpu, queue])
        print cmd            
    # F

    #qrsh  -pe OpenMP 3 -q interactive.q -l h_rt=24:00:00,mem_free=3G
    #qsub -cwd -V -N log -l mem_free=100G,h_rt=24:0:0 -pe OpenMP 20 -b y
    
    
    ##print args
    
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
