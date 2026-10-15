#!/usr/bin/env bash
# GnomeCornersReimagined — theme installer.
#
# Usage:
#   ./install.sh --radius 8                      (or -r 8)
#   ./install.sh -r 8 --accentcolour blue        (or -ac blue / -ac E95420)
#   ./install.sh -r 8 --dashtodock               (also theme Dash-to-Dock; -dtd)
#   ./install.sh                                 (defaults: 4px, orange accent)
set -euo pipefail

RADIUS=""
DTD=""
ACCENT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--radius)
      RADIUS="$2"
      shift 2
      ;;
    -dtd|--dashtodock)
      DTD=1
      shift
      ;;
    -ac|--accentcolour|--accent-color|--accent)
      ACCENT="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 [--radius N | -r N] [--accentcolour C | -ac C] [--dashtodock | -dtd]" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$RADIUS" ]]; then
  RADIUS=4
  echo "No radius given; defaulting to 4px."
fi

if ! [[ "$RADIUS" =~ ^[0-9]+$ ]]; then
  echo "Error: --radius must be a non-negative integer (got '$RADIUS')." >&2
  exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Generating theme CSS (${RADIUS}px radius)"
GEN_ARGS=("$RADIUS")
[[ -n "$DTD" ]] && GEN_ARGS+=(--dashtodock)
[[ -n "$ACCENT" ]] && GEN_ARGS+=(--accentcolour "$ACCENT")
python3 "$DIR/generate.py" "${GEN_ARGS[@]}"

echo "==> Applying GTK3 theme (Radius4-dark)"
gsettings set org.gnome.desktop.interface gtk-theme 'Radius4-dark'

echo "==> Applying GNOME Shell theme (Radius4)"
dconf write /org/gnome/shell/extensions/user-theme/name "''" 2>/dev/null || true
sleep 0.5
dconf write /org/gnome/shell/extensions/user-theme/name "'Radius4'" 2>/dev/null || true

echo "==> Applying Flatpak overrides"
flatpak override --user --filesystem="$HOME/.local/share/themes:ro" 2>/dev/null || true
flatpak override --user --filesystem="$HOME/.config/gtk-3.0:ro"        2>/dev/null || true
flatpak override --user --filesystem="$HOME/.config/gtk-4.0:ro"        2>/dev/null || true
flatpak override --user --env=GTK_THEME=Radius4-dark                   2>/dev/null || true

echo
echo "Done — border radius is now ${RADIUS}px."
echo "Restart your applications (and optionally the shell) to see the change."
