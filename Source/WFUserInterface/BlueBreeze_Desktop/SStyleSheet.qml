pragma Singleton
import QtQuick 2.4
import QtQuick.Window 2.2

Item {

/***** Fonts *****/
  property color coSubtitlesBigTextColor: "#94bfea" //"#1e6faf"
  property color coTitlesBigTextColor: "#94bfea" //"#1e6faf"
  property real reTitlesBigTextSize: 0.8
  property real reSubtitlesBigTextSize: 0.6
  property string srFontFamily: "Arial"

/***** Main Panel *****/
  property real reZoomDelta: 0.03
  property real reCornerRadiusCm: 0.5
  property color coMainInfoBackgroundColor: "#2a579a" 
  property color coMainInfoTextColor: "White"
  property color coMainCriticalBackgroundColor: "Red"
  property color coMainCriticalTextColor: "White"


/***** Main Title Bar *****/
  property color coMainTitleBarColor: "#2a579a" // "#084d96"
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
  property color coMainBottomBorderColor: "#2a579a" //"#084d96" 
  property real reMainTitleBarBorderWidth: 0.1

/***** Status Bar *****/
  property color coMainStatusBarColor: "#2a579a" //"#084d96" 
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
  property color reSliderGrooveColor: "#f1f1f1" //"LightSteelBlue"
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
  property color coModulePanelBorderColor: "#2a579a" //"#084d96"
  property color coModulePanelTitleBackgroudColor: "#2a579a"      
  property color coModulePanelTitleTextColor: "White"
  property color coModulePanelBackgroundColor: "#f1f1f1"//"White"
  property color coModulePanelAreaBackgroundColor: "#2a579a" 
  property color coModulePanelModuleBackgroundColor: "#2a579a" 
  property color coModulePanelComponentBackgroundColor: coModulePanelBackgroundColor
  property color coModulePanelHighlightedAreaBackgroundColor: "#2a579a" 
  property color coModulePanelHighlightedModuleBackgroundColor: "#08964d"
  property color coModulePanelHighlightedComponentBackgroundColor:  "#2a579a"
  property color coModulePanelAreaTextColor: "White"
  property color coModulePanelModuleTextColor: "White"
  property color coModulePanelComponentTextColor: "#315B7E"
  property color coModulePanelHighlightedAreaTextColor: "White"
  property color coModulePanelHighlightedModuleTextColor: "White"
  property color coModulePanelHighlightedComponentTextColor: "White"

/***** Info Bar *****/
  property color coInfoBarBackgroudColor: "#f1f1f1" //"#c7d4e3"
  property color coInfoBarBottomBorderColor: "#f1f1f1" //"#c7d4e3"
  property color coInfoBarSeparatorColor: "#2a579a" //"#084d96"
  property color coInfoBarTextColor: "White"
  property color coInfoBarVersionTextColor: "#706e6e" //"White"
  property real reInfoBarSpacing: 0.2
  property real reInfoBarHeight: 1
  property real reInfoBarSeparatorWidth: 0.05
  property real reInfoBarBorderWidth: reModulePanelBorderWidth

/***** Search Panel *****/
  property color coSearchPanelTitleBackgroudColor: "#2a579a"
  property color coSearchPanelPanelBackgroudColor: "#c7d4e3"
  property color coSearchPanelBorderColor: "#2a579a"
  property color coSearchPanelTitleTextColor: "White"
  property color coSearchPanelComponentTextColor: coSearchPanelPanelBackgroudColor
  property color coSearchPanelHighlightedTextColor: "White"
  property color coSearchPanelHighlightedBackgroundColor: "#2a579a"
  property real reSearchPanelBorderWidth: reModulePanelBorderWidth
  property real reSearchPanelTitleHeight: 0.38
  property real reSearchPanelDefaultWidth: 0
  property real reSearchPanelDefaultHeight: 4
  property string srSearchPanelTextFontFamily: srFontFamily

/***** Log Panel *****/
  property color coLogPanelTitleBackgroudColor: "#2a579a"
  property color coLogPanelPanelBackgroudColor: "#f1f1f1" //"#c7d4e3"
  property color coLogPanelBorderColor: "#2a579a"
  property color coLogPanelTitleTextColor: "White"
  property color coLogPanelComponentTextColor: coSearchPanelPanelBackgroudColor
  property color coLogPanelHighlightedTextColor: "White"
  property color coLogPanelHighlightedBackgroundColor:  "#f1f1f1"// "#2a579a"
  property real reLogPanelTitleHeight: reSearchPanelTitleHeight
  property real reLogPanelHeaderHeight: 0.45
  property string srLogPanelTextFontFamily: srFontFamily

/***** Workspace *****/
  property color coWorkspaceTabBackgroudColor: "#2a579a"
  property color coWorkspacePanelBackgroudColor: "#e6e6e6" //"#c7d4e3"
  property color coWorkspaceTabTextColor: "White"
  property color coWorkspaceBorderColor: "#2a579a"
  property color coWorkspaceHighlightingColor: "LightYellow"
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
  property real reTableImageWidth: 2
  property real reTableSoundWidth: 3
  property real reTableVideoWidth: 3
  property real reTableBoolWidth: 3
  property real reTableTimeWidth: 2.3
  property real reTablePercentWidth: 3
  property real reTableSecretWidth: 3
  property real reTableAddressWidth: 7
  property real reTableHashWidth: 9

  property color coHorizontalHeaderColor: "#f1f1f1" //"LightSteelBlue"
  property color coHorizontalHeaderTextColor: "Black"
  property color coHorizontalHeaderBorderColor: "#2a579a"
  property color coCellColor: "#e6e6e6"
  property color coCellTextColor: "Black"
  property color coCellBorderColor: "#2a579a"

  property real reHorizontalHeaderHeight: 0.5
  property real reHorizontalHeaderMargin: 0.1
  property real reHorizontalHeaderBorderWidth: 0.03
  property real reCellBorderWidth: 0.01
  property real reCellHeight: 0.42
  property real reCellMargin: 0.03

/***** Component Window *****/
  property color coComponentTitleTextColor: "White"
  property color coComponentTitleBarColor: coMainTitleBarColor
  property color coComponentActiveTitleBarColor: "#22467b"
  property color coComponentTopBorderColor: coMainTitleBarColor
  property color coComponentLeftBorderColor: coMainTitleBarColor
  property color coComponentRightBorderColor: coMainTitleBarColor
  property color coComponentBottomBorderColor: coMainTitleBarColor
  property color coComponentStatusBarColor: coMainStatusBarColor    
  property color coComponentStatusTextColor: "White"    
  property color coComponentWorkspaceColor: "#f1f1f1" //"#c7d4e3"
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
  property color coComponentInternalBorderColor: "#2a579a"
  property color coComponentHorizontalHeaderColor: "#ccd4da" // "CadetBlue"
  property color coComponentVerticalHeaderColor: "#8daec6" //"#8FBBBC"
  property color coComponentHorizontalHeaderTextColor: "White"
  property color coComponentVerticalHeaderTextColor: "White"
  property color coComponentDetailBackgroundColor: "#f1f1f1" //"#c7d4e3"
  property color coComponentDetailTextColor: "#315B7E"
  property color coComponentDetailHighlightBackgroundColor: "#C6a88d" //#FF8C00"
  property color coComponentDetailSubtotalBackgroundColor:"#8daec6"// "#8FBBBC"
  property color coComponentDetailSubtotalTextColor: "White"
  property color coComponentDetailTotalBackgroundColor: "#C6a88d" //"#FF8C00"
  property color coComponentWarningBackgroundColor: "#C6a88d" //"#FF8C00"
  property color coComponentInformationBackgroundColor: "#8daec6" //"#0000FF"
  property color coComponentWarningTextColor: "White"
  property color coComponentDetailTotalTextColor: "White"
  property color coComponentInputNeutralColor: "LightYellow"
  property color coComponentInputTextColor: "Black"
  property color coComponentParameterBackgroundColor: "Gray"
  property color coComponentParameterTextColor: "White"
  property string srComponentFont: srFontFamily
  property real reComponentHorizontalHeaderRowHeight: 0.5
  property real reComponentRowHeight: 0.4
  property real reComponentDetailLeftMargin: 0.3
  property real reComponentDetailRightMargin: 0.5
  property real reComponentIndentation: 1
  property real reComponentItemSpace: 0.2

/***** Component Command Bar*****/
  property color coCommandBarBackgroudColor: "#c7d4e3"
  property color coCommandBarBorderColor: "#2a579a"
  property color coCommandBarOkButtonBorderColor: "#2a579a"
  property color coCommandBarOkButtonReleasedColor: "#2a579a"
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
  property real reCommandBarButtonWidth: 3
  property real reCommandBarButtonBorderWidth: 0.05
  property real reCommandBarButtonRadius: 0.5

/***** Component Tools *****/
  property color coCheckBoxActiveBorderFocus: "#2a579a"
  property color coCheckBoxInactiveBorderFocus: "Gray"
  property color coCheckBoxBackgroundColor: "White"
  property color coCheckBoxActiveColor: "#2a579a"
  property color coCheckBoxInactiveColor: "Gray"
  property color coCheckBoxTextColor: "Black"
  property color coComboBoxTextColor: "Black"
  property color coComboBoxIndicatorActiveColor: "DarkGray"
  property color coComboBoxIndicatorInactiveColor: "Gray"
  property color coComboBoxBackgroundColor: "White"
  property color coToolTipBackgroundColor: "LightYellow"
  property color coToolTipTextColor: "DarkGray"
  property real reCheckBoxHeight: 0.3
  property real reCheckBoxWidth: 0.3
  property real reCheckBoxRadius: 0.07
  property real reComboBoxRadius: 0.1
  property real reTextFieldRadius: 0.1
  property real reToolTipRadius: 0.2
}
