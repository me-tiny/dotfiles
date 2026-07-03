import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.config
import qs.components

RowLayout {
    id: root
    required property var panel

    TextMetrics {
        id: digitMetrics
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Font.Bold
        font.variableAxes: ({ "wght": Font.Bold, "GRAD": Theme.fontGrade })
        font.features: ({ "tnum": 1 })
        text: "0"
    }

    readonly property int em: Math.max(1, Math.round(digitMetrics.advanceWidth))
    spacing: Math.round(em * 0.15)

    Repeater {
        model: ScriptModel {
            values: [...Hyprland.workspaces.values]
                .filter(ws => ws.id > 0 && ws.monitor?.name === root.panel.screen.name)
                .sort((a, b) => a.id - b.id)
        }

        Rectangle {
            id: cell
            required property var modelData

            Layout.fillHeight: true
            color: "transparent"

            readonly property int padX: Math.round(root.em * 0.25)
            readonly property bool isFocused: Hyprland.focusedWorkspace === modelData

            readonly property int minCell: Math.round(root.em * 1.2)
            Layout.preferredWidth: Math.max(minCell, Math.ceil(label.contentWidth) + padX * 2)

            BarText {
                id: label
                text: cell.modelData.id
                color: cell.isFocused ? Theme.teal : Theme.overlay
                weight: Font.Bold
                tabular: true
                anchors.centerIn: parent
            }

            TextMetrics {
                id: ink
                font: label.font
                text: label.text
            }

            Rectangle {
                height: Math.max(2, Math.round(root.em * 0.18))
                width: Math.ceil(ink.tightBoundingRect.width)
                x: Math.round(label.x + ink.tightBoundingRect.x)
                color: Theme.mauve
                anchors.bottom: parent.bottom
                opacity: cell.isFocused ? 1 : 0
            }

            MouseArea {
                anchors.fill: parent
                onClicked: cell.modelData.activate()
            }
        }
    }
}
