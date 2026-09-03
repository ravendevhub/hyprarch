#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# HyprArch Safe Setup for ASUS Vivobook 16 (Arch Linux)
# - Preserves GNOME and GDM completely (Zero package deletion)
# - Installs HyprArch (Hyprland + Quickshell + UWSM + Themes)
# - Adds Intel + NVIDIA RTX 3050 Dual GPU configuration (AQ_DRM_DEVICES)
# - Adds session guards so HyprArch services only run when logged into Hyprland
# ==============================================================================

PROJECT_DIR="/home/raven/Projects/laptopconfig"
REPO="$PROJECT_DIR/hyprarch"
CFG="$REPO/config"
SCRIPTS="$REPO/scripts"
USER_NAME=$(id -un)

echo "=== [1/6] Sudo Authorization ==="
echo "Enter your sudo password to install the required HyprArch packages:"
sudo -v

echo "=== [2/6] Installing Required Packages from Arch Repositories ==="
PACKAGES=(
    quickshell
    foot
    terminus-font
    inter-font
    ttf-jetbrains-mono
    ttf-nerd-fonts-symbols
    noto-fonts
    papirus-icon-theme
    imv
    nsxiv
    thunar
    tumbler
    thunar-volman
    mousepad
    chromium
    swaybg
    cliphist
    hyprpolkitagent
    ffmpeg
    dconf
    wl-clipboard
    qt6-wayland
    qt6-gtk-platformtheme
    hyprlock
    wofi
)

install_list=()
for pkg in "${PACKAGES[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
        install_list+=("$pkg")
    else
        echo "Note: Package $pkg not found in repos, skipping."
    fi
done

sudo pacman -S --needed --noconfirm "${install_list[@]}"

echo "=== [3/6] User Permissions & Video Groups ==="
sudo usermod -aG video,render,audio,input,storage "$USER_NAME" || true

echo "=== [4/6] Setting Up User Configurations in $HOME ==="
install -d \
    "$HOME/.config/hypr" \
    "$HOME/.config/uwsm" \
    "$HOME/.config/quickshell/hyprarch" \
    "$HOME/.config/systemd/user" \
    "$HOME/.config/systemd/user/at-spi-dbus-bus.service.d" \
    "$HOME/.config/foot" \
    "$HOME/.config/gtk-3.0" \
    "$HOME/.config/gtk-4.0" \
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml" \
    "$HOME/.config/nsxiv" \
    "$HOME/.config/hyprarch" \
    "$HOME/.config/autostart" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/applications" \
    "$HOME/.local/share/backgrounds/hyprarch" \
    "$HOME/.local/share/gtksourceview-4/styles"

# --- Hyprland Lua Config ---
cat > "$HOME/.config/hypr/hyprland.lua" <<'EOF'
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
            enabled = false,
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
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("loginctl lock-session"))
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

