import QtQuick 2.4
import SStyleSheet.Lib 1.0
import "../../AXLib"
import "../"

AXTitleBar {
  color: mActive ? SStyleSheet.coComponentActiveTitleBarColor : SStyleSheet.coComponentTitleBarColor

  srTitleText: "---"
  coTitleColor: SStyleSheet.coComponentTitleTextColor
  reRightMargin: SStyleSheet.reComponentTitleBarRightMargin
 // reTitleSize: SStyleSheet.reComponentTitleBarHeight * 0.8
  reBottomMargin: SStyleSheet.reComponentTitleBarBottomMargin
  reTopMargin: SStyleSheet.reComponentTitleBarTopMargin
  srTitleFontFamily: SStyleSheet.srFontFamily
  srTitleFontBold: false
  reButtonSpace: SStyleSheet.reComponentTitleBarButtonSpace
 // urButtonMaximizeImage: "../Images/Panel_IMMaximize.png"
 // urButtonMinimizeImage: "../Images/Panel_IMMinimize.png"
  urButtonCloseImage: "../Images/Panel_IMClose.png"
}

