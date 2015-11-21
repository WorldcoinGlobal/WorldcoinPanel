pragma Singleton
import QtQuick 2.4
import QtQuick.Window 2.2

Item {

/***** Fonts *****/
  property color coSubtitlesBigTextColor: "#1e6faf"
  property color coTitlesBigTextColor: "#1e6faf"
  property real reTitlesBigTextSize: 0.8
  property real reSubtitlesBigTextSize: 0.6
  property string srFontFamily: "Arial"

/***** Main Panel *****/
  property real reZoomDelta: 0.03
  property real reCornerRadiusCm: 0.5
  property color coMainInfoBackgroundColor: "SteelBlue"
  property color coMainInfoTextColor: "White"
  property color coMainCriticalBackgroundColor: "Red"
  property color coMainCriticalTextColor: "White"


/***** Main Title Bar *****/
  property color coMainTitleBarColor: "SteelBlue"
  property color coMainTitleTextColor: "White"
  property real reMainTitleBarHeight: 0.6
  property real reMainTitleBarRightMargin: 0.25
  property real reMainTitleBarBottomMargin: 0.08
  property real reMainTitleBarTopMargin: 0.03
  property real reMainTitleBarButtonSpace: 0.1

/***** Main Border *****/
  property color coMainTopBorderColor: coMainTitleBarColor
  property color coMainLeftBorderColor: coMainTitleBarColor
  property color coMainRightBorderColor: coMainTitleBarColor //"#00427b"
  property color coMainBottomBorderColor: "SteelBlue" //"#00427b"
  property real reMainTitleBarBorderWidth: 0.1

/***** Status Bar *****/
  property color coMainStatusBarColor: "SteelBlue"   //"#00427b"
  property color coMainStatusTextColor: "White"
  property color coMainStatusBarProccesingBackgroundColor: "#FF8C00"
  property color coMainStatusBarReadyBackgroundColor: "CadetBlue"
  property color coMainStatusBarStoppedBackgroundColor: "Gray"
  property color coMainStatusBarErrorBackgroundColor: "DarkRed"
  property real reMainStatusBarBackgroundWidth: 10
  property real reMainStatusBarRightMargin: 0.3 //reCornerRadiusCm + 0.0
  property real reMainStatusBarBottomMargin: 0
  property real reMainStatusBarTopMargin: 0.2
  property real reMainStatusBarButtonSpace: 0.1
  property real reMainStatusBarHeight: 0.8
  property real reSliderGrooveWidth: 3
  property real reSliderGrooveHeight: 0.15
  property real reSliderGrooveRadius: 0.1
  property color reSliderGrooveColor: "LightSteelBlue"
  property color reSliderHandlePressedColor: "White"
  property color reSliderHandleReleaseColor: "LightGray"
  property color reSliderHandleBorderColor: "Gray"
  property real reSliderHandleBorderWidth: 0.03
  property real reSliderHandleWidth: 0.3
  property real reSliderHandleHeight: 0.3
  property real reSliderHandleRadius: 0.1

    /***** Module Panel *****/
  property real reModulePanelBorderWidth: 0.1
  property real reModulePanelDefaultWidth: 6
  property real reModulePanelTitleHeight: 0.58
  property real reModulePanelAreaRadius: 0
  property real reModulePanelModuleRadius: 0.35
  property real reModulePanelComponentRadius: 0
  property color coModulePanelBorderColor: "SteelBlue"
  property color coModulePanelTitleBackgroudColor: "SteelBlue"
  property color coModulePanelTitleTextColor: "White"
  property color coModulePanelBackgroundColor: "#c7d4e3"
  property color coModulePanelAreaBackgroundColor: "#6B9BC3"
  property color coModulePanelModuleBackgroundColor: "#6B9BC3"
  property color coModulePanelComponentBackgroundColor: coModulePanelBackgroundColor
  property color coModulePanelHighlightedAreaBackgroundColor: "SteelBlue"
  property color coModulePanelHighlightedModuleBackgroundColor: "SteelBlue"
  property color coModulePanelHighlightedComponentBackgroundColor: "#FF8C00"
  property color coModulePanelAreaTextColor: "White"
  property color coModulePanelModuleTextColor: "White"
  property color coModulePanelComponentTextColor: "#315B7E"
  property color coModulePanelHighlightedAreaTextColor: "White"
  property color coModulePanelHighlightedModuleTextColor: "White"
  property color coModulePanelHighlightedComponentTextColor: "White"

/***** Info Bar *****/
  property color coInfoBarBackgroudColor: "LightSteelBlue"
  property color coInfoBarBottomBorderColor: "LightSteelBlue"
  property color coInfoBarTextColor: "White"
  property real reInfoBarSpacing: 0.2
  property real reInfoBarHeight: 1
  property real reInfoBarBorderWidth: reModulePanelBorderWidth

/***** Search Panel *****/
  property color coSearchPanelTitleBackgroudColor: "SteelBlue"
  property color coSearchPanelPanelBackgroudColor: "#c7d4e3"
  property color coSearchPanelBorderColor: "SteelBlue"
  property color coSearchPanelTitleTextColor: "White"
  property color coSearchPanelComponentTextColor: coSearchPanelPanelBackgroudColor
  property color coSearchPanelHighlightedTextColor: "White"
  property color coSearchPanelHighlightedBackgroundColor: "SteelBlue"
  property real reSearchPanelBorderWidth: reModulePanelBorderWidth
  property real reSearchPanelTitleHeight: 0.38
  property real reSearchPanelDefaultWidth: 0
  property real reSearchPanelDefaultHeight: 4
  property string srSearchPanelTextFontFamily: srFontFamily

/***** Log Panel *****/
  property color coLogPanelTitleBackgroudColor: "SteelBlue"
  property color coLogPanelPanelBackgroudColor: "#c7d4e3"
  property color coLogPanelBorderColor: "SteelBlue"
  property color coLogPanelTitleTextColor: "White"
  property color coLogPanelComponentTextColor: coSearchPanelPanelBackgroudColor
  property color coLogPanelHighlightedTextColor: "White"
  property color coLogPanelHighlightedBackgroundColor: "SteelBlue"
  property real reLogPanelTitleHeight: reSearchPanelTitleHeight
  property real reLogPanelHeaderHeight: 0.45
  property string srLogPanelTextFontFamily: srFontFamily

/***** Workspace *****/
  property color coWorkspaceTabBackgroudColor: "SteelBlue"
  property color coWorkspacePanelBackgroudColor: "#c7d4e3"
  property color coWorkspaceTabTextColor: "White"
  property color coWorkspaceBorderColor: "SteelBlue"
  property real reWorkspaceTabHeight: 0.5
  property real reWorkspaceTabRadius: 0.5
  property real reWorkspaceTabWidth: 3
  property string srWorkspaceTextFontFamily: srFontFamily

/***** Tables *****/
  property real reTableKeyWidth: 2.3
  property real reTableForeignKeyWidth: 2.3
  property real reTableStringWidth: 5
  property real reTableNumberWidth: 4
  property real reTableTextWidth: 15
  property real reTableCurrencyWidth: 4
  property real reTableBinWidth: 3
  property real reTableDateWidth: 2.3
  property real reTableImageWidth: 3
  property real reTableSoundWidth: 3
  property real reTableVideoWidth: 3
  property real reTableBoolWidth: 3
  property real reTableTimeWidth: 2.3
  property real reTablePercentWidth: 3
  property real reTableSecretWidth: 3

  property color coHorizontalHeaderColor: "LightSteelBlue"
  property color coHorizontalHeaderTextColor: "Black"
  property color coHorizontalHeaderBorderColor: "SteelBlue"
  property color coCellColor: "#c7d4e3"
  property color coCellTextColor: "Black"
  property color coCellBorderColor: "SteelBlue"

  property real reHorizontalHeaderHeight: 0.5
  property real reHorizontalHeaderMargin: 0.1
  property real reHorizontalHeaderBorderWidth: 0.03
  property real reCellBorderWidth: 0.01
  property real reCellHeight: 0.42
  property real reCellMargin: 0.03

/***** Component Window *****/
  property color coComponentTitleTextColor: "White"
  property color coComponentTitleBarColor: coMainTitleBarColor
  property color coComponentActiveTitleBarColor: "#315B7E"
  property color coComponentTopBorderColor: coMainTitleBarColor
  property color coComponentLeftBorderColor: coMainTitleBarColor
  property color coComponentRightBorderColor: coMainTitleBarColor
  property color coComponentBottomBorderColor: coMainTitleBarColor
  property color coComponentStatusBarColor: coMainStatusBarColor    
  property color coComponentStatusTextColor: "White"    
  property color coComponentWorkspaceColor: "LightSteelBlue"
  property real reComponentBorderWidth: 0.05
  property real reComponentCornerRadiusCm: 0.2
  property real reComponentTitleBarHeight: 0.4
  property real reComponentStatusBarHeight: 0.4
  property real reComponentTitleBarRightMargin: 0.15
  property real reComponentTitleBarBottomMargin: 0.05
  property real reComponentTitleBarTopMargin: 0.0
  property real reComponentTitleBarButtonSpace: 0.05
  property real reComponentStatusBarRightMargin: 0.2
  property real reComponentStatusBarBottomMargin: 0
  property real reComponentStatusBarTopMargin: 0.0
  property real reComponentStatusBarButtonSpace: 0.0

/***** Component *****/
  property color coComponentInternalBorderColor: "SteelBlue"
  property color coComponentHorizontalHeaderColor: "CadetBlue"
  property color coComponentVerticalHeaderColor: "#8FBBBC"
  property color coComponentHorizontalHeaderTextColor: "White"
  property color coComponentVerticalHeaderTextColor: "White"
  property color coComponentDetailBackgroundColor:  "#c7d4e3"
  property color coComponentDetailTextColor: "#315B7E"
  property color coComponentDetailHighlightBackgroundColor: "#FF8C00"
  property color coComponentDetailSubtotalBackgroundColor: "#8FBBBC"
  property color coComponentDetailSubtotalTextColor: "White"
  property color coComponentDetailTotalBackgroundColor: "#FF8C00"
  property color coComponentWarningBackgroundColor: "#FF8C00"
  property color coComponentInformationBackgroundColor: "#0000FF"
  property color coComponentWarningTextColor: "White"
  property color coComponentDetailTotalTextColor: "White"
  property color coComponentInputNeutralColor: "LightYellow"
  property color coComponentInputTextColor: "Black"
  property string srComponentFont: srFontFamily
  property real reComponentHorizontalHeaderRowHeight: 0.5
  property real reComponentRowHeight: 0.4
  property real reComponentDetailLeftMargin: 0.3
  property real reComponentDetailRightMargin: 0.5
  property real reComponentIndentation: 1
  property real reComponentItemSpace: 0.2

/***** Component Command Bar*****/
  property color coCommandBarBackgroudColor: "LightSteelBlue"
  property color coCommandBarBorderColor: "SteelBlue"
  property color coCommandBarOkButtonBorderColor: "SteelBlue"
  property color coCommandBarOkButtonReleasedColor: "SteelBlue"
  property color coCommandBarOkButtonPressedColor: "#6B9BC3"
  property color coCommandBarOkButtonDisabledColor: "DarkGray"
  property color coCommandBarOkButtonDisabledBorderColor: "DarkGray"
  property color coCommandBarOkButtonTextColor: "White"
  property color coCommandBarCancelButtonBorderColor: "#B75757" //"#983030"
  property color coCommandBarCancelButtonReleasedColor: "#B75757" // #983030"
  property color coCommandBarCancelButtonPressedColor: "#C16F6F"
  property color coCommandBarCancelButtonTextColor: "White"
  property real reCommandBarTopMargin: 0.1
  property real reCommandBarLeftMargin: 0.1
  property real reCommandBarRightMargin: 0.1
  property real reCommandBarBottomMargin: 0.1
  property real reCommandBarButtonSpace: 0.1
  property real reCommandBarDefaultHeight: 0.6
  property real reCommandBarButtonWidth: 2.5
  property real reCommandBarButtonBorderWidth: 0.05
  property real reCommandBarButtonRadius: 0.5

/***** Component Tools *****/
  property color coCheckBoxActiveBorderFocus: "SteelBlue"
  property color coCheckBoxInactiveBorderFocus: "Gray"
  property color coCheckBoxBackgroundColor: "White"
  property color coCheckBoxActiveColor: "SteelBlue"
  property color coCheckBoxTextColor: "Black"
  property real reCheckBoxHeight: 0.3
  property real reCheckBoxWidth: 0.3
  property real reCheckBoxRadius: 0.07
  property real reTextFieldRadius: 0.1
}
