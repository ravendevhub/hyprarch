-- Material Settings & Presets Panel (Super + I / Super + Escape)
hl.bind("SUPER + I", hl.dsp.exec_cmd("qs -c end4-pC ipc call settings toggle"))
hl.bind("SUPER + escape", hl.dsp.exec_cmd("qs -c end4-pC ipc call settings toggle"), {description = "Toggle settings"})

-- Wallpaper Selector & Online Wallpaper Browser (Super + Shift + W / Super + W)
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("qs -c end4-pC ipc call wallpaperSelector toggle"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("qs -c end4-pC ipc call wallpaperSelector toggle"))

-- Desktop Widgets / Overlay
hl.bind("SUPER + O", hl.dsp.exec_cmd("qs -c end4-pC ipc call overlay toggle"))
