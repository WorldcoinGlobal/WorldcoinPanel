import QtQuick 2.4
import ACMeasures.Lib 1.0

TextEdit {
  id: txRoot
  clip: true
  property real reHeightCm
  property real reWidthCm
  property real reSizeCm
  property real reHorizontalCenterOffsetCm: 0
  property real reVerticalCenterOffsetCm: 0

  anchors.horizontalCenterOffset: ACMeasures.fuToDots(reHorizontalCenterOffsetCm) * mCXDefinitions.mZoomFactor
  anchors.verticalCenterOffset: ACMeasures.fuToDots(reVerticalCenterOffsetCm) * mCXDefinitions.mZoomFactor
  height: ACMeasures.fuToDots(txRoot.reHeightCm)
  width: ACMeasures.fuToDots(txRoot.reWidthCm)
  font.pixelSize: ACMeasures.fuToDots(reSizeCm)

 /* Component.onCompleted: {
    txRoot.height = ACMeasures.fuToDots(txRoot.reHeightCm)
    txRoot.width = ACMeasures.fuToDots(txRoot.reWidthCm)
    txRoot.font.pixelSize = ACMeasures.fuToDots(reSizeCm)
  }*/
}

