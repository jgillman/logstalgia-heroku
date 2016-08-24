#!/usr/bin/env bash

readonly FORMATTER=heroku-log-formatter.rb

main() {
  local app=$1

  if [ -z "$1" ]
  then
    echo "Missing server argument."
    exit 1
  fi

  exec heroku logs -t --ps router --app "$app" \
    | ruby $FORMATTER \
    | logstalgia - --paddle-mode pid --sync --full-hostnames \
      -g "Cart,URI=^\/(cart|checkout),10" \
      -g "GBMC,URI=^\/x\/gbmc,10" \
      -g "MDASH,URI=^\/mmc,10" \
      -g "API,URI=^\/api,10"
}
main "$@"
