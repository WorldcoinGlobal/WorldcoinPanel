import QtQuick 2.4
import SStyleSheet.Lib 1.0
import "../../AXLib"
import "../"

AXStatusBar {
  color: SStyleSheet.coMainStatusBarColor
  coTextColor: SStyleSheet.coMainStatusTextColor
  coProccesingBackgroundColor: SStyleSheet.coMainStatusBarProccesingBackgroundColor
  coReadyBackgroundColor: SStyleSheet.coMainStatusBarReadyBackgroundColor
  coStoppedBackgroundColor: SStyleSheet.coMainStatusBarStoppedBackgroundColor
  coErrorBackgroundColor: SStyleSheet.coMainStatusBarErrorBackgroundColor
  reBarBackgroundWidth: SStyleSheet.reMainStatusBarBackgroundWidth
  reRightMargin: SStyleSheet.reMainStatusBarRightMargin
  reTextSize: SStyleSheet.reMainStatusBarHeight * 0.4
  reBottomMargin: SStyleSheet.reMainStatusBarBottomMargin
  reTopMargin: SStyleSheet.reMainStatusBarTopMargin
  srTextFontFamily: SStyleSheet.srFontFamily
  srTextFontBold: false
  reButtonSpace: SStyleSheet.reMainStatusBarButtonSpace

  reSliderGrooveWidth: SStyleSheet.reSliderGrooveWidth
  reSliderGrooveHeight: SStyleSheet.reSliderGrooveHeight
  reSliderGrooveRadius: SStyleSheet.reSliderGrooveRadius
  reSliderGrooveColor: SStyleSheet.reSliderGrooveColor
  reSliderHandlePressedColor: SStyleSheet.reSliderHandlePressedColor
  reSliderHandleReleaseColor: SStyleSheet.reSliderHandleReleaseColor
  reSliderHandleBorderColor: SStyleSheet.reSliderHandleBorderColor
  reSliderHandleBorderWidth: SStyleSheet.reSliderHandleBorderWidth
  reSliderHandleWidth: SStyleSheet.reSliderHandleWidth
  reSliderHandleHeight: SStyleSheet.reSliderHandleHeight
  reSliderHandleRadius: SStyleSheet.reSliderHandleRadius
  urZoomIn: "../Images/StatusBar_IMZoomIn.png"
  urZoomOut: "../Images/StatusBar_IMZoomOut.png"

  boMainWindow: true
}

