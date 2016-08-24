#!/usr/bin/env bash

readonly FORMATTER=heroku-log-formatter.rb

main() {
  local app=$1

  if [ -z "$1" ]
  then
    echo 'Missing server argument.'
    exit 1;
  fi

  exec heroku logs -t --ps router --app "$app" \
    | ruby $FORMATTER
}
main "$@"
