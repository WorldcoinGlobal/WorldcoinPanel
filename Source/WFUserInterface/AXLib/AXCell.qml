import QtQuick 2.4
import ACMeasures.Lib 1.0
import SStyleSheet.Lib 1.0
import QtQuick.Controls 1.3

Rectangle {
  id: rcRoot
  property real reHeightCm
  property real reLeftMargin
  property real reBorderWidth
  property real reBottomBorderWidth
  property real reTextRelativeSize
  property alias imIcon: imType.source
  property alias coTextColor: xtTitle.color
  property alias coBorderColor: rcBorder.color
  property alias srText: xtTitle.text
  property alias inHAlignment: xtTitle.horizontalAlignment
  clip: true
  height: Math.round(ACMeasures.fuToDots(reHeightCm) * mCXDefinitions.mZoomFactor)
  //height: xtTitle.paintedHeight * 3//+ rcBorder.height + rcBottomBorder.height
  Image {
    id: imType
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: parent.height * 1/4
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height * 1/4
    anchors.leftMargin: Math.round(ACMeasures.fuToDots(reLeftMargin) * mCXDefinitions.mZoomFactor)
    width: height
    sourceSize.height: mCXDefinitions.ESizeTiny
    sourceSize.width: mCXDefinitions.ESizeTiny
  }
  TextEdit {
    id: xtTitle
    anchors.top: parent.top
    anchors.left: imType.right
    anchors.leftMargin: Math.round(ACMeasures.fuToDots(reLeftMargin) * mCXDefinitions.mZoomFactor)
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    selectByMouse: true
    readOnly: true
    font.pixelSize: parent.height * reTextRelativeSize // SStyleSheet.reCellHeight * reTextRelativeSize
    verticalAlignment: Text.AlignVCenter
  }
  Rectangle {
    id: rcBorder
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    width: Math.round(ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor)
  }
  Rectangle {
    id: rcBottomBorder
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    color: rcBorder.color
    height: Math.round(ACMeasures.fuToDots(reBottomBorderWidth) * mCXDefinitions.mZoomFactor)
  }
}

