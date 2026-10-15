# GnomeCornersReimagined

Gnome libadwaita theme is nice, but I am not a huge fan of the roundy ui. 
This helps in setting the border radiuses of gtk applications uniformly with the border radius of your choosing.
It only works well if you have the default gnome theme.

Run one command, pass a number, done:

```bash
./install.sh --radius 8
```

Optionally pick an accent colour too:

```bash
./install.sh --radius 8 --accentcolour blue
```

---

## Requirements

- Tested GNOME shells: **46**.
- `python3` (for the CSS generator).
- `glib-compile-schemas` is **not** needed (this is not a shell extension).
- The **User Themes** shell extension enabled so the shell theme can be applied.
- The GTK3 theme **Radius4-dark** installed at
  `~/.local/share/themes/Radius4-dark/` (optional; if missing, GTK3 apps fall
  back to Adwaita + the radius override).

---

## Usage

```bash
cd GnomeCornersReimagined

./install.sh --radius 4                 # or -r 4
./install.sh -r 12
./install.sh -r 8 --dashtodock          # also theme Dash-to-Dock (or -dtd)
./install.sh -r 8 --accentcolour blue   # or -ac blue
./install.sh -r 8 -ac E95420            # custom 6-digit hex (no '#')
./install.sh                            # defaults: 4px, orange accent
```

After running, logout and then log back in to see changes take effect. Also, GTK3 apps don't get the theme on wayland because of how newer version of mutter work.
Things do seem to work on X11.

---

## Accent colours

The accent colour is set with `--accentcolour` / `-ac`. It accepts either a
name from the Ubuntu default list or a 6-digit hex value **without** the `#`:

| Name | Hex |
|---|---|
| orange (default) | `E95420` |
| bark | `787859` |
| sage | `657B69` |
| olive | `4B8501` |
| viridian | `03875B` |
| prussiangreen | `308280` |
| blue | `0073E5` |
| purple | `7764D8` |
| magenta | `B34CB3` |
| red | `E920A3` |

```bash
./install.sh -r 4 -ac purple
./install.sh -r 4 -ac 0073E5    # custom hex, no '#'
```

---

## Reverting

The generated CSS lives in `~/.config/gtk-{3.0,4.0}/` and the shell theme in
`~/.local/share/themes/Radius4/gnome-shell/`. To stop theming:

```bash
gsettings reset org.gnome.desktop.interface gtk-theme
dconf write /org/gnome/shell/extensions/user-theme/name "''"
rm -f ~/.config/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk-dark.css
rm -f ~/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk-dark.css
```