-- Fast Keyboard Cycle between Populated Workspaces
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("ALT + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
EOF


# --- Classic Hyprlock Lockscreen ---
cat > "$HOME/.config/hypr/hyprlock.conf" <<'EOF'
# ==============================================================================
# HYPRLOCK CLASSIC AESTHETIC CONFIGURATION
# Tailored for ASUS Vivobook with Nordic Twilight Theme & Custom Avatar
# ==============================================================================

general {
    disable_loading_bar = true
    hide_cursor = false
    grace = 2
    no_fade_in = false
}

# --- Background with Soft Ambient Blur ---
background {
    monitor =
    path = /home/raven/.local/share/backgrounds/hyprarch/current
    color = rgba(15, 23, 42, 1.0)

    # Ambient Depth Blur
    blur_passes = 2
    blur_size = 6
    noise = 0.0117
    contrast = 0.8916
    brightness = 0.8172
    vibrancy = 0.1696
}

# --- Big Classic Digital Clock ---
label {
    monitor =
    text = cmd[update:1000] echo "$(date +"%H:%M")"
    color = rgba(248, 250, 252, 0.95)
    font_size = 76
    font_family = JetBrains Mono ExtraBold
    shadow_passes = 2
    shadow_size = 4
    shadow_color = rgba(0, 0, 0, 0.4)
    position = 0, 240
    halign = center
    valign = center
}

# --- Classic Date Subtitle ---
label {
    monitor =
    text = cmd[update:1000] echo "$(date +"%A, %d %B %Y")"
    color = rgba(148, 163, 184, 0.9)
    font_size = 17
    font_family = Inter Medium
    shadow_passes = 1
    shadow_size = 2
    shadow_color = rgba(0, 0, 0, 0.3)
    position = 0, 175
    halign = center
    valign = center
}

# --- Custom Programmer Avatar Widget ---
image {
    monitor =
    path = /home/raven/.config/hypr/profile.jpg
    size = 135
    rounding = -1
    border_size = 3
    border_color = rgba(125, 211, 252, 0.85)
    rotate = 0
    reload_time = -1

    shadow_passes = 2
    shadow_size = 8
    shadow_color = rgba(0, 0, 0, 0.5)

    position = 0, 45
    halign = center
    valign = center
}

# --- User Welcome Prompt ---
label {
    monitor =
    text = Welcome back, $USER
    color = rgba(226, 232, 240, 0.85)
    font_size = 15
    font_family = Inter SemiBold
    position = 0, -50
    halign = center
    valign = center
}

# --- Translucent Frosted Glass Password Field ---
input-field {
    monitor =
    size = 280, 48
    outline_thickness = 2
    dots_size = 0.28
    dots_spacing = 0.25
    dots_center = true
    dots_rounding = -1
    outer_color = rgba(125, 211, 252, 0.6)
    inner_color = rgba(15, 23, 42, 0.65)
    font_color = rgb(248, 250, 252)
    fade_on_empty = false
    placeholder_text = <span foreground="##94a3b8"><i>Enter Password...</i></span>
    hide_input = false
    check_color = rgb(56, 189, 248)
    fail_color = rgb(248, 113, 113)
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
    capslock_color = rgb(250, 204, 21)
    position = 0, -115
    halign = center
    valign = center
}

# --- Battery Indicator (Bottom Right) ---
label {
    monitor =
    text = cmd[update:5000] echo "⚡ $(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)%"
    color = rgba(148, 163, 184, 0.7)
    font_size = 12
    font_family = JetBrains Mono
    position = -30, 25
    halign = right
    valign = bottom
}

# --- Layout/Status Indicator (Bottom Left) ---
label {
    monitor =
    text = ASUS Vivobook 16 • HyprArch
    color = rgba(148, 163, 184, 0.5)
    font_size = 11
    font_family = Inter
    position = 30, 25
    halign = left
    valign = bottom
}
EOF

# --- UWSM Environment ---
cat > "$HOME/.config/uwsm/env" <<EOF
export PATH="\${HOME}/.local/bin:\${PATH}"
export XCURSOR_SIZE=24
export HYPRCURSOR_SIZE=24
export XCURSOR_THEME=Adwaita
export GTK_THEME=Adwaita:dark
export GTK_ICON_THEME=Hyprarch
export ADW_DISABLE_PORTAL=1
export QT_QPA_PLATFORMTHEME=gtk3
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0"
EOF

# --- Quickshell QML Files ---
for qml in "$CFG/quickshell/hyprarch/"*.qml; do
    sed -e "s|$HOME|$HOME|g" "$qml" > "$HOME/.config/quickshell/hyprarch/$(basename "$qml")"
done

# --- Systemd User Services with ConditionEnvironment Guard ---
cat > "$HOME/.config/systemd/user/hyprarch-shell.service" <<EOF
[Unit]
Description=HyprArch Quickshell panel
Documentation=https://quickshell.org/docs/v0.3.1/
PartOf=graphical-session.target
After=graphical-session.target wayland-wm@hyprland.desktop.service
ConditionEnvironment=XDG_CURRENT_DESKTOP=Hyprland

[Service]
Type=simple
ExecStart=/usr/bin/qs --no-duplicate --config hyprarch
Restart=on-failure
RestartSec=2
TimeoutStopSec=10

[Install]
WantedBy=graphical-session.target
EOF

cat > "$HOME/.config/systemd/user/hyprarch-wallpaper.service" <<EOF
[Unit]
Description=HyprArch wallpaper
PartOf=graphical-session.target
After=graphical-session.target wayland-wm@hyprland.desktop.service
ConditionEnvironment=XDG_CURRENT_DESKTOP=Hyprland

[Service]
Type=simple
ExecStart=/usr/bin/swaybg -i %h/.local/share/backgrounds/hyprarch/current -m fill
Restart=on-failure
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=graphical-session.target
EOF

cat > "$HOME/.config/systemd/user/cliphist-text.service" <<EOF
[Unit]
Description=HyprArch clipboard history (text)
PartOf=graphical-session.target
After=graphical-session.target
ConditionEnvironment=XDG_CURRENT_DESKTOP=Hyprland

[Service]
Type=simple
ExecStart=/usr/bin/wl-paste --type text --watch /usr/bin/cliphist store
Restart=on-failure
RestartSec=2

[Install]
WantedBy=graphical-session.target
EOF

cat > "$HOME/.config/systemd/user/cliphist-image.service" <<EOF
[Unit]
Description=HyprArch clipboard history (image)
PartOf=graphical-session.target
After=graphical-session.target
ConditionEnvironment=XDG_CURRENT_DESKTOP=Hyprland

[Service]
Type=simple
ExecStart=/usr/bin/wl-paste --type image --watch /usr/bin/cliphist store
Restart=on-failure
RestartSec=2

[Install]
WantedBy=graphical-session.target
EOF

install -m 644 "$CFG/systemd/user/at-spi-dbus-bus.service.d/session-cleanup.conf" \
    "$HOME/.config/systemd/user/at-spi-dbus-bus.service.d/"

# --- Foot, GTK & App Configs ---
install -m 644 "$CFG/foot/foot.ini" "$HOME/.config/foot/foot.ini"
install -m 644 "$CFG/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
install -m 644 "$CFG/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
install -m 644 "$CFG/xfce4/xfconf/xfce-perchannel-xml/thunar.xml" \
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
install -m 644 "$CFG/nsxiv/Xresources" "$HOME/.config/nsxiv/Xresources"
install -m 644 "$CFG/gtksourceview-4/styles/hyprarch.xml" \
    "$HOME/.local/share/gtksourceview-4/styles/hyprarch.xml"
install -m 644 "$CFG/applications/"*.desktop "$HOME/.local/share/applications/"

# --- Helper Scripts ---
install -m 755 "$SCRIPTS/hyprarch-set-wallpaper" "$HOME/.local/bin/"
install -m 755 "$SCRIPTS/hyprarch-imv" "$HOME/.local/bin/"
install -m 755 "$SCRIPTS/hyprarch-icon-theme" "$HOME/.local/bin/"
install -m 755 "$SCRIPTS/hyprarch-apply-theme" "$HOME/.local/bin/"
if [[ -x $SCRIPTS/chromium ]]; then
    install -m 755 "$SCRIPTS/chromium" "$HOME/.local/bin/chromium"
fi
sed -i "s|^Exec=hyprarch-imv|Exec=$HOME/.local/bin/hyprarch-imv|" \
    "$HOME/.local/share/applications/imv.desktop"

# --- Wallpapers Setup ---
BG_DIR="$HOME/.local/share/backgrounds/hyprarch"
if command -v ffmpeg >/dev/null 2>&1; then
    bash "$SCRIPTS/make-packed-wallpapers.sh" "$BG_DIR" || true
fi

# Fallback wallpaper if needed
if [[ -f "$REPO/docs/images/hyprarch-screenshot.jpg" ]]; then
    cp "$REPO/docs/images/hyprarch-screenshot.jpg" "$BG_DIR/hyprarch-art.jpg"
fi

DEFAULT_WP="$BG_DIR/dusk-navy.jpg"
if [[ ! -f "$DEFAULT_WP" && -f "$BG_DIR/hyprarch-art.jpg" ]]; then
    DEFAULT_WP="$BG_DIR/hyprarch-art.jpg"
fi

if [[ -f "$DEFAULT_WP" ]]; then
    ln -sfn "$DEFAULT_WP" "$BG_DIR/current"
    printf '%s\n' "$DEFAULT_WP" > "$HOME/.config/hyprarch/wallpaper"
fi

echo "=== [5/6] Generating Icons & Enabling User Services ==="
bash "$HOME/.local/bin/hyprarch-icon-theme" || true

systemctl --user daemon-reload || true
systemctl --user enable \
    hyprarch-shell.service \
    hyprarch-wallpaper.service \
    cliphist-text.service \
    cliphist-image.service || true
systemctl --user enable hyprpolkitagent.service 2>/dev/null || true

update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "=== [6/6] Checking GDM and GNOME Integrity ==="
echo "Verifying GNOME & GDM are safe and untouched:"
pacman -Q gdm gnome-shell gnome-session
systemctl is-enabled gdm.service || true

echo ""
echo "================================================================="
echo "  HYPRARCH SETUP COMPLETE!"
echo "  - GNOME and GDM have been completely preserved."
echo "  - HyprArch is installed and ready."
echo "  - To use HyprArch: Log out of GNOME -> click your user ->"
echo "    click the gear icon (⚙️) -> select 'Hyprland (uwsm-managed)'"
echo "================================================================="
