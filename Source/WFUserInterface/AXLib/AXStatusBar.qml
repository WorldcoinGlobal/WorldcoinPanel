import QtQuick 2.4
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
  id: rcStatusBar

  property color coTextColor
  property real reTextSize
  property string srText
  property string srTextFontFamily
  property bool srTextFontBold
  property color coProccesingBackgroundColor
  property color coReadyBackgroundColor
  property color coStoppedBackgroundColor
  property color coErrorBackgroundColor
  property real reBorderWidth
  property real reTopMargin
  property real reRightMargin
  property real reBottomMargin
  property real reButtonSpace    
  property real reBarBackgroundWidth
  property real reMinimumZoom
  property real reMaximumZoom
  property bool boMainWindow
  property point poClickPos
  property real reSliderGrooveWidth
  property real reSliderGrooveHeight
  property real reSliderGrooveRadius
  property color reSliderGrooveColor
  property color reSliderHandlePressedColor
  property color reSliderHandleReleaseColor
  property color reSliderHandleBorderColor
  property real reSliderHandleBorderWidth
  property real reSliderHandleWidth
  property real reSliderHandleHeight
  property real reSliderHandleRadius
  property url urZoomIn
  property url urZoomOut

  signal siStatusBarPressed
  signal siZoomChanged(real reValue)
  signal siWindowMoved(point poDelta)

