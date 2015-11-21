import QtQuick 2.4
import QtGraphicalEffects 1.0
import ACMeasures.Lib 1.0

Rectangle {
  id: rcTitleBar

  property alias coTitleColor: txTitle.color
 // property alias reTitleSize: txTitle.reSizeCm
  property alias srTitleText: txTitle.text
  property alias srTitleFontFamily: txTitle.font.family  
  property alias srTitleFontBold: txTitle.font.bold  
  property alias reTitleWidth : txTitle.contentWidth
  property bool boMouseEnabled: true
  property bool boMainWindowMaximized
  property real reBorderWidth
  property real reTopMargin
  property real reRightMargin
  property real reBottomMargin
  property real reButtonSpace
  property point poClickPos
  property url urButtonMaximizeImage
  property url urButtonMinimizeImage
  property url urButtonRestoreImage
  property url urButtonCloseImage

  signal siCloseButtonClicked
  signal siMinimizeButtonClicked
  signal siMaximizeButtonClicked
  signal siTitleBarPressed
  signal siWindowMoved(point poDelta)
  MouseArea {
    id: maRoot
    anchors.fill: parent
    enabled: boMouseEnabled
    cursorShape: Qt.SizeAllCursor
    preventStealing: true
    onPressed: {
      poClickPos = Qt.point(mouse.x,mouse.y)
      rcTitleBar.siTitleBarPressed()
    }
    onDoubleClicked: { siMaximizeButtonClicked() }
    onPositionChanged: {
      var vaDelta = Qt.point(mouse.x - poClickPos.x, mouse.y - poClickPos.y)
      siWindowMoved(vaDelta)
    }
  }
  Text {
    id: txTitle
    anchors.fill: parent
    anchors.topMargin: ACMeasures.fuToDots(reBorderWidth + reTopMargin)  * mCXDefinitions.mZoomFactor
    anchors.bottomMargin: ACMeasures.fuToDots(reBottomMargin) * mCXDefinitions.mZoomFactor
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: parent.height * 0.6
  }
  Row {
    anchors.fill: parent
    anchors.topMargin: ACMeasures.fuToDots(reBorderWidth + reTopMargin) * mCXDefinitions.mZoomFactor
    anchors.rightMargin: ACMeasures.fuToDots(reRightMargin) * mCXDefinitions.mZoomFactor
    anchors.bottomMargin: ACMeasures.fuToDots(reBottomMargin)  * mCXDefinitions.mZoomFactor
    spacing: ACMeasures.fuToDots(reButtonSpace)
    layoutDirection: Qt.RightToLeft
    Rectangle {
      id: rcCloseButton
      color: "transparent"
      anchors.top: parent.top
      height: parent.height
      width: height      
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        enabled: boMouseEnabled
        onClicked: { siCloseButtonClicked() }
      //  onEntered: { hsPressedEffectClose.saturation = hsPressedEffectClose.saturation + 0.3; }
      //  onExited: { hsPressedEffectClose.saturation = hsPressedEffectClose.saturation - 0.3; }
      //  onPressed: { hsPressedEffectClose.saturation = hsPressedEffectClose.saturation + 0.8; }
      //  onReleased: { hsPressedEffectClose.saturation = hsPressedEffectClose.saturation - 0.8; }
      }
      Image {
        id: imCloseButton
        anchors.fill: parent
        source: urButtonCloseImage
        sourceSize.height: mCXDefinitions.ESizeSmall
        sourceSize.width: mCXDefinitions.ESizeSmall

      }
    /*  HueSaturation {
        id: hsPressedEffectClose
        anchors.fill: parent
        source: imCloseButton
        hue: 0
        saturation: 0
        lightness: 0
      }*/
    }
    Rectangle {
      id: rcMaximizeButton
      color: "transparent"
      anchors.top: parent.top
      height: parent.height
      width: height
      visible: urButtonMaximizeImage.toString() == "" ? false : true
      Image {
        id: imMaximizeButton
        anchors.fill: parent
        source: boMainWindowMaximized ? urButtonRestoreImage : urButtonMaximizeImage
        sourceSize.height: mCXDefinitions.ESizeSmall
        sourceSize.width: mCXDefinitions.ESizeSmall
      }
      MouseArea {
        anchors.fill: parent
        enabled: boMouseEnabled
        hoverEnabled: true
        onClicked: { siMaximizeButtonClicked();}
       // onEntered: { hsPressedEffectMaximize.saturation = hsPressedEffectMaximize.saturation + 0.5; }
       // onExited: { hsPressedEffectMaximize.saturation = hsPressedEffectMaximize.saturation - 0.5; }
       // onPressed: { hsPressedEffectMaximize.saturation = hsPressedEffectMaximize.saturation + 0.7; }
       // onReleased: { hsPressedEffectMaximize.saturation = hsPressedEffectMaximize.saturation - 0.7; }

      }
     /* HueSaturation {
        id: hsPressedEffectMaximize
        anchors.fill: parent
        source: rcMaximizeButton
        hue: 0
        saturation: 0
        lightness: 0
      }*/
    }
    Rectangle {
      id: rcMinimizeButton
      color: "transparent"
      anchors.top: parent.top
      height: parent.height
      width: height      
      visible: urButtonMinimizeImage.toString() == "" ? false : true

      Image {
        id: imMinimizeButton
        anchors.fill: parent
        source: urButtonMinimizeImage
        sourceSize.height: mCXDefinitions.ESizeSmall
        sourceSize.width: mCXDefinitions.ESizeSmall
      }
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        enabled: boMouseEnabled
        onClicked: { siMinimizeButtonClicked(); }
      //  onEntered: { hsPressedEffectMinimize.saturation = hsPressedEffectMinimize.saturation + 0.5; }
      //  onExited: { hsPressedEffectMinimize.saturation = hsPressedEffectMinimize.saturation - 0.5; }
      //  onPressed: { hsPressedEffectMinimize.saturation = hsPressedEffectMinimize.saturation + 0.7; }
       // onReleased: { hsPressedEffectMinimize.saturation = hsPressedEffectMinimize.saturation - 0.7; }

      }
      /*HueSaturation {
        id: hsPressedEffectMinimize
        anchors.fill: parent
        source: imMinimizeButton
        hue: 0
        saturation: 0
        lightness: 0
      }*/
    }
  }
}

