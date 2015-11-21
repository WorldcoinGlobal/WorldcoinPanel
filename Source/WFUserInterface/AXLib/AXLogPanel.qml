import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0
Rectangle {
  id: rcRoot

  property alias coTitleBackgroudColor: rcTitle.color
  property alias coPanelBackgroudColor: rcLogPanel.color
  property color coBorderColor
  property color coTitleTextColor
  property color coComponentTextColor
  property color coHighlightedTextColor
  property color coHighlightedBackgroundColor
  property color coHeaderColor
  property color coHeaderTextColor
  property color coHeaderBorderColor
  property color coCellColor
  property color coCellTextColor
  property color coCellBorderColor
  property real reTitleHeight
  property real reCellMargin
  property real reCellHeight
  property real reHeaderHeight
  property real reHeaderMargin
  property real reHeaderBorderWidth
  property real reCellBorderWidth
  property real reKeyWidth
  property real reDateWidth
  property real reTimeWidth
  property real reMessageWidth
  property real reLastColumnPosition
  property string srTextFontFamily
  property bool srTitleTextFontBold
  property bool srTitleTextFontItalic
  property url urKeyTypeIcon
  property url urDateTypeIcon
  property url urTimeTypeIcon
  property url urTextTypeIcon
  property url urSuccessMessageIcon
  property url urInfoMessageIcon
  property url urErrorMessageIcon
  property url urWarningMessageIcon
  property url urBugMessageIcon

  color: "transparent"
  Rectangle {
    id: rcTitle
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: rcRightBorder.width
    anchors.left: parent.left
    height: ACMeasures.fuToDots(reTitleHeight) * mCXDefinitions.mZoomFactor
    AXText {
      anchors.fill: parent
      color: coTitleTextColor
      text: qsTr("Log Panel")
      font.family: srTextFontFamily
      font.bold: srTitleTextFontBold
      font.italic: srTitleTextFontItalic
      font.pixelSize: rcTitle.height * 0.75
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
  }
  Rectangle {
    id: rcLogPanel
    anchors.top: rcTitle.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    Component {
      id: coHeaderDelegate
      AXCell {
        id: xhLogDelegate
        reLeftMargin: reHeaderMargin
        reHeightCm: reHeaderHeight
        anchors.left: parent.left
        anchors.right: parent.right
        color: coHeaderColor
        coTextColor: coHeaderTextColor
        reBorderWidth: reHeaderBorderWidth
        reBottomBorderWidth: reHeaderBorderWidth
        coBorderColor: coHeaderBorderColor
        srText: styleData.value
        reTextRelativeSize: 0.7
        inHAlignment: Text.AlignLeft
        imIcon: {
          if(mLogModel.fHorizontalHeaderDataType(styleData.column) === CXDefinitions.EKeyType) return urKeyTypeIcon
          if(mLogModel.fHorizontalHeaderDataType(styleData.column) === CXDefinitions.EDateType) return urDateTypeIcon
          if(mLogModel.fHorizontalHeaderDataType(styleData.column) === CXDefinitions.ETimeType) return urTimeTypeIcon
          if(mLogModel.fHorizontalHeaderDataType(styleData.column) === CXDefinitions.ETextType) return urTextTypeIcon
          return ""         
        }
      }
    }
    Component {
      id: coCellDelegate
      AXCell {          
        id: xhLogDelegate

        //  height: ACMeasures.fuToDots(reCellHeight) * mCXDefinitions.mZoomFactor
        clip: true
        reLeftMargin: reCellMargin
        anchors.fill: parent
        color: "transparent"
        coTextColor: coCellTextColor
        reBorderWidth: reCellBorderWidth
        reBottomBorderWidth: reCellBorderWidth
        coBorderColor: coCellBorderColor
        srText: styleData.value
        reTextRelativeSize: .65
        inHAlignment: {
          if(mLogModel.fHorizontalHeaderDataType(styleData.column) === CXDefinitions.EKeyType) return Text.AlignHCenter
          return Text.AlignLeft
        }
        imIcon: {
          if(!model) return ""
          if((model.EMessageTypeRole === CXDefinitions.ESuccessMessage) && (styleData.column === 0)) return urSuccessMessageIcon
          if((model.EMessageTypeRole === CXDefinitions.EInfoMessage) && (styleData.column === 0)) return urInfoMessageIcon
          if((model.EMessageTypeRole === CXDefinitions.EErrorMessage) && (styleData.column === 0)) return urErrorMessageIcon
          if((model.EMessageTypeRole === CXDefinitions.EWarningMessage) && (styleData.column === 0)) return urWarningMessageIcon
          if((model.EMessageTypeRole === CXDefinitions.EBugMessage) && (styleData.column === 0)) return urBugMessageIcon
          return ""
        }        
      }
    }
    Component {
      id: coRowDelegate
      Rectangle {
        color: coCellColor
        height: ACMeasures.fuToDots(reCellHeight) * mCXDefinitions.mZoomFactor
        //Component.onCompleted: { if(lvLogPanel && lvLogPanel.rowCount > 0) { lvLogPanel.positionViewAtRow(lvLogPanel.rowCount - 1, ListView.Visible); console.log("aedede: " + lvLogPanel.rowCount - 1); } }
      }
    }
    Component {
      id: coViewColumn
      TableViewColumn { }
    }
    TableView {
      id: lvLogPanel
      alternatingRowColors: false
      anchors.fill: parent      
      model: mLogModel
      headerDelegate: coHeaderDelegate
      headerVisible: true
      itemDelegate: coCellDelegate
      rowDelegate: coRowDelegate

      resources: {
        var vaHorizontalHeaders = mLogModel.fHorizontalHeaderTitles()
        var vaHorizontalHeaderDataTypes = mLogModel.fHorizontalHeaderDataTypes()
        var vaTemp = []
        for(var i = 0; i < vaHorizontalHeaders.length; i++) {
           var vaRole = "E" + (10001 + i)
           var vaWidth = 0
           if(vaHorizontalHeaderDataTypes[i] === CXDefinitions.EKeyType) vaWidth = ACMeasures.fuToDots(reKeyWidth)
           if(vaHorizontalHeaderDataTypes[i] === CXDefinitions.EDateType) vaWidth = ACMeasures.fuToDots(reDateWidth)
           if(vaHorizontalHeaderDataTypes[i] === CXDefinitions.ETimeType) vaWidth = ACMeasures.fuToDots(reTimeWidth)
           if(vaHorizontalHeaderDataTypes[i] === CXDefinitions.ETextType) vaWidth = ACMeasures.fuToDots(reMessageWidth)
           vaTemp.push(coViewColumn.createObject(lvLogPanel, { "role": vaRole , "title": vaHorizontalHeaders[i], "width": vaWidth }))
        }
        return vaTemp        
      }
      Timer {
        id: tmRefreshTimer
        interval: 500;
        running: false;
        repeat: false
        onTriggered: { lvLogPanel.positionViewAtRow(lvLogPanel.rowCount - 1, ListView.End) }
      }
      onRowCountChanged: { tmRefreshTimer.running = true }
      style: TableViewStyle { backgroundColor: coCellColor }
    }
  }
}

