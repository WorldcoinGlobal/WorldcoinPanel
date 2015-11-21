import QtQuick 2.4
import ACMeasures.Lib 1.0

Rectangle {
  id: rcRoot

  property alias coTitleBackgroudColor: rcTitle.color
  property alias coPanelBackgroudColor: rcSearchPanel.color
  property color coBorderColor
  property color coTitleTextColor
  property color coComponentTextColor
  property color coHighlightedTextColor
  property color coHighlightedBackgroundColor
  property real reBorderWidth
  property real reTitleHeight  
  property real reDefaultWidth
  property real reDefaultHeight
  property point poClickPos
  property string srTextFontFamily
  property bool srTitleTextFontBold
  property bool srTitleTextFontItalic

  color: "transparent"
  Rectangle {
    id: rcTitle
    clip: true
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: rcRightBorder.width
    anchors.left: parent.left
    height: ACMeasures.fuToDots(reTitleHeight) * mCXDefinitions.mZoomFactor
    AXText {
      anchors.fill: parent
      color: coTitleTextColor
      text: qsTr("Search Panel")
      font.family: srTextFontFamily
      font.bold: srTitleTextFontBold
      font.italic: srTitleTextFontItalic
      font.pixelSize: rcTitle.height * 0.75
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
  }
  Rectangle {
    id: rcSearchPanel
    anchors.top: rcTitle.bottom
    anchors.right: rcRightBorder.left
    anchors.left: parent.left
    anchors.bottom: parent.bottom
  /*  Component {
      id: coComponentBackground
      Rectangle {
        height: rcTitle.height * 0.55
        id: rcComponentBackground
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: {
          if(EComponentTypeRole == 1) return rcLeftBorder.width
          if(EComponentTypeRole == 2) return parent.width * 1/4
          return rcLeftBorder.width
        }
        anchors.rightMargin: {
          if(EComponentTypeRole == 1) return 0
          if(EComponentTypeRole == 2) return parent.width * 1/4
          return 0
        }

        color: {
          if(EComponentTypeRole == 1) { if(ListView.isCurrentItem) return  coHighlightedAreaBackgroundColor; else return coAreaBackgroudColor }
          if(EComponentTypeRole == 2) { if(ListView.isCurrentItem) return  coHighlightedModuleBackgroundColor; else return coModuleBackgroudColor }
          if(ListView.isCurrentItem) return  coHighlightedComponentBackgroundColor; else coComponentBackgroudColor
        }       
        radius: {
          if(EComponentTypeRole == 1) return ACMeasures.fuToDots(reAreaRadius) * mCXDefinitions.mZoomFactor
          if(EComponentTypeRole == 2) return ACMeasures.fuToDots(reModuleRadius) * mCXDefinitions.mZoomFactor
          return ACMeasures.fuToDots(reComponentRadius) * mCXDefinitions.mZoomFactor
        }
        Image {
          id: xiType
          fillMode: Image.Stretch
          anchors.top: parent.top
          anchors.topMargin: parent.height * 1/3
          anchors.left: parent.left
          anchors.bottom: parent.bottom
          anchors.bottomMargin: parent.height * 1/3
          anchors.leftMargin: {
            if(EComponentTypeRole == 1) return 0
            if(EComponentTypeRole == 2) return 0
            return ACMeasures.fuToDots(0.2)
          }
          width: height
          source: {
            if(EComponentTypeRole == 1) return urIconArea
            if(EComponentTypeRole == 2) return urIconModule
            if(EComponentTypeRole == 101) return urIconConfig
            if(EComponentTypeRole == 102) return urIconCustom
            if(EComponentTypeRole == 103) return urIconParameter
            if(EComponentTypeRole == 104) return urIconRegister
            if(EComponentTypeRole == 105) return urIconTransaction
            if(EComponentTypeRole == 107) return urIconProcess
            if(EComponentTypeRole == 108) return urIconReport
          }
        }

        Text {
          anchors.top: parent.top
          anchors.left: xiType.right
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          text: EDisplayRole
          color: {
            if(EComponentTypeRole == 1) { if(ListView.isCurrentItem) return coHightlightedAreaTextColor; else return coAreaTextColor; }
            if(EComponentTypeRole == 2) { if(ListView.isCurrentItem) return coHightlightedModuleTextColor; else return coModuleTextColor }
            if(ListView.isCurrentItem) return  coHighlightedComponentTextColor; else coComponentTextColor
          }

          anchors.leftMargin: {
            if(EComponentTypeRole == 1) return 0
            if(EComponentTypeRole == 2) return 0
            return ACMeasures.fuToDots(0.2)
          }
          font.pixelSize: {
            if(EComponentTypeRole == 1) return parent.height * 0.6
            if(EComponentTypeRole == 2) return parent.height * 0.55
            return parent.height * 0.55
          }
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: {
            if(EComponentTypeRole == 1) return Text.AlignHCenter
            if(EComponentTypeRole == 2) return Text.AlignHCenter
            return Text.LeftRight
          }
        }
        MouseArea {
          anchors.fill: parent
          onClicked: { lvModulePanel.currentIndex = index  }
        }
      }
    }*/
    ListView {
      id: lvModulePanel
      anchors.fill: parent
      highlightRangeMode: ListView.NoHighlightRange
   //   model: CXModulePanel { id: cmModulePanel }
  //    delegate: coComponentBackground
    //  Component.onCompleted: { cmModulePanel.tLoadData(); }
    }

  }
  Rectangle {
    id: rcRightBorder
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    color: coBorderColor
    width: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeHorCursor
      onPressed: { poClickPos = Qt.point(mouse.x,mouse.y) }
      onPositionChanged: {
         var newW = rcRoot.width + Qt.point(mouse.x - poClickPos.x, mouse.y - poClickPos.y).x
         if(newW <= 2 * rcRightBorder.width) {
           newW = 2 * rcRightBorder.width
         }
         rcRoot.width = newW
         reDefaultWidth = ACMeasures.fuToCentimeters(rcRoot.width)
      }
    }
  }
  Component.onCompleted: { fuScale() }
  function fuScale() {
    width = ACMeasures.fuToDots(reDefaultWidth) * mCXDefinitions.mZoomFactor;
    height = ACMeasures.fuToDots(reDefaultHeight) * mCXDefinitions.mZoomFactor;
  }
}

