import QtQuick 2.4
import ACMeasures.Lib 1.0
import SStyleSheet.Lib 1.0
import QtQuick.Window 2.2
import "../../AXLib"
import "../"

AXWindow {
  id: xwSplash

  title: "Splash Window"
  modality: Qt.ApplicationModal
  reCornerRadiusCm: SStyleSheet.reCornerRadiusCm
  reWidthCm: 20
  reHeightCm: 13
  reZoomDelta: SStyleSheet.reZoomDelta
  urBackgroundImage: "../Images/SplashScreen_IMSplashScreen.png"

  property int inTimeoutInterval: 5000
  signal siTimeout

  Rectangle {
    color:  "transparent"
    anchors.fill: parent

    AXText  {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      reHorizontalCenterOffsetCm: -3.2
      reVerticalCenterOffsetCm: 1.5
      text: "Worldcoin BC"
      reSizeCm: SStyleSheet.reTitlesBigTextSize
      font.bold: true
      font.family: SStyleSheet.srFontFamily
      color: SStyleSheet.coTitlesBigTextColor
    }

    AXText  {
      id: version
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      reHorizontalCenterOffsetCm: -3.2
      reVerticalCenterOffsetCm: 3
      text: mCXDefinitions.mCurrentVersion + " " + mCXDefinitions.mCurrentVersionName
      reSizeCm: SStyleSheet.reSubtitlesBigTextSize
      font.family: SStyleSheet.srFontFamily
      color: SStyleSheet.coSubtitlesBigTextColor
    }
  }
  Timer {
    interval: inTimeoutInterval
    running: true
    repeat: false
    onTriggered: {
      xwSplash.visible = false
      xwSplash.siTimeout()
    }
  }
}

