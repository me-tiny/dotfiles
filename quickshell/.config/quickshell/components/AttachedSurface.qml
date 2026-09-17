import QtQuick
import QtQuick.Shapes

import qs.config

Shape {
    id: surface
    required property Item target
    property bool flushRight: true
    property bool borderlessRight: false
    readonly property real join: Math.min(Theme.popupRounding, target.height / 2)
    readonly property real cap: 1
    readonly property real bodyLeft: join
    readonly property real bodyRight: bodyLeft + target.width - (borderlessRight ? 0 : 0.5)
    readonly property real bodyBottom: height - 0.5
    readonly property real corner: Math.min(Theme.popupRounding, target.height / 2)
    readonly property real rightCorner: borderlessRight ? 0 : corner

    parent: target.parent
    x: target.x - join
    y: target.y - cap
    width: target.width + join * (flushRight ? 1 : 2) - (flushRight && !borderlessRight ? 0.5 : 0)
    height: target.height + cap
    z: target.z - 0.1
    visible: target.visible && target.height > 0
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        fillColor: Theme.shellSurface
        strokeColor: "transparent"
        startX: 0; startY: 0
        PathLine { x: surface.width; y: 0 }
        PathLine { x: surface.width; y: surface.flushRight ? 0 : surface.cap }
        PathQuad {
            controlX: surface.bodyRight; controlY: surface.cap
            x: surface.bodyRight; y: surface.flushRight ? surface.cap : surface.cap + surface.join
        }
        PathLine { x: surface.bodyRight; y: surface.bodyBottom - surface.rightCorner }
        PathQuad { controlX: surface.bodyRight; controlY: surface.bodyBottom; x: surface.bodyRight - surface.rightCorner; y: surface.bodyBottom }
        PathLine { x: surface.bodyLeft + surface.corner; y: surface.bodyBottom }
        PathQuad { controlX: surface.bodyLeft; controlY: surface.bodyBottom; x: surface.bodyLeft; y: surface.bodyBottom - surface.corner }
        PathLine { x: surface.bodyLeft; y: surface.cap + surface.join }
        PathQuad { controlX: surface.bodyLeft; controlY: surface.cap; x: 0; y: surface.cap }
        PathLine { x: 0; y: 0 }
    }

    ShapePath {
        fillColor: "transparent"
        strokeColor: Theme.outline
        strokeWidth: 1
        startX: 0; startY: surface.cap
        PathQuad { controlX: surface.bodyLeft; controlY: surface.cap; x: surface.bodyLeft; y: surface.cap + surface.join }
        PathLine { x: surface.bodyLeft; y: surface.bodyBottom - surface.corner }
        PathQuad { controlX: surface.bodyLeft; controlY: surface.bodyBottom; x: surface.bodyLeft + surface.corner; y: surface.bodyBottom }
        PathLine { x: surface.bodyRight - surface.rightCorner; y: surface.bodyBottom }
        PathQuad { controlX: surface.bodyRight; controlY: surface.bodyBottom; x: surface.bodyRight; y: surface.bodyBottom - surface.rightCorner }
        PathLine { x: surface.bodyRight; y: surface.borderlessRight ? surface.bodyBottom : surface.flushRight ? 0 : surface.cap + surface.join }
        PathQuad {
            controlX: surface.bodyRight; controlY: surface.borderlessRight ? surface.bodyBottom : surface.flushRight ? 0 : surface.cap
            x: surface.width; y: surface.borderlessRight ? surface.bodyBottom : surface.flushRight ? 0 : surface.cap
        }
    }
}
