# 🌌 HyprArch - Vivobook 16 Edition

A highly curated, modern, and aesthetic **Hyprland + Quickshell** desktop setup for Arch Linux on ASUS Vivobook 16 (Intel i5-13420H + NVIDIA RTX 3050).

![Classic Nordic Twilight](wallpapers/classic-nordic.jpg)

---

## ✨ Features

- **Compositor:** Hyprland with dual Intel + NVIDIA hybrid GPU acceleration (`AQ_DRM_DEVICES`).
- **Display:** Smooth 144Hz high refresh rate (`1920x1200 @ 144Hz`).
- **Top Bar:** Quickshell native status bar with live real-time hardware metrics (CPU temp/util, RAM, NVIDIA GPU temp/util, Network Rx/Tx speed).
- **Lockscreen:** Custom `hyprlock` lockscreen with classic Nordic Gaussian blur, digital clock, live battery %, and custom profile avatar.
- **Boot Security:** Instant auto-lock on boot (`hyprlock-login.service`) demanding password before desktop access.
- **Power Management:** `hypridle` daemon (4m screen dim, 5m auto-lock, 8m display sleep, 20m system suspend).
- **Night Light:** `hyprsunset` blue light filter toggled via `Super + Shift + N` (Warm amber 3500K).
- **Terminal:** Foot terminal with 82% frosted translucent glassmorphism and JetBrains Mono typography.
- **IDE Polish:** Antigravity IDE configured with **Catppuccin Mocha** palette, smooth caret animation, rainbow bracket pairs, and font ligatures.
- **Bluetooth Policy:** Default-off on boot (`AutoEnable=false`) to preserve battery.
- **Fast Screenshots:** Area selection screenshot copied directly to clipboard on `PrtSc` (zero disk clutter, ready for `Ctrl + V`).

---

## ⌨️ Keybinds Cheat Sheet

| Shortcut | Action |
|---|---|
| <kbd>Alt</kbd> + <kbd>Space</kbd> | Application Launcher |
| <kbd>Super</kbd> + <kbd>Enter</kbd> | Frosted Glass Foot Terminal |
| <kbd>Super</kbd> + <kbd>B</kbd> | Google Chrome |
| <kbd>Super</kbd> + <kbd>E</kbd> | File Manager (Thunar) |
| <kbd>Super</kbd> + <kbd>V</kbd> | Clipboard History |
| <kbd>Super</kbd> + <kbd>I</kbd> | Settings (Bluetooth, Wi-Fi, Audio) |
| <kbd>Super</kbd> + <kbd>Escape</kbd> | Lock Screen (`hyprlock`) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> | Toggle Night Light (Warm Amber) |
| <kbd>PrtSc</kbd> | Select Area & Copy to Clipboard (`Ctrl + V`) |
| <kbd>Super</kbd> + <kbd>PrtSc</kbd> | Fullscreen Copy to Clipboard |
| <kbd>Super</kbd> + <kbd>1…5</kbd> | Switch Workspaces |
| <kbd>Super</kbd> + <kbd>H/J/K/L</kbd> | Vim Direction Focus |
| <kbd>Super</kbd> + <kbd>/</kbd> | Keybind Cheat Sheet Overlay |

---

## 🚀 Installation

```bash
git clone https://github.com/ravendevhub/hyprarch.git ~/.config/hyprarch
cd ~/.config/hyprarch
chmod +x setup-vivobook.sh
./setup-vivobook.sh
```

---

## 📜 License

MIT License © 2026 Raven Dev (`ravendevhub`)
