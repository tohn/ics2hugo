#!/bin/bash

# requirements: curl, icsp (https://github.com/loteoo/icsp)

# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

if [[ ! -d '../_icsp' ]] ; then
  echo "Please download icsp" >&2
  exit 1
fi

while getopts u:p: arg ; do
  case "$arg" in
    u) url="$OPTARG" ;;
    p) path="$OPTARG" ;;
    *) echo "Unknown option ($arg $OPTARG)" ; usage ; exit 1 ;;
  esac
done

tm=$(date +%Y%m)
nm=$(date +%Y%m -d 'next month')

curl -fsSL "$url" | \
  ../_icsp/icsp -n -d': ' -c 'dtstart,summary' | \
  grep -e "^$tm" -e "^$nm" | \
  sed 's/Z//;s/..:/:/;s/T/\,\ /;s/./&:/12;s/./&-/6;s/./&-/4;s/^/\*\ /' \
  >"$path/events.md"