//  property url urButtonNetworkImage
//  property url urButtonEncryptedImage

  MouseArea {
    id: maRoot
    anchors.fill: parent
    cursorShape: Qt.SizeAllCursor
    onPressed: {
      poClickPos = Qt.point(mouse.x,mouse.y)
      rcStatusBar.siStatusBarPressed()
    }
    onPositionChanged: {
      var vaDelta = Qt.point(mouse.x - poClickPos.x, mouse.y - poClickPos.y)
      siWindowMoved(vaDelta)
    }
  }
  Rectangle {
    id: rcBackground
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    color: {
      if(mCXStatus.mDaemonStatus == CXDefinitions.EServiceReady) return coReadyBackgroundColor
      if(mCXStatus.mDaemonStatus == CXDefinitions.EServiceStopped) return coStoppedBackgroundColor
      if(mCXStatus.mDaemonStatus == CXDefinitions.EServiceError) return coErrorBackgroundColor
      return coProccesingBackgroundColor
    }
    clip: true
//    anchors.topMargin: ACMeasures.fuToDots(reBorderWidth)
//    anchors.bottomMargin: ACMeasures.fuToDots(reBottomMargin + reBorderWidth)
    width: ACMeasures.fuToDots(reBarBackgroundWidth) < (parent.width - ACMeasures.fuToDots(reRightMargin * 2)) ? ACMeasures.fuToDots(reBarBackgroundWidth) : (parent.width - ACMeasures.fuToDots(reRightMargin * 2))
    radius: height / 3
    height: parent.height * 0.5 //- ACMeasures.fuToDots(reBorderWidth) - ACMeasures.fuToDots(reBottomMargin) - ACMeasures.fuToDots(reTopMargin) -30
    Rectangle {
      id: rcSync
      anchors.top: rcBackground.top
      anchors.bottom: rcBackground.bottom
      anchors.left: rcBackground.left
      width: {
        if(WNTotalBlockCount.mValue > 0 && mCXStatus.mDaemonStatus == CXDefinitions.EServiceReady) {
          var vaValue = rcBackground.width * WABlockCount.mValue / WNTotalBlockCount.mValue
          var vaPercent = 100 * WABlockCount.mValue / WNTotalBlockCount.mValue
          if(vaValue >= rcBackground.width) {
            srText = qsTr("Ready!")
            return 0
          }
          srText = qsTr("Synchronizing ... ") + vaPercent.toFixed(2) + " %"
          return vaValue
        }
        return 0
      }
      clip: true
      color: {
        if(WNTotalBlockCount.mValue > 0 && mCXStatus.mDaemonStatus == CXDefinitions.EServiceReady) return coProccesingBackgroundColor
        return "Transparent"
      }
      radius: rcBackground.radius
    }
    Text  {
      id: txText
      color: coTextColor
      anchors.fill: parent
      text: srText
      font.family: srTextFontFamily
      font.bold: srTextFontBold
      font.pixelSize: ACMeasures.fuToDots(reTextSize) * mCXDefinitions.mZoomFactor
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
  }

  Row {
    id: roRow
    anchors.fill: parent
  //  anchors.topMargin: ACMeasures.fuToDots(reBorderWidth + reTopMargin) * mCXDefinitions.mZoomFactor
    anchors.rightMargin: ACMeasures.fuToDots(reRightMargin) * mCXDefinitions.mZoomFactor
    anchors.bottomMargin: ACMeasures.fuToDots(reBottomMargin) * mCXDefinitions.mZoomFactor
    spacing: ACMeasures.fuToDots(reButtonSpace)
    layoutDirection: Qt.RightToLeft
    Text  {
      id: txValue
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      visible: boMainWindow
      color: coTextColor
      text: "   " + Math.round(slZoomSlider.value * 100) + " %"
      font.family: srTextFontFamily
      font.bold: srTextFontBold
      font.pixelSize: parent.height * 0.4
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
    Text  {
      id: txMaximumZoom
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      visible: boMainWindow
      color: coTextColor
      text: reMaximumZoom + "x"
      font.family: srTextFontFamily
      font.bold: srTextFontBold
      font.pixelSize: parent.height * 0.4
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
    Image {
      id: imZoomIn
      fillMode: Image.Stretch
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: ACMeasures.fuToDots(reBorderWidth)
      anchors.bottomMargin: ACMeasures.fuToDots(reBorderWidth)

      width: height
      source: urZoomIn
      sourceSize.height: mCXDefinitions.ESizeTiny
      sourceSize.width: mCXDefinitions.ESizeTiny
    }
    Slider {
      property bool boSliderPressed

      id: slZoomSlider
      maximumValue: reMaximumZoom
      minimumValue: reMinimumZoom
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      tickmarksEnabled: true
      updateValueWhileDragging: false
      value: mCXDefinitions.mZoomFactor
      stepSize: 0
      style : SliderStyle {
        groove: Rectangle {
          implicitWidth: ACMeasures.fuToDots(reSliderGrooveWidth) * mCXDefinitions.mZoomFactor
          implicitHeight: ACMeasures.fuToDots(reSliderGrooveHeight) * mCXDefinitions.mZoomFactor
          color: reSliderGrooveColor
          radius: ACMeasures.fuToDots(reSliderGrooveRadius) * mCXDefinitions.mZoomFactor
        }
        handle: Rectangle {
          anchors.centerIn: parent
          color: control.pressed ? reSliderHandlePressedColor : reSliderHandleReleaseColor
          border.color: reSliderHandleBorderColor
          border.width: ACMeasures.fuToDots(reSliderHandleBorderWidth) * mCXDefinitions.mZoomFactor
          width: ACMeasures.fuToDots(reSliderHandleWidth) * mCXDefinitions.mZoomFactor
          height: ACMeasures.fuToDots(reSliderHandleHeight) * mCXDefinitions.mZoomFactor
          radius: ACMeasures.fuToDots(reSliderHandleRadius) * mCXDefinitions.mZoomFactor
        }
      }
      onValueChanged: {
        if(boSliderPressed) siZoomChanged(slZoomSlider.value)
        boSliderPressed = false
      }
      onPressedChanged: { boSliderPressed = true }
    }
    Image {
      id: imZoomOut
      fillMode: Image.Stretch
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: ACMeasures.fuToDots(reBorderWidth)
      anchors.bottomMargin: ACMeasures.fuToDots(reBorderWidth)


      width: height
      source: urZoomOut
      sourceSize.height: mCXDefinitions.ESizeTiny
      sourceSize.width: mCXDefinitions.ESizeTiny
    }
    Text  {
      id: txMinimumZoom
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      visible: boMainWindow
      color: coTextColor
      text: reMinimumZoom + "x"
      font.family: srTextFontFamily
      font.bold: srTextFontBold
      font.pixelSize: parent.height * 0.4
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
  }
  Connections {
    target: mCXStatus
    onSStatusTextChanged: { if(boMainWindow) srText = lStatusText }
  }
}

