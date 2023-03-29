#!/usr/bin/env sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run firefox
run kdeconnect-app
run kdeconnect-sms
run dropbox
run guake --hide
run emacsclient -c
