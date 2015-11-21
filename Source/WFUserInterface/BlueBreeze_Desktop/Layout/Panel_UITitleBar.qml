import QtQuick 2.4
import SStyleSheet.Lib 1.0
import "../../AXLib"
import "../"

AXTitleBar {
  color: SStyleSheet.coMainTitleBarColor

  srTitleText: "Worldcoin Business Center"  
  coTitleColor: SStyleSheet.coMainTitleTextColor
  reRightMargin: SStyleSheet.reMainTitleBarRightMargin
  //reTitleSize: SStyleSheet.reMainTitleBarHeight * 0.5
  reBottomMargin: SStyleSheet.reMainTitleBarBottomMargin
  reTopMargin: SStyleSheet.reMainTitleBarTopMargin
  srTitleFontFamily: SStyleSheet.srFontFamily
  srTitleFontBold: true
  reButtonSpace: SStyleSheet.reMainTitleBarButtonSpace
  urButtonMaximizeImage: "../Images/Panel_IMMaximize.svg"
  urButtonMinimizeImage: "../Images/Panel_IMMinimize.svg"
  urButtonRestoreImage: "../Images/Panel_IMRestore.svg"
  urButtonCloseImage: "../Images/Panel_IMClose.svg"
}

