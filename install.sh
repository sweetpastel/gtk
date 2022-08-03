#! /usr/bin/env bash

REPO_DIR="$(dirname "$(readlink -m "${0}")")"
source "${REPO_DIR}/core.sh"

usage() {
  cat <<EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
  -s, --size VARIANT      Specify size variant [standard|compact] (Default: All variants)
  -l, --libadwaita        Link installed Orchis gtk-4.0 theme to config folder for all libadwaita app use Orchis theme
  -r, --remove,
  -u, --uninstall         Uninstall/Remove installed themes

  --tweaks                Specify versions for tweaks [solid|compact] (Options can mix)
                          1. solid:    no transparency panel variant
                          2. compact:  no floating panel variant

  --shell                 Install gnome-shell version [38|40|42]
                          1. 38:       gnome-shell version < 40.0
                          2. 40:       gnome-shell version = 40.0
                          3. 42:       gnome-shell version = 42.0

  -h, --help              Show help
EOF
}

themes=()
colors=()
sizes=()
othemes=()
ocolors=()
osizes=()

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
  -d | --dest)
    dest="$2"
    mkdir -p "$dest"
    shift 2
    ;;
  -r | -u | --remove | --uninstall)
    remove="true"
    shift
    ;;
  -l | --libadwaita)
    libadwaita="true"
    shift
    ;;
  --shell)
    shift
    for variant in $@; do
      case "$variant" in
      38)
        shell="32-8"
        shift
        ;;
      40)
        shell="40-0"
        shift
        ;;
      42)
        shell="42-0"
        shift
        ;;
      -*)
        break
        ;;
      *)
        echo "ERROR: Unrecognized shell variant '$1'."
        echo "Try '$0 --help' for more information."
        exit 1
        ;;
      esac
    done
    ;;
  --tweaks)
    shift
    for variant in $@; do
      case "$variant" in
      solid)
        opacity="solid"
        shift
        ;;
      compact)
        panel="compact"
        shift
        ;;
      -*)
        break
        ;;
      *)
        echo "ERROR: Unrecognized tweaks variant '$1'."
        echo "Try '$0 --help' for more information."
        exit 1
        ;;
      esac
    done
    ;;
  -t | --theme)
    accent='true'
    shift
    for variant in "$@"; do
      case "$variant" in
      default)
        themes+=("${THEME_VARIANTS[0]}")
        shift
        ;;
      -*)
        break
        ;;
      *)
        echo "ERROR: Unrecognized theme variant '$1'."
        echo "Try '$0 --help' for more information."
        exit 1
        ;;
      esac
    done
    ;;
  -c | --color)
    shift
    for variant in "$@"; do
      case "$variant" in
      standard)
        colors+=("${COLOR_VARIANTS[2]}")
        shift
        ;;
      dark)
        colors+=("${COLOR_VARIANTS[2]}")
        shift
        ;;
      -*)
        break
        ;;
      *)
        echo "ERROR: Unrecognized color variant '$1'."
        echo "Try '$0 --help' for more information."
        exit 1
        ;;
      esac
    done
    ;;
  -s | --size)
    shift
    for variant in "$@"; do
      case "$variant" in
      standard)
        sizes+=("${SIZE_VARIANTS[0]}")
        shift
        ;;
      compact)
        sizes+=("${SIZE_VARIANTS[1]}")
        shift
        ;;
      -*)
        break
        ;;
      *)
        echo "ERROR: Unrecognized size variant '$1'."
        echo "Try '$0 --help' for more information."
        exit 1
        ;;
      esac
    done
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "ERROR: Unrecognized installation option '$1'."
    echo "Try '$0 --help' for more information."
    exit 1
    ;;
  esac
done

blackness="true"

if [[ "${#themes[@]}" -eq 0 ]]; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]]; then
  colors=("${COLOR_VARIANTS[2]}")
fi

if [[ "${#sizes[@]}" -eq 0 ]]; then
  sizes=("${SIZE_VARIANTS[@]}")
fi

if [[ "${#othemes[@]}" -eq 0 ]]; then
  othemes=("${OLD_THEME_VARIANTS[@]}")
fi

if [[ "${#ocolors[@]}" -eq 0 ]]; then
  ocolors=("${OLD_COLOR_VARIANTS[@]}")
fi

if [[ "${#osizes[@]}" -eq 0 ]]; then
  osizes=("${OLD_SIZE_VARIANTS[@]}")
fi

clean_theme

if [[ ${remove} == 'true' ]]; then
  if [[ "$libadwaita" == 'true' ]]; then
    uninstall_link
  elif [[ "$all" == 'true' ]]; then
    uninstall_theme && uninstall_link
  else
    uninstall_theme
  fi
else
  install_theme

  if [[ "$libadwaita" == 'true' ]]; then
    link_theme
  fi
fi

echo
echo "Done."