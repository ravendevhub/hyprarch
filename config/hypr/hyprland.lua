-- ============================================================================
-- HYPRARCH PRO DESKTOP (Hyprland 0.55+ Lua Edition)
-- Tailored for ASUS Vivobook 16 (Intel iGPU + NVIDIA RTX 3050)
-- ============================================================================

-- Preferred Display Configuration (144Hz Native)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- ASUS Vivobook Hybrid GPU Routing: Intel primary (card1: eDP-1) + NVIDIA offload (card0)
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")

-- UI, Cursor & Toolkit Environments
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GTK_ICON_THEME", "Hyprarch")
hl.env("ADW_DISABLE_PORTAL", "1")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

-- ============================================================================
-- CORE COMPOSITOR CONFIGURATION
-- ============================================================================
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        layout = "dwindle",
        allow_tearing = false,
        col = {
            active_border = "rgba(7dd3fcee)",
            inactive_border = "rgba(334155aa)",
        },
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        shadow = {
            enabled = true,
            range = 14,
            render_power = 2,
            color = "rgba(00000033)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
        },
    },
    animations = { enabled = true },
    dwindle = {
        preserve_split = true,
        smart_split = false,
    },
    input = {
        kb_layout = "us,mm",
        kb_options = "grp:win_space_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        on_focus_under_fullscreen = 1,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

local mod = "SUPER"
local home = os.getenv("HOME")

-- ============================================================================
-- [1] PRO APP LAUNCHERS & SYSTEM SHORTCUTS
-- ============================================================================
hl.bind("ALT + SPACE", hl.dsp.global("hyprarch:launcher"))
hl.bind(mod .. " + slash", hl.dsp.global("hyprarch:keybinds"))
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("google-chrome"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("mousepad"))
hl.bind(mod .. " + I", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-settings"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("nm-connection-editor"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"))

-- Clipboard History (Super + V like Windows)
hl.bind(mod .. " + V", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-clipboard"))

-- Window Operations
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + Q", function()
    local win = hl.get_active_window()
    if win ~= nil and (win.class == "imv" or win.initial_class == "imv"
        or win.class == "nsxiv" or win.initial_class == "nsxiv"
        or win.class == "Nsxiv" or win.initial_class == "Nsxiv") then
        hl.dispatch(hl.dsp.window.kill())
    else
        hl.dispatch(hl.dsp.window.close())
    end
end)

-- ============================================================================
-- [2] VIM MOTIONS & DIRECTIONAL NAVIGATION (PRO SPEED)
-- ============================================================================
-- Move Focus with Vim (HJKL)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move Focus with Arrows
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap/Move Windows in Direction (Vim & Arrows)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize Active Window (Super + Ctrl + HJKL or Arrows)
hl.bind(mod .. " + CONTROL + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -30 0"))
hl.bind(mod .. " + CONTROL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 30 0"))
hl.bind(mod .. " + CONTROL + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -30"))
hl.bind(mod .. " + CONTROL + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 30"))
hl.bind(mod .. " + CONTROL + left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -30 0"))
hl.bind(mod .. " + CONTROL + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 30 0"))
hl.bind(mod .. " + CONTROL + up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -30"))
hl.bind(mod .. " + CONTROL + down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 30"))

-- ============================================================================
-- [3] WORKSPACES & MAGIC SCRATCHPAD
-- ============================================================================
for workspace = 1, 5 do
    hl.bind(mod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

-- Drop-down Scratchpad (Super + S / Super + grave)
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Window Control (Drag & Resize)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ============================================================================
-- [4] LAPTOP HARDWARE KEYS, LID SWITCH & SCREENSHOTS
-- ============================================================================
-- Audio Volume & Mute Keys (with live on-screen OSD notification)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-volume mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-volume mic"), { locked = true })

-- Screen Brightness Keys (with live on-screen OSD notification)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-brightness down"), { locked = true, repeating = true })

-- Laptop Lid Switch (Sleep screen when lid is closed, wake on open)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"))
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"))

-- Screenshots (PrtSc: select area -> copy to clipboard -> ready for Ctrl+V, NO disk clutter)
hl.bind("Print", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-screenshot area_clipboard"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-screenshot full_clipboard"))
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd(home .. "/.local/bin/laptop-screenshot save"))

-- ============================================================================
-- [5] AUTOMATION: PRO WORKSPACE & WINDOW RULES
-- ============================================================================
-- Workspace 1: Web & Research
hl.window_rule({
    name = "auto-ws1-chrome",
    match = { class = "google-chrome" },
    workspace = 1,
})
hl.window_rule({
    name = "auto-ws1-firefox",
    match = { class = "firefox" },
    workspace = 1,
})
hl.window_rule({
    name = "auto-ws1-chromium",
    match = { class = "chromium" },
    workspace = 1,
})

-- Workspace 2: Code & Development
hl.window_rule({
    name = "auto-ws2-antigravity",
    match = { class = "antigravity-ide" },
    workspace = 2,
})
hl.window_rule({
    name = "auto-ws2-code",
    match = { class = "code" },
    workspace = 2,
})

-- Floating Dialogs & Utilities (Clean floating, no tiling disruption)
hl.window_rule({
    name = "float-nsxiv",
    match = { class = "Nsxiv" },
    float = true,
    center = true,
    size = { "monitor_w * 0.78", "monitor_h * 0.78" },
})
hl.window_rule({
    name = "float-blueman",
    match = { class = "blueman-manager" },
    float = true,
    center = true,
    size = { "720", "500" },
})
hl.window_rule({
    name = "float-pavucontrol",
    match = { class = "pavucontrol" },
    float = true,
    center = true,
    size = { "720", "500" },
})
hl.window_rule({
    name = "float-nm-connection",
    match = { class = "nm-connection-editor" },
    float = true,
    center = true,
})
hl.window_rule({
    name = "float-gnome-control-center",
    match = { class = "gnome-control-center" },
    float = true,
    center = true,
    size = { "980", "680" },
})

-- ============================================================================
-- [6] BUTTERY-SMOOTH MACBOOK 1:1 SLIDING WORKSPACE GESTURES & ANIMATIONS
-- ============================================================================
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4.5,
    bezier = "default",
    style = "slide",
})

hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 3.5,
    bezier = "default",
    style = "slidevert",
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3.5,
    bezier = "default",
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})


-- Night Light Toggle (Super + Shift + N)
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("bash -c \"if systemctl --user is-active hyprsunset.service >/dev/null 2>&1; then systemctl --user stop hyprsunset.service; notify-send -a 'Night Light' -i night-light-disabled -t 2000 'Night Light OFF' 'Screen back to full brightness'; else systemctl --user start hyprsunset.service; notify-send -a 'Night Light' -i night-light-enabled -t 2000 'Night Light ON' 'Warm amber filter active'; fi\""))

-- Fast Keyboard Cycle between Populated Workspaces
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("ALT + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
