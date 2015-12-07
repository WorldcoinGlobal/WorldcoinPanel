import QtQuick 2.4
import ACMeasures.Lib 1.0

Rectangle {
  id: rcRoot
  width: height
  color: "Transparent"
  property url urIcon
  signal siClicked()

  Image {
    anchors.fill: parent
    fillMode: Image.Stretch
    source: urIcon
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium
    /*HueSaturation {
      id: hsUpdatesPressedEffect
      anchors.fill: parent
      source: imUpdates
      hue: 0
      saturation: 0
      lightness: 0
    }*/
  }
  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
   // onEntered: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness + 0.15; }
   // onExited: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness - 0.15; }
   // onPressed: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness + 0.3; }
   // onReleased: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness - 0.3; }
    onClicked: { siClicked(); }
  }
}

