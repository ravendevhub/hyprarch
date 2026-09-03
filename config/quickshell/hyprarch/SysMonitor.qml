import QtQuick
import Quickshell
import Quickshell.Io

// ============================================================
// SysMonitor.qml — CPU / RAM / GPU / Net stats pill for bar
// Runs bar-sysinfo --watch every 2s via Process
// ============================================================
Item {
    id: root

    // Published stats — bind these in shell.qml
    property int   cpuPct:   0
    property int   cpuTemp:  0
    property int   ramPct:   0
    property int   ramMb:    0
    property int   ramTotal: 0
    property var   gpuUtil:  null   // null = no NVIDIA GPU data
    property var   gpuTemp:  null
    property var   gpuVram:  null
    property var   gpuVramTotal: null
    property string netRx:  "— KB/s"
    property string netTx:  "— KB/s"

    readonly property string iconFont: "Symbols Nerd Font"
    readonly property string uiFont:   "Inter"

    // ── Colour helpers ──────────────────────────────────────
    function cpuColor() {
        if (cpuPct >= 85) return "#ff6b6b"   // hot red
        if (cpuPct >= 60) return "#ffd166"   // warn amber
        return "#7dd3fc"                      // cool cyan
    }
    function gpuColor() {
        if (gpuUtil === null) return "#7dd3fc"
        if (gpuUtil >= 85)  return "#ff6b6b"
        if (gpuUtil >= 50)  return "#ffd166"
        return "#c084fc"                      // GPU violet
    }
    function tempColor(t) {
        if (t === null || t === undefined) return "#7dd3fc"
        if (t >= 85) return "#ff6b6b"
        if (t >= 70) return "#ffd166"
        return "#7dd3fc"
    }
    function ramColor() {
        if (ramPct >= 85) return "#ff6b6b"
        if (ramPct >= 70) return "#ffd166"
        return "#4ade80"                      // ram green
    }

    // ── Poll process ────────────────────────────────────────
    Process {
        id: sysProc
        running: true
        command: ["bash", "-c", "while true; do bar-sysinfo; sleep 2; done"]
        stdout: SplitParser {
            onRead: line => {
                try {
                    var d = JSON.parse(line)
                    root.cpuPct   = d.cpu_pct   ?? 0
                    root.cpuTemp  = d.cpu_temp  ?? 0
                    root.ramPct   = d.ram_pct   ?? 0
                    root.ramMb    = d.ram_used  ?? 0
                    root.ramTotal = d.ram_total ?? 0
                    root.gpuUtil  = (d.gpu_util !== undefined && d.gpu_util !== null) ? d.gpu_util : null
                    root.gpuTemp  = (d.gpu_temp !== undefined && d.gpu_temp !== null) ? d.gpu_temp : null
                    root.gpuVram  = (d.gpu_vram !== undefined && d.gpu_vram !== null) ? d.gpu_vram : null
                    root.gpuVramTotal = (d.gpu_vram_total !== undefined && d.gpu_vram_total !== null) ? d.gpu_vram_total : null
                    root.netRx    = d.net_rx ?? "—"
                    root.netTx    = d.net_tx ?? "—"
                } catch(e) {}
            }
        }
    }

    // ── Visual pill ─────────────────────────────────────────
    implicitWidth:  statsRow.implicitWidth + 20
    implicitHeight: 30

    Rectangle {
        anchors.fill: parent
        radius: 9
        color: "#0f1b2d"
        border.color: "#1e3a5f"
        border.width: 1

        Row {
            id: statsRow
            anchors.centerIn: parent
            spacing: 10

            // ── CPU ────────────────────────────────────────
            Row {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "\uf4bc"
                    font.family: root.iconFont
                    font.pixelSize: 11
                    color: root.cpuColor()
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: root.cpuPct + "%"
                    font.family: root.uiFont
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: root.cpuColor()
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    visible: root.cpuTemp > 0
                    text: root.cpuTemp + "°"
                    font.family: root.uiFont
                    font.pixelSize: 10
                    color: root.tempColor(root.cpuTemp)
                    verticalAlignment: Text.AlignVCenter
                    opacity: 0.8
                }
            }

            // ── separator ──────────────────────────────────
            Text {
                text: "·"
                color: "#1e3a5f"
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }

            // ── RAM ────────────────────────────────────────
            Row {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "\uf538"
                    font.family: root.iconFont
                    font.pixelSize: 11
                    color: root.ramColor()
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: root.ramPct + "%"
                    font.family: root.uiFont
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: root.ramColor()
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // ── separator ──────────────────────────────────
            Text {
                visible: root.gpuUtil !== null
                text: "·"
                color: "#1e3a5f"
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }

            // ── GPU ────────────────────────────────────────
            Row {
                visible: root.gpuUtil !== null
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "\uf26e"
                    font.family: root.iconFont
                    font.pixelSize: 11
                    color: root.gpuColor()
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: (root.gpuUtil !== null ? root.gpuUtil : 0) + "%"
                    font.family: root.uiFont
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: root.gpuColor()
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    visible: root.gpuTemp !== null
                    text: (root.gpuTemp !== null ? root.gpuTemp : 0) + "°"
                    font.family: root.uiFont
                    font.pixelSize: 10
                    color: root.tempColor(root.gpuTemp)
                    verticalAlignment: Text.AlignVCenter
                    opacity: 0.8
                }
            }

            // ── separator ──────────────────────────────────
            Text {
                text: "·"
                color: "#1e3a5f"
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }

            // ── Network ────────────────────────────────────
            Row {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "\uf0ab"
                    font.family: root.iconFont
                    font.pixelSize: 10
                    color: "#22d3ee"
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: root.netRx
                    font.family: root.uiFont
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    color: "#22d3ee"
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: "\uf0aa"
                    font.family: root.iconFont
                    font.pixelSize: 10
                    color: "#f472b6"
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: root.netTx
                    font.family: root.uiFont
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    color: "#f472b6"
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
