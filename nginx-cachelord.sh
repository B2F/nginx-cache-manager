#!/bin/sh
if [ -f "nginx-cache-dir.ini" ]; then
  source ./nginx-cache-dir.ini
else
  cache_dir=/var/cache/nginx
fi
if [ "$1" ]; then
  if [ "$2" = "--list" ]; then
    grep -r --text ^KEY:.*$1 $cache_dir |sort -k2
  elif [ "$2" = "--date" ]; then
    grep -rl --text ^KEY:.*$1 $cache_dir | xargs -I% ls -lt % | tac
  else
    grep -rl --text ^KEY:.*$1 $cache_dir | xargs -I% rm -v %
  fi
fi
