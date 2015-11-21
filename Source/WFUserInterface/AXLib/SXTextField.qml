import QtQuick 2.4
import QtQuick.Controls.Styles 1.3
import ACMeasures.Lib 1.0

TextFieldStyle {
  property real reHeightCm
  property real reRadius
  property color coBackgroundColor

  renderType: Text.QtRendering
  background: Rectangle {
    id: rcBox
    radius: ACMeasures.fuToDots(reRadius)
    color: coBackgroundColor
    implicitHeight: ACMeasures.fuToDots(reHeightCm)
    border.width: 0
  }
}
