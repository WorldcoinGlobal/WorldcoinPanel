pragma Singleton
import QtQuick 2.4
import QtQuick.Window 2.2

Window {
  visible: false
  property real reConvFactor:  Screen.pixelDensity * 10
  property real reAvailableHeight: fuToCentimeters(Screen.height)
  property real reAvailableWidth: fuToCentimeters(Screen.width)
  function fuToDots(reCentimeters) {
    var vaScaleFactor = reCentimeters * reConvFactor
    return vaScaleFactor;
  }
  function fuToCentimeters(inDots) {
    var vaScaleFactor = inDots / reConvFactor
    return vaScaleFactor;
  }
}

