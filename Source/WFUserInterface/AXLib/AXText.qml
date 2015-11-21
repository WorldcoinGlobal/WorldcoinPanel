import QtQuick 2.4
import ACMeasures.Lib 1.0

Text{
  id: txRoot
  property int inAnimationDuration: mCXDefinitions.mAnimationDuration
  property real reHeightCm
  property real reWidthCm
  property real reSizeCm
  property real reHorizontalCenterOffsetCm: 0
  property real reVerticalCenterOffsetCm: 0

  scale: mCXDefinitions.mZoomFactor
  anchors.horizontalCenterOffset: ACMeasures.fuToDots(reHorizontalCenterOffsetCm) * mCXDefinitions.mZoomFactor
  anchors.verticalCenterOffset: ACMeasures.fuToDots(reVerticalCenterOffsetCm) * mCXDefinitions.mZoomFactor

  Behavior on font.pixelSize {
    NumberAnimation {
      duration: txRoot.inAnimationDuration
    }
  }
  Component.onCompleted: {
    txRoot.height = Math.round(ACMeasures.fuToDots(txRoot.reHeightCm))
    txRoot.width = Math.round(ACMeasures.fuToDots(txRoot.reWidthCm))
    txRoot.font.pixelSize = ACMeasures.fuToDots(reSizeCm)
  }
}

