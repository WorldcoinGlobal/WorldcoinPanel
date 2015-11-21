import QtQuick 2.4
import ACMeasures.Lib 1.0
import SStyleSheet.Lib 1.0
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.3
import "../../AXLib"
import "../"

AXWindow {
  id: panel

  title: "Worldcoin Business Center"
  modality: Qt.ApplicationModal
  srFontFamily: SStyleSheet.srFontFamily
  coTextColor: SStyleSheet.coMainTitleTextColor
  coTopBorderColor: SStyleSheet.coMainTopBorderColor
  coRightBorderColor: SStyleSheet.coMainRightBorderColor
  coLeftBorderColor: SStyleSheet.coMainLeftBorderColor
  coBottomBorderColor: SStyleSheet.coMainBottomBorderColor
  reBorderWidth: SStyleSheet.reMainTitleBarBorderWidth
  reCornerRadiusCm: SStyleSheet.reCornerRadiusCm
  reTitleBarHeight: SStyleSheet.reMainTitleBarHeight
  reStatusBarHeight: SStyleSheet.reMainStatusBarHeight
  reModulePanelDefaultWidth: SStyleSheet.reModulePanelDefaultWidth
  reZoomDelta: SStyleSheet.reZoomDelta
  coInfoBackgroundColor: SStyleSheet.coMainInfoBackgroundColor
  coInfoTextColor: SStyleSheet.coMainInfoTextColor
  coCriticalBackgroundColor: SStyleSheet.coMainCriticalBackgroundColor
  coCriticalTextColor: SStyleSheet.coMainCriticalTextColor

  reWidthCm: {
    var vaWidth
    if(mCXDefinitions.mWidth < 0) vaWidth = ACMeasures.reAvailableWidth * 0.8
    else vaWidth = mCXDefinitions.mWidth
    return vaWidth
  }
  reHeightCm: {
    var vaHeight
    if(mCXDefinitions.mHeight < 0) vaHeight = ACMeasures.reAvailableHeight * 0.8
    else vaHeight = mCXDefinitions.mHeight
    return vaHeight
  }
  reMinimumWidthCm: 10
  reMinimumHeightCm: 8
  reMinimumZoom: 0.5
  reMaximumZoom: 2

  urTitleBar: "./Panel_UITitleBar.qml"
  urStatusBar: "./Panel_UIStatusBar.qml"
  urModulePanel: "./Panel_UIModulePanel.qml"
  urInfoBar: "./Panel_UIInfoBar.qml"
  urSearchPanel: "./Panel_UISearchPanel.qml"
  urLogPanel: "./Panel_UILogPanel.qml"
  urWorkspace: "./Panel_UIWorkspace.qml"
 // urResizeHandlerImage: "../Images/StatusBar_IMResizeHandler.png"
  boFullPanel: true
}

