import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.config
import qs.components

Rectangle {
    id: popout
    required property var tray

    Component.onCompleted: {
        parent = tray.panel.contentItem
        tray.panel.popout = popout
    }

    readonly property int tuck: 2
    z: -1
    clip: true

    anchors.top: parent.top
    anchors.topMargin: Theme.barHeight - tuck
    anchors.right: parent.right

    property string view: "drawer"

    readonly property bool open: tray.mode !== "closed"
    readonly property bool engaged: open || height > 0
    visible: engaged

    readonly property int drawerWidth: Math.max(1, Math.min(340, drawerRow.implicitWidth + 16))
    readonly property int menuWidth: Math.max(260, Math.min(420, menuCol.implicitWidth + 16))

    readonly property int contentHeight: Math.min(
        Theme.popoutSpace,
        view === "menu" ? menuCol.implicitHeight + 16 + tuck
                        : drawerCol.implicitHeight)

    onEngagedChanged: if (!engaged) tray.clearMenus()

    onOpenChanged: if (open) keys.forceActiveFocus()

    width: view === "menu" ? menuWidth : drawerWidth
    height: open ? contentHeight : 0

    Behavior on height { NumberAnimation { duration: Theme.popupAnimMs; easing.type: Easing.OutCubic } }
    Behavior on width  { NumberAnimation { duration: Theme.popupAnimMs; easing.type: Easing.OutCubic } }

    color: Theme.base
    radius: Theme.popupRounding
    topLeftRadius: 0
    topRightRadius: 0
    bottomRightRadius: 0

    HoverHandler {
        onHoveredChanged: popout.tray.popupHovered = hovered
    }

    FocusScope {
        id: keys
        focus: popout.open
        Keys.onEscapePressed: (e) => { popout.tray.closeAll(); e.accepted = true }
    }

    Connections {
        target: popout.tray
        function onModeChanged() {
            if (popout.tray.mode !== "closed")
                popout.view = popout.tray.mode
        }
    }

    QsMenuOpener {
        id: opener
        menu: popout.tray.menuStack.length > 0
              ? popout.tray.menuStack[popout.tray.menuStack.length - 1]
              : popout.tray.menuRoot
    }

    Column {
        id: drawerCol
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        visible: popout.view === "drawer"
        padding: 8
        topPadding: 8 + popout.tuck
        spacing: 6

        RowLayout {
            id: drawerRow
            spacing: 4

            Repeater {
                model: SystemTray.items
                delegate: Rectangle {
                    id: iconCell
                    required property var modelData

                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    radius: Theme.rounding
                    color: iconHover.containsMouse ? Theme.hover : "transparent"

                    IconImage {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: iconCell.modelData.icon
                    }

                    MouseArea {
                        id: iconHover
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.LeftButton) {
                                iconCell.modelData.activate()
                                popout.tray.closeAll()
                            } else if (mouse.button === Qt.RightButton) {
                                popout.tray.showMenuFor(iconCell.modelData)
                            }
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: menuCol
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        anchors.topMargin: 8 + popout.tuck
        visible: popout.view === "menu"
        spacing: 2

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 28
            radius: Theme.rounding
            color: backHover.containsMouse ? Theme.hover : "transparent"

            readonly property bool nested: popout.tray.menuStack.length > 0

            BarText {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                text: parent.nested ? "\udb80\udf11 Back" : "\udb80\udf11 Tray"
                font.pixelSize: Theme.fontSizeSmall
            }

            MouseArea {
                id: backHover
                anchors.fill: parent
                hoverEnabled: true
                onClicked: parent.nested ? popout.tray.popMenu()
                                         : popout.tray.backToDrawer()
            }
        }

        Repeater {
            model: opener.children
            delegate: Rectangle {
                id: entry
                required property var modelData

                Layout.fillWidth: true
                implicitWidth: entryRow.implicitWidth + 16
                implicitHeight: modelData.isSeparator ? 10 : 28
                radius: Theme.rounding
                color: "transparent"
                opacity: modelData.enabled ? 1 : 0.45

                Rectangle {
                    visible: entry.modelData.isSeparator
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 1
                    color: Theme.overlay
                    opacity: 0.6
                }

                Rectangle {
                    visible: !entry.modelData.isSeparator
                    anchors.fill: parent
                    radius: Theme.rounding
                    color: hover.containsMouse ? Theme.hover : "transparent"

                    RowLayout {
                        id: entryRow
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 8

                        BarText {
                            visible: entry.modelData.buttonType !== QsMenuButtonType.None
                            text: {
                                const checked = entry.modelData.checkState === Qt.Checked
                                return entry.modelData.buttonType === QsMenuButtonType.RadioButton
                                    ? (checked ? "\udb81\udc3e" : "\udb81\udc3d")
                                    : (checked ? "\udb80\udd32" : "\udb80\udd31")
                            }
                            color: entry.modelData.checkState === Qt.Checked
                                ? Theme.teal : Theme.overlay
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        IconImage {
                            visible: entry.modelData.icon !== ""
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            source: entry.modelData.icon
                        }

                        BarText {
                            Layout.fillWidth: true
                            text: entry.modelData.text
                            font.pixelSize: Theme.fontSizeSmall
                            elide: Text.ElideRight
                        }

                        BarText {
                            visible: entry.modelData.hasChildren
                            text: "\u203a"
                            color: Theme.overlay
                            font.pixelSize: Theme.fontSizeSmall
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: entry.modelData.enabled && !entry.modelData.isSeparator
                        onClicked: {
                            if (entry.modelData.hasChildren) {
                                popout.tray.pushMenu(entry.modelData)
                            } else {
                                entry.modelData.triggered()
                                popout.tray.closeAll()
                            }
                        }
                    }
                }
            }
        }
    }
}
