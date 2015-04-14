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

options_list='nginx-cachelord.sh token [--rm]|[--list]|[--date]|[--new]'

if [ "$1" ]; then
  # list all matching cache keys sorted by name
  if [ "$2" = "--list" ]; then
    grep -r --text ^KEY:.*$1 $cache_dir |sort -k2
  # print matching cache file entries sorted by date
  elif [ "$2" = "--date" ]; then
    grep -rl --text ^KEY:.*$1 $cache_dir |xargs -I$ ls -l --time-style="+%Y %m %e %l:%M" $ |sort -k6,9n |tac
  # print matching cache entries names, sorted by date
  elif [ "$2" = "--new" ]; then
    grep -rl --text ^KEY:.*$1 $cache_dir |xargs -I$ ls -l --time-style="+%Y %m %e %l:%M" $ |sort -k6,9n |tac |tr -s ' ' |cut -d' ' -f10 |xargs -I% sed -n 2p %
  # remove matching cache entries when a token is found with the "-rm" option
  elif [ $2 = "--rm" ]; then
    grep -rl --text ^KEY:.*$1 $cache_dir |xargs -I% rm -v %
  else
    echo $options_list
    echo 'Invalid option "'$2'"'
  fi
else
  echo $options_list
fi
