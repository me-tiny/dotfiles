import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.config
import qs.components
import qs.services as Services

PanelWindow {
    id: win

    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    visible: Services.Notifications.popups.length > 0 || drawer.height > 0
    anchors { top: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    exclusiveZone: 0
    color: "transparent"
    surfaceFormat.opaque: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:notifications"

    implicitWidth: 444 + Theme.edgeMargin + Theme.popupRounding
    implicitHeight: Theme.barExtent + Theme.popoutSpace
    mask: Region { item: drawer }

    Item {
        id: drawer
        z: 1
        x: Theme.popupRounding
        y: Theme.edgeMargin + Theme.barHeight - 0.5
        width: 444
        height: Services.Notifications.popups.length > 0
                ? Math.min(Theme.popoutSpace, lv.contentHeight + 24) : 0
        clip: true

        Behavior on height {
            NumberAnimation { duration: Theme.popupAnimMs; easing.type: Easing.OutCubic }
        }
        AttachedSurface { target: drawer; borderlessRight: true }

        ListView {
            id: lv
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            model: ScriptModel { values: Services.Notifications.popups }

            delegate: NotificationCard {
                required property var modelData
                width: ListView.view.width
                notif: modelData
                popup: true
            }

            displaced: Transition {
                NumberAnimation { property: "y"; duration: Theme.popupAnimMs; easing.type: Easing.OutCubic }
            }
        }
    }
}
