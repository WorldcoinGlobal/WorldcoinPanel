import QtQuick 2.4
import ACMeasures.Lib 1.0
import SStyleSheet.Lib 1.0

import "../../AXLib"

AXSubWindow {
  id: wiSubWindow

  coComponentTopBorderColor: SStyleSheet.coComponentTopBorderColor
  coComponentRightBorderColor: SStyleSheet.coComponentRightBorderColor
  coComponentLeftBorderColor: SStyleSheet.coComponentLeftBorderColor
  coComponentBottomBorderColor: SStyleSheet.coComponentBottomBorderColor
  coComponentWorkspaceColor: SStyleSheet.coComponentWorkspaceColor
  reComponentBorderWidth: SStyleSheet.reComponentBorderWidth
  reComponentCornerRadiusCm: SStyleSheet.reComponentCornerRadiusCm
  reComponentTitleBarHeight: SStyleSheet.reComponentTitleBarHeight
  reComponentStatusBarHeight: SStyleSheet.reComponentStatusBarHeight
  reCommandBarHeight: SStyleSheet.reCommandBarDefaultHeight

  urComponentTitleBar: "Panel_UIComponentTitleBar.qml"
  urComponentStatusBar: "./Panel_UIComponentStatusBar.qml"
 // urWorkspace: "./Panel_UIWorkspace.qml"
}

