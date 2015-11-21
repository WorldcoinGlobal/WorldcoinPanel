import QtQuick 2.4
import ACMeasures.Lib 1.0

Image {
  id: imRoot
  property int inAnimationDuration: mCXDefinitions.mAnimationDuration
  property real reHeightCm
  property real reWidthCm

  Component.onCompleted: {
    height = ACMeasures.fuToDots(reHeightCm)
    width = ACMeasures.fuToDots(reWidthCm)
  }
}

