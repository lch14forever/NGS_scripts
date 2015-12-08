TIME=$(date +"%T" | sed "s/:/-/g")


bsub \
-cwd $PWD \
-M 100 \
-W 1:00 \
-n 1 \
-R "span[hosts=1]" \
-o job.$TIME.log \
"echo 'This is a test!' 2> error.log"

# template to copy to CMD
# bsub -cwd $PWD -M 100 -W 1:00 -n 1 -R "span[hosts=1]" -o bsub.job.log "COMMANDS"
