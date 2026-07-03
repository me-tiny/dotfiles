import Quickshell
import QtQuick

import qs.config

PanelWindow {
    id: panel
    required property var modelData
    screen: modelData
    property Item popout: null
    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight + Theme.popoutSpace
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: Theme.barHeight
    color: "transparent"
    surfaceFormat.opaque: false

    mask: Region {
        item: barArea
        regions: [
            Region { item: panel.popout }
        ]
    }

    Rectangle {
        id: barArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.barHeight
        color: Theme.base

        Left { panel: panel }
        Center { }
        Right { panel: panel }
    }
}
