import QtQuick 2.4
import QtQuick.Controls.Styles 1.3
import ACMeasures.Lib 1.0

CheckBoxStyle {
  property color coActiveBorderFocus
  property color coInactiveBorderFocus
  property color coBackgroundColor
  property color coActiveColor
  property color coInactiveColor
  property color coTextColor
  property string srFontFamily
  property real reHeightCm
  property real reWidthCm
  property real reCheckBoxRadius

  indicator: Rectangle {
    color: coBackgroundColor
    implicitWidth: ACMeasures.fuToDots(reWidthCm)
    implicitHeight: ACMeasures.fuToDots(reHeightCm)
    radius: ACMeasures.fuToDots(reCheckBoxRadius)
    border.color: control.activeFocus ? coActiveBorderFocus : coInactiveBorderFocus
    border.width: 1
    Rectangle {
      visible: control.checked
      color: control.enabled ? coActiveColor : coInactiveColor
      border.color: coActiveColor
      radius: reCheckBoxRadius
      anchors.margins: ACMeasures.fuToDots(reHeightCm) * 0.2
      anchors.fill: parent
    }
  }
  label: Text {
    height: control.height * 0.8
    color: coTextColor
    text: control.text
    verticalAlignment: Text.AlignVCenter
    font.family: srFontFamily
    font.bold: false
    font.italic: false
  }
}
