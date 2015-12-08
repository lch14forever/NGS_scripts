hosts=$(cut -f 1 -d : ~/.ssh/known_hosts | \
   grep '^\[n[0-9]*.default.domain' | tr -d '[]' | sort -u);

for h in $hosts; do
   ssh $h "find /dev/shm/ -user lich -type f | xargs -r rm";
done
