#!/bin/bash


## Run command
cmd=$@
`$cmd >/tmp/job.stdout 2>/tmp/job.stderr`
status=$?

stderr=`cat /tmp/job.stderr`
stdout=`cat /tmp/job.stdout`
## Text message
MSG_SUCC="#ExecutionLog\nCommand: <b>$cmd</b>\nSuccessful!"
MSG_FAIL="#ExecutionLog\nCommand: <b>$cmd</b>\nFailed!%0Aexit code: <b>$status</b>\nStderr: $stderr"
[ $status -eq 0 ] && msg=$MSG_SUCC || msg=$MSG_FAIL

## JSON file
JSON_FMT='{"chat_id":"%s","text":"%s","parse_mode":"html"}\n'
printf "$JSON_FMT" "$PRIVATE_CHAT_ID" "$msg" > /tmp/job.json

## Send message
[ $status -eq 0 ] && msg=$MSG_SUCC || msg=$MSG_FAIL
curl -X POST -H 'Content-Type: application/json' \
     -d @/tmp/job.json \
     "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
