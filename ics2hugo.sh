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

tm=$(gdate +%Y-%m)
nm=$(gdate +%Y-%m -d 'next month')

# https://stackoverflow.com/a/47438110/2642656
convert_date_format() {
  local INPUT_FORMAT="$1"
  local INPUT_DATE="$2"
  local OUTPUT_FORMAT="$3"
  local UNAME
  UNAME="$(uname)"

  if [[ "$UNAME" == "Darwin" ]]; then
    # Mac OS X
    TZ='Europe/Berlin' date -j -f "$INPUT_FORMAT" "$INPUT_DATE" +"$OUTPUT_FORMAT"
  elif [[ "$UNAME" == "Linux" ]]; then
    # Linux
    date -d "$INPUT_DATE" +"$OUTPUT_FORMAT"
  else
    # Unsupported system
    echo "Unsupported system"
  fi
}

# TODO fix timezones (00Z or 01Z or ???)
curl -fsSL "$url" | \
  ../_icsp/icsp -d'¡' -c 'dtstart,dtend,summary,description' | \
  grep -v 'DTSTART' | \
  sort | \
  grep -e "^$tm" -e "^$nm" | \
  while IFS=¡ read -r start end summary desc ; do
    # add time if start contains T and Z
    if [[ "${start}" =~ " " ]] ; then
      _start=$(convert_date_format '%Y-%m-%d %H:%M:%S' "$start" '%d.%m.%Y')
    else
      _start=$(convert_date_format '%Y-%m-%d' "$start" '%d.%m.%Y')
    fi
    # add end date if it's set
    if [[ -n $end ]] ; then
      # add end time if it's not 235900
      if [[ "${end}" =~ " " ]] ; then
        _end=$(convert_date_format '%Y-%m-%d %H:%M:%S' "$end" '%d.%m.%Y')
      else
        _end=$(convert_date_format '%Y-%m-%d' "$end" '%d.%m.%Y')
      fi
      # only use end if it's not the same as start
      if [[ "${_start}" == "${_end}" ]] ; then
        _end=""
      else
        _end=" - $_end"
      fi
    else
      _end=""
    fi
    # if description is not empty, use as link
    if [[ -n $desc ]] ; then
      _summary="[$summary]($desc)"
    else
      _summary=$summary
    fi
    echo "* ${_start}${_end}: ${_summary}"
  done >"$path/events.md"
