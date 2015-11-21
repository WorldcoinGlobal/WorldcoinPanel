import QtQuick 2.4
import SStyleSheet.Lib 1.0
import "../../AXLib"
import "../"

AXStatusBar {
  color: SStyleSheet.coComponentStatusBarColor
  coTextColor: SStyleSheet.coComponentStatusTextColor
  reRightMargin: SStyleSheet.reComponentStatusBarRightMargin
  reTextSize: SStyleSheet.reComponentStatusBarHeight * 0.4
  reBottomMargin: SStyleSheet.reComponentStatusBarBottomMargin
  reTopMargin: SStyleSheet.reComponentStatusBarTopMargin
  srTextFontFamily: SStyleSheet.srFontFamily
  srTextFontBold: false
  reButtonSpace: SStyleSheet.reComponentStatusBarButtonSpace  
  boMainWindow: false
}

