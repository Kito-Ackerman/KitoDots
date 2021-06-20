#!/usr/bin/env bash

set -euo pipefail

DMBROWSER="${BROWSER:-qutebrowser}"

# Show from what browser the url entry is from
SHOW_BROWSER=1

HISTORY_CACHE_FILE="${HOME}/.cache/dmbrowserhistory"

# A separator that will appear in between quickmarks, bookmarks and history urls.
SEPARATOR="-----------------------------------------------------------------------"

# Defining location of bookmarks file
BMFILE="$HOME/.config/qutebrowser/bookmarks/urls"
# Defining location of quickmarks file
QMFILE="$HOME/.config/qutebrowser/quickmarks"
# Defining location of history database
SQLITE_SEPARATOR='=%='

# Do query against sqlite3 database expecting two columns (title, url)
function cacheHistory() {
  file=${1}
  query=${2}
  [[ ${SHOW_BROWSER} -eq 1 ]] && browser=${3-} || browser=""

  sqlCmd="sqlite3 -separator ${SQLITE_SEPARATOR}"
  printf '%s\n' "$(${sqlCmd} "${file}" "${query}")" | \
  awk -F "${SQLITE_SEPARATOR}" -v browser="${browser} " '{print browser""$1" - "$NF}' >> "${HISTORY_CACHE_FILE}"
}

# cercare nelle cronologie dei browser 
generateHistory() {
  # Make sure cache is empty and exists
  echo -n "" > "${HISTORY_CACHE_FILE}"

  BRAVE_HISTORY="$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
  if [[ -f ${BRAVE_HISTORY} ]]; then
    SQL="SELECT title, url FROM urls where url like 'http%';"
    cacheHistory "${BRAVE_HISTORY}" "${SQL}" "(brave)"
  fi

  QUTEBROWSER_HISTORY="$HOME/.local/share/qutebrowser/history.sqlite"
  if [[ -f ${QUTEBROWSER_HISTORY} ]]; then
    SQL="SELECT title, url FROM history where url like 'http%';"
    cacheHistory "${QUTEBROWSER_HISTORY}" "${SQL}" "(qutebrowser)"
  fi

  if [[ -d ~/.mozilla/firefox ]]; then 
    SQL="PRAGMA encoding='UTF-8'; select p.title,p.url from moz_historyvisits as h, moz_places as p where p.id == h.place_id order by url"
    cd ~/.mozilla/firefox ;
    for db in */places.sqlite; do
      DB=$(realpath "${db}")
      cacheHistory "${DB}" "${SQL}" "(firefox)"
    done
  fi

  # reverse each line and then sorting on url making sure they are uniq then restoring the lines
  rev "${HISTORY_CACHE_FILE}" | sort -u -t' ' -r -k1,1 |rev | sort  > "${HISTORY_CACHE_FILE}.sorted"
}

# Read array of options to choose.
readarray -t bmarks < "${BMFILE}"
readarray -t qmarks < "${QMFILE}"

if [[ -f "${HISTORY_CACHE_FILE}.sorted" ]]; then
  if [ $(( $(date +%s) - $(date +%s -r "${HISTORY_CACHE_FILE}.sorted") )) -le 180 ]; then
    generateHistory
  fi
else 
  generateHistory
fi

# Sort the bookmark and quickmark lists so that the url is the last field.
# We will awk print the last field later.
# History list is formed by grep'ing "http" from the history table.
bmlist=$(printf '%s\n' "${bmarks[@]}" | awk '{print $2" - "$1}')
qmlist=$(printf '%s\n' "${qmarks[@]}" | awk '{print "["$1"] - "$NF}' | sort)
histlist=$(cat "${HISTORY_CACHE_FILE}.sorted" )

# Piping the lists into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
# The urls are listed quickmarks first, then the SEPARATOR, and then bookmarks and lastly history
choice=$(printf '%s\n' "$qmlist" "$SEPARATOR" "$bmlist" "$SEPARATOR" "$histlist" | dmenu -i -l 20 -p 'Qutebrowser open:' "$@" ) || exit

# What to do if the separator is chosen from the list.
# We simply launch qutebrowser without any url arguments.
# shellcheck disable=SC2154
if [ "$choice" == "$SEPARATOR" ]; then
    nohup "${DMBROWSER}" >/dev/null 2>&1 &
# What to do when/if we choose a url to view.
elif [ "$choice" ]; then
  url=$(echo "${choice}" | awk '{print $NF}') || exit
  nohup "${DMBROWSER}" "$url" >/dev/null 2>&1 &
# What to do if we just escape without choosing anything.
else
    echo "Program terminated." && exit 0
fi
