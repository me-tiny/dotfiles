import QtQuick
import QtQuick.Effects

import qs.config

RectangularShadow {
    required property var target
    parent: target.parent
    anchors.fill: target
    z: target.z - 1
    radius: target.radius
    scale: target.scale
    transformOrigin: target.transformOrigin
    opacity: target.opacity
    visible: target.visible
    blur: 12
    offset.y: 3
    color: Theme.shadow
}
