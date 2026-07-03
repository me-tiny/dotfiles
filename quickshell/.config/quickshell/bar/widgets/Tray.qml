import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.components

Item {
    id: root
    required property var panel

    property string mode: "closed"
    property var menuRoot: null
    property var menuStack: []
    readonly property bool overlayOpen: mode !== "closed"

    property bool popupHovered: false
    readonly property bool pointerInside:
        buttonHover.containsMouse || popupHovered

    function showDrawer() {
        _beginOverlay()
        Qt.callLater(() => mode = "drawer")
    }

    function showMenuFor(item) {
        if (!item || !item.hasMenu) return
        menuRoot = item.menu
        menuStack = []
        _beginOverlay()
        Qt.callLater(() => mode = "menu")
    }

    function backToDrawer() {
        menuStack = []
        menuRoot = null
        mode = "drawer"
    }

    function pushMenu(entry) { menuStack = menuStack.concat([entry]) }
    function popMenu()        { menuStack = menuStack.slice(0, -1) }

    function closeAll() {
        mode = "closed"
        _endOverlay()
    }

    function clearMenus() {
        menuStack = []
        menuRoot = null
    }

    function _beginOverlay() {
        panel.focusable = true
        focusGrab.active = true
    }

    function _endOverlay() {
        panel.focusable = false
        focusGrab.active = false
    }

    onPointerInsideChanged: {
        if (!overlayOpen) return
        if (pointerInside) hoverDismiss.stop()
        else hoverDismiss.restart()
    }

    Timer {
        id: hoverDismiss
        interval: 150
        repeat: false
        onTriggered: { if (overlayOpen && !pointerInside) closeAll() }
    }

    HyprlandFocusGrab {
        id: focusGrab
        active: false
        windows: [ panel ]
        onCleared: closeAll()
    }

    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight

    Rectangle {
        id: button
        implicitWidth: 24
        implicitHeight: 24
        radius: Theme.rounding
        color: buttonHover.containsMouse ? Theme.hover : "transparent"

        BarText {
            anchors.centerIn: parent
            text: "\ud804\udc54"
            font.pixelSize: Theme.fontSizeIcon
        }

        MouseArea {
            id: buttonHover
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: root.mode === "drawer" ? root.closeAll() : root.showDrawer()
        }
    }


    TrayPopup {
        id: popup
        tray: root
    }
}
