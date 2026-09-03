import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: root

    property Item anchorItem
    property var panelWindow
    property bool grabReady: false

    readonly property var sections: [
        {
            title: "APPS & LAUNCHERS",
            rows: [
                { keys: "Alt + Space", action: "App launcher" },
                { keys: "Super + Enter", action: "Foot terminal" },
                { keys: "Super + B", action: "Web Browser (Chrome)" },
                { keys: "Super + Space", action: "Switch language (EN/MM)" },
                { keys: "Super + V", action: "Clipboard History" },
                { keys: "Super + I", action: "Settings (Bluetooth, Wi-Fi, Audio)" },
                { keys: "Super + E", action: "Files (Thunar)" },
                { keys: "Super + N", action: "Notepad (Mousepad)" },
                { keys: "Super + Escape", action: "Lock Screen (Hyprlock)" },
                { keys: "Super + Shift + N", action: "Toggle Night Light (Warm Amber)" },
                { keys: "Super + Q", action: "Close window" },
                { keys: "Super + F", action: "Toggle Fullscreen" },
                { keys: "Super + Shift + V", action: "Toggle Float / Tile" },
                { keys: "Super + Shift + E", action: "Log out" }
            ]
        },
        {
            title: "SCREENSHOTS (NO DISK CLUTTER)",
            rows: [
                { keys: "PrtSc (Print)", action: "Select area & copy (Ctrl+V ready, not saved)" },
                { keys: "Super + PrtSc", action: "Fullscreen copy (Ctrl+V ready)" },
                { keys: "Super + Shift + PrtSc", action: "Select area & save to Pictures" }
            ]
        },
        {
            title: "PRO WORKSPACES & SCRATCHPAD",
            rows: [
                { keys: "Super + 1…5", action: "Switch workspace (1:Web, 2:Code, 3:Term)" },
                { keys: "Super + Shift + 1…5", action: "Move window to workspace" },
                { keys: "Super + S (or ~)", action: "Toggle Magic Scratchpad" },
                { keys: "Super + Shift + S", action: "Move window to Scratchpad" },
                { keys: "Alt + Tab", action: "Cycle populated workspaces" }
            ]
        },
        {
            title: "VIM MOTIONS & RESIZE",
            rows: [
                { keys: "Super + H / J / K / L", action: "Focus Left / Down / Up / Right" },
                { keys: "Super + Shift + H/J/K/L", action: "Swap window direction" },
                { keys: "Super + Ctrl + H/J/K/L", action: "Resize window size" }
            ]
        },
        {
            title: "HARDWARE & IDLE",
            rows: [
                { keys: "Fn Volume / Brightness", action: "Keys with live OSD feedback" },
                { keys: "3-Finger Swipe", action: "1:1 Live Slide across workspaces" },
                { keys: "5 min idle", action: "Auto Lock Screen (hypridle)" },
                { keys: "8 min idle", action: "Auto Display Off" },
                { keys: "20 min idle", action: "Auto Suspend System" }
            ]
        },
        {
            title: "HELP",
            rows: [
                { keys: "Super + /", action: "This cheat sheet" }
            ]
        }
    ]

    function toggle() {
        visible ? close() : open()
    }

    function open() {
        grabReady = false
        visible = true
        grabDelay.restart()
    }

    function close() {
        grabDelay.stop()
        grabReady = false
        visible = false
    }

    implicitWidth: 400
    implicitHeight: 400
    color: "transparent"
    visible: false
    grabFocus: false

    anchor.window: panelWindow
    anchor.rect.x: panelWindow ? panelWindow.width - 12 : 0
    anchor.rect.y: panelWindow ? panelWindow.height : 0
    anchor.rect.width: 1
    anchor.rect.height: 1
    anchor.edges: Edges.Top | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Right

    Timer {
        id: grabDelay
        interval: 180
        repeat: false
        onTriggered: root.grabReady = true
    }

    HyprlandFocusGrab {
        active: root.visible && root.grabReady
        windows: [root]
        onCleared: root.close()
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Theme.bg
        border.width: 1
        border.color: Theme.border

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            Text {
                text: "KEYBINDS"
                color: Theme.accent
                font.family: "Inter"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                font.letterSpacing: 1.5
            }

            Text {
                width: parent.width
                text: "Super is the Windows key in this VM."
                color: Theme.textDim
                font.family: "Inter"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }

            Flickable {
                width: parent.width
                height: parent.height - 52
                contentHeight: sectionsColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: sectionsColumn
                    width: parent.width
                    spacing: 10

                    Repeater {
                        model: root.sections

                        Column {
                            required property var modelData
                            width: parent.width
                            spacing: 6

                            Text {
                                text: modelData.title
                                color: Theme.textMuted
                                font.family: "Inter"
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                font.letterSpacing: 1.1
                            }

                            Repeater {
                                model: modelData.rows

                                Rectangle {
                                    required property var modelData
                                    width: parent.width
                                    height: 28
                                    radius: 8
                                    color: Theme.surface

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10

                                        Text {
                                            text: modelData.keys
                                            color: Theme.accentSoft
                                            font.family: "JetBrains Mono"
                                            font.pixelSize: 11
                                        }

                                        Item { Layout.fillWidth: true }

                                        Text {
                                            text: modelData.action
                                            color: Theme.text
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
