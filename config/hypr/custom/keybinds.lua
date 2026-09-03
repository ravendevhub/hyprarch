-- Myanmar / English Switch Keybind (Super + Space)
hl.bind("SUPER, space", hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next && hyprctl switchxkblayout all next && notify-send -a 'Keyboard Layout' -t 1500 'Keyboard Switched' \"$(hyprctl devices | grep -A 3 at-translated-set-2-keyboard | grep 'active keymap' | sed 's/.*active keymap: //')\""))

-- Material Settings & Presets Panel (Super + I / Super + Escape)
hl.bind("SUPER + I", hl.dsp.exec_cmd("qs -c end4-pC ipc call settings toggle"))
hl.bind("SUPER + escape", hl.dsp.exec_cmd("qs -c end4-pC ipc call settings toggle"), {description = "Toggle settings"})

-- Wallpaper Selector & Online Wallpaper Browser (Super + Shift + W / Super + W)
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("qs -c end4-pC ipc call wallpaperSelector toggle"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("qs -c end4-pC ipc call wallpaperSelector toggle"))

-- Desktop Widgets / Overlay
hl.bind("SUPER + O", hl.dsp.exec_cmd("qs -c end4-pC ipc call overlay toggle"))
