import QtQuick 2.4
import ACMeasures.Lib 1.0

Rectangle {
  id: rcRoot
  property real reHeightCm
  property real reWidthCm
  color: "transparent"

 /* Component.onCompleted: {
    rcRoot.height = Math.round(ACMeasures.fuToDots(rcRoot.reHeightCm))
    rcRoot.width = Math.round(ACMeasures.fuToDots(rcRoot.reWidthCm))
  }*/
  height: Math.round(ACMeasures.fuToDots(reHeightCm))
  width: Math.round(ACMeasures.fuToDots(reWidthCm))
}

