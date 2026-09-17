import Quickshell
import QtQuick

import qs.config
import qs.components

PanelWindow {
    id: panel
    required property var modelData
    screen: modelData
    property Item popout: null
    property Item popoutBridge: null
    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barExtent + Theme.popoutSpace + 16
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: Theme.barExtent
    color: "transparent"
    surfaceFormat.opaque: false

    mask: Region {
        item: barArea
        regions: [
            Region { item: panel.popout },
            Region { item: panel.popoutBridge }
        ]
    }

    Rectangle {
        id: barArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Theme.edgeMargin
        height: Theme.barHeight
        color: Theme.shellSurface

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Theme.outline
        }

        SurfaceShadow { target: barArea; blur: 8; offset.y: 2 }

        Left { panel: panel }
        Center { }
        Right { panel: panel }
    }
}
