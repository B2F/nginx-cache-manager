#!/bin/sh
# The cache directory can be written in the cache_dir variable from the nginx-cache-dir.ini file in your working directory
if [ -f "nginx-cache-dir.ini" ]; then
  source ./nginx-cache-dir.ini
# Default cache directory is "/var/cache/nginx"
else
  cache_dir=/var/cache/nginx
fi
# The third option value can be used to override the cache directory
if [ "$3" ]; then
  cache_dir=$3
fi
if [ "$1" ]; then
  if [ "$2" = "--list" ]; then
    grep -r --text ^KEY:.*$1 $cache_dir |sort -k2
  elif [ "$2" = "--date" ]; then
    grep -rl --text ^KEY:.*$1 $cache_dir |xargs -I% ls -l % |sort -k6 |tac
  elif [ "$2" = "--new" ]; then
    grep -rl --text ^KEY:.*$1 $cache_dir |xargs -I% ls -l % |sort -k6 |tac |cut -d' ' -f9 |xargs -I% sed -n 2p %
  else
    grep -rl --text ^KEY:.*$1 $cache_dir |xargs -I% rm -v %
  fi
fi
