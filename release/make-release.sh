#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=SweetPastel

_COLOR_VARIANTS=('')
_COMPA_VARIANTS=('' '-Compact')
_TWEAK_VARIANTS=('' '-solid' '-compact')

if [ ! -z "${COMPA_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COMPA_VARIANTS <<< "${COMPA_VARIANTS:-}"
fi

if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [ ! -z "${TWEAK_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

Tar_themes () {
  for tweak in "${_TWEAK_VARIANTS[@]}"; do
    rm -rf ${THEME_NAME}${tweak}.tar.xz
  done

  for tweak in "${_TWEAK_VARIANTS[@]}"; do
    tar -Jcvf ${THEME_NAME}${tweak}.tar.xz ${THEME_NAME}${tweak} ${THEME_NAME}${tweak}-Compact ${THEME_NAME}${tweak} ${THEME_NAME}${tweak}-Compact
  done
}

Clear_theme () {
  for tweak in "${_THEME_VARIANTS[@]}"; do
    for color in "${_COLOR_VARIANTS[@]}"; do
      for compact in "${_COMPA_VARIANTS[@]}"; do
        [[ -d "${THEME_NAME}${compact}" ]] && rm -rf "${THEME_NAME}${compact}"
      done
    done
  done
}

cd ..

case $1 in
  -solid)
    tweak="--tweaks solid"
  ;;
  -compact)
    tweak="--tweaks compact"
  ;;
esac

./install.sh -d $THEME_DIR $tweak --shell 42

cd $THEME_DIR && Tar_themes && Clear_theme
