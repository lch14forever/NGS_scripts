#!/bin/bash


## Run command
cmd=$@
`$cmd >/tmp/job.stdout 2>/tmp/job.stderr`
status=$?

stderr=`cat /tmp/job.stderr`
stdout=`cat /tmp/job.stdout`
## Text message
MSG_SUCC="%23ExecutionLog%0ACommand: <b>$cmd</b>%0ASuccessful!"
MSG_FAIL="%23ExecutionLog%0ACommand: <b>$cmd</b>%0AFailed!%0Aexit code: <b>$status</b>%0AStderr: $stderr"

## Send message
[ $status -eq 0 ] && msg=$MSG_SUCC || msg=$MSG_FAIL
curl -X POST -H 'Content-Type: application/json' \
     "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?chat_id=$PRIVATE_CHAT_ID&text=$msg&parse_mode=html"
