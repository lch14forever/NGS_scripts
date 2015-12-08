#!/bin/bash

body="[`hostname`] Command: $@"
workingDir=`pwd`
body="$body\nWorking directory: $workingDir"
start=`date`
starttime=`date -d "$start" +%s`
eval $@ & # Run the given command line in the background.
pid=$!
trap 'kill $pid; echo -e "kill $pid"; echo -e "$body" >> run.summary; echo -e "SIGINT/SIGTERM detected. Job killed!\n$body" | mailx -s "Job: $pid terminated!!" ${USER}@gis.a-star.edu.sg; exit' SIGINT SIGTERM
body="$body\nPID: $pid"
body="$body\nStart time: $start"

peak=0
threads=0
cores=0
float_scale=2

while true; do
  sampleMem="$(ps -o rss=$pid S | sort -nr | head -n 1)" || break
  let peak='sampleMem > peak ? sampleMem : peak'
  sampleThreads="$(ps -o thcount -p $pid | tail -n +2)" || break
  let threads='sampleThreads > threads ? sampleThreads : threads'
  sampleCores="$(ps uH -p $pid | tail -n +2 | wc -l)" || break
  let cores='sampleCores > cores ? sampleCores : cores'
  running=`ps -p $pid --no-heading`
  if [[ -z $running ]]
  then
      break
  fi
done

end=`date`
endtime=`date -d "$end" +%s`
body="$body\nEnd time: $end"

elapseTime=`expr $endtime - $starttime`
elapseDay=$(( elapseTime / 86400 ))
elapseHour=$(( (elapseTime / 3600) % 24 ))
elapseMinute=$(( ( elapseTime / 60 ) % 60 ))
elapseSecond=$(( elapseTime % 60 ))
body="$body\nElapse time: $elapseDay day(s) | $elapseHour hour(s) | $elapseMinute min(s) | $elapseSecond sec(s)"
body="$body\nPeak memory usage: $(echo -e $peak | awk '{print $peak / 1024 / 1024}') GB(s)"
body="$body\nNo. of threads spawned: $threads"
body="$body\nNo. of cores utilized: $cores"

echo -e "$body\n" >> run.summary
echo -e "$body" | mailx -s "Job: $pid completed" ${USER}@gis.a-star.edu.sg
