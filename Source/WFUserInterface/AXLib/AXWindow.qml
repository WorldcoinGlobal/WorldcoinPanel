import QtQuick 2.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import ACMeasures.Lib 1.0
import WFCore.Lib 1.0
import WFDefinitions.Lib 1.0

GXWindow {
  id: wiRoot
  flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window
  color: "transparent"

  property real reCornerRadiusCm
  property real reHeightCm
  property real reWidthCm
  property real reZoomDelta
  property real reMinimumZoom
  property real reMaximumZoom
  property url urBackgroundImage

  Rectangle {
    id: rcMask
    anchors.fill: parent // omMask
    color: "white"
    radius: ACMeasures.fuToDots(reCornerRadiusCm)
    visible: false
  }
  OpacityMask {
    id: omMask
    source: rcBackground
    maskSource: rcMask
    visible: true
    anchors.fill: parent
    focus: true

    Component.onCompleted: {
      wiRoot.height = ACMeasures.fuToDots(wiRoot.reHeightCm) //* mCXDefinitions.mZoomFactor
      wiRoot.width = ACMeasures.fuToDots(wiRoot.reWidthCm) //* mCXDefinitions.mZoomFactor
      wiRoot.x = (Screen.width - wiRoot.width) / 2
      wiRoot.y = (Screen.height - wiRoot.height) / 2
    }
  }
  Rectangle {
    id: rcBackground
    anchors.fill: omMask
    visible: false
    AXImage {
      fillMode: Image.Stretch
      anchors.fill: parent
      source: urBackgroundImage
    }
  }
}

