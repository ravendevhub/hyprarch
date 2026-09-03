-- Myanmar / English Switch Keybind (Super + Space)
hl.bind("SUPER + space", hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next && hyprctl switchxkblayout all next && notify-send -a 'Keyboard Layout' -t 1500 'Keyboard Switched' \"$(hyprctl devices | grep -A 3 at-translated-set-2-keyboard | grep 'active keymap' | sed 's/.*active keymap: //')\""))

-- Screenshot Keybindings (PrtSc / Super + Shift + S)
hl.bind("Print", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/screenshot.sh snip"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/screenshot.sh full"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/screenshot.sh snip"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/screenshot.sh edit"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/screenshot.sh full"))

-- Material Settings & Presets Panel (Super + I / Super + Escape)
hl.bind("SUPER + I", hl.dsp.exec_cmd("qs -c end4-pC ipc call settings toggle"))
hl.bind("SUPER + escape", hl.dsp.exec_cmd("qs -c end4-pC ipc call settings toggle"), {description = "Toggle settings"})

-- Wallpaper Selector & Online Wallpaper Browser (Super + Shift + W / Super + W)
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("qs -c end4-pC ipc call wallpaperSelector toggle"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("qs -c end4-pC ipc call wallpaperSelector toggle"))

-- Desktop Widgets / Overlay
hl.bind("SUPER + O", hl.dsp.exec_cmd("qs -c end4-pC ipc call overlay toggle"))
