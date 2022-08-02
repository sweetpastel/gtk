#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Orchis

_COLOR_VARIANTS=('')
_COMPA_VARIANTS=('' '-Compact')
_THEME_VARIANTS=('')

if [ ! -z "${COMPA_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COMPA_VARIANTS <<< "${COMPA_VARIANTS:-}"
fi

if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [ ! -z "${THEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

Tar_themes() {
for theme in "${_THEME_VARIANTS[@]}"; do
  rm -rf ${THEME_NAME}${theme}.tar.xz
done

for theme in "${_THEME_VARIANTS[@]}"; do
  tar -Jcvf ${THEME_NAME}${theme}.tar.xz ${THEME_NAME}${theme} ${THEME_NAME}${theme}-Compact ${THEME_NAME}${theme}{-Light,-Dark} ${THEME_NAME}${theme}{-Light,-Dark}-Compact
done
}

Clear_theme() {
for theme in "${_THEME_VARIANTS[@]}"; do
  for color in "${_COLOR_VARIANTS[@]}"; do
    for compact in "${_COMPA_VARIANTS[@]}"; do
      [[ -d "${THEME_NAME}${theme}${color}${compact}" ]] && rm -rf "${THEME_NAME}${theme}${color}${compact}"
    done
  done
done
}

cd ..


./install.sh -t all -d $THEME_DIR --shell 42

cd $THEME_DIR && Tar_themes && Clear_theme

