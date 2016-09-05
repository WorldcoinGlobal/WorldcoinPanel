import QtQuick 2.4
import SStyleSheet.Lib 1.0
import "../../AXLib"
import "../"

AXLogPanel {
  coTitleBackgroudColor: SStyleSheet.coLogPanelTitleBackgroudColor
  coPanelBackgroudColor: SStyleSheet.coLogPanelPanelBackgroudColor
  coBorderColor: SStyleSheet.coLogPanelBorderColor
  coTitleTextColor: SStyleSheet.coLogPanelTitleTextColor
  coComponentTextColor: SStyleSheet.coLogPanelComponentTextColor
  coHighlightedTextColor: SStyleSheet.coLogPanelHighlightedTextColor
  coHighlightedBackgroundColor: SStyleSheet.coLogPanelHighlightedBackgroundColor
  coHeaderColor: SStyleSheet.coHorizontalHeaderColor
  coHeaderTextColor: SStyleSheet.coHorizontalHeaderTextColor
  coHeaderBorderColor: SStyleSheet.coHorizontalHeaderBorderColor
  coCellColor: SStyleSheet.coCellColor
  coCellTextColor: SStyleSheet.coCellTextColor
  coCellBorderColor: SStyleSheet.coCellBorderColor
  reTitleHeight: SStyleSheet.reLogPanelTitleHeight
  reCellHeight: SStyleSheet.reCellHeight
  reCellMargin: SStyleSheet.reCellMargin
  reCellBorderWidth: SStyleSheet.reCellBorderWidth
  reHeaderHeight: SStyleSheet.reLogPanelHeaderHeight
  reHeaderMargin: SStyleSheet.reHorizontalHeaderMargin
  reHeaderBorderWidth: SStyleSheet.reHorizontalHeaderBorderWidth
  reKeyWidth: SStyleSheet.reTableKeyWidth
  reDateWidth: SStyleSheet.reTableDateWidth
  reTimeWidth: SStyleSheet.reTableTimeWidth
  reMessageWidth: SStyleSheet.reTableTextWidth
  srTextFontFamily: SStyleSheet.srLogPanelTextFontFamily
  srTitleTextFontBold: false
  srTitleTextFontItalic: true

  urKeyTypeIcon: "../Images/Table_IMKeyTypeIcon.png"
  urDateTypeIcon: "../Images/Table_IMDateTypeIcon.png"
  urTimeTypeIcon: "../Images/Table_IMTimeTypeIcon.png"
  urTextTypeIcon: "../Images/Table_IMTextTypeIcon.png"

  urSuccessMessageIcon: "../Images/Table_IMSuccessMessageIcon.png"
  urInfoMessageIcon: "../Images/Table_IMInfoMessageIcon.png"
  urErrorMessageIcon: "../Images/Table_IMErrorMessageIcon.png"
  urWarningMessageIcon: "../Images/Table_IMWarningMessageIcon.png"
  urBugMessageIcon: "../Images/Table_IMBugMessageIcon.png"
}

