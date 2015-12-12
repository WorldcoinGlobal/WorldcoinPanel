import QtQuick 2.4
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0
import WFObjects.Lib 1.0
import QtQuick.Controls 1.3

Rectangle {
  id: rcRoot

  property alias coTitleBackgroudColor: rcTitle.color
  property alias coPanelBackgroudColor: rcModulePanel.color
  property color coAreaBackgroudColor
  property color coModuleBackgroudColor
  property color coComponentBackgroudColor
  property color coBorderColor
  property color coTitleTextColor
  property color coAreaTextColor
  property color coModuleTextColor
  property color coComponentTextColor
  property color coHighlightedAreaTextColor
  property color coHighlightedModuleTextColor
  property color coHighlightedComponentTextColor
  property color coHighlightedAreaBackgroundColor
  property color coHighlightedModuleBackgroundColor
  property color coHighlightedComponentBackgroundColor

  property real reBorderWidth
  property real reTitleHeight
  property real reDefaultWidth
  property real reAreaRadius
  property real reModuleRadius
  property real reComponentRadius
  property point poClickPos
  property string srTextFontFamily
  property bool srTitleTextFontBold
  property bool srTitleTextFontItalic
  property url urIconArea
  property url urIconModule
  property url urIconConfig
  property url urIconCustom
  property url urIconParameter
  property url urIconRegister
  property url urIconTransaction
  property url urIconProcess
  property url urIconReport

  signal siComponentSelected(string srComponentName, string srComponentLabel, int inComponentCategory, int inComponentType, int boShow)

  enabled: mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady ? true : false
  color: "transparent"
  Rectangle {
    id: rcTitle
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: rcRightBorder.width
    anchors.left: parent.left
    height: ACMeasures.fuToDots(reTitleHeight) * mCXDefinitions.mZoomFactor
    Text {
      anchors.fill: parent
      color: coTitleTextColor
      text: qsTr("Module Panel")
      font.family: srTextFontFamily
      font.bold: srTitleTextFontBold
      font.italic: srTitleTextFontItalic
      font.pixelSize: rcTitle.height * 0.6
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
  }
  CXModulePanel {
    id: cmModulePanel
  }
  Rectangle {
    id: rcModulePanel
    anchors.top: rcTitle.bottom
    anchors.right: rcRightBorder.left
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    Component {
      id: coComponentBackground

      Rectangle {
        property bool boIsCurrentItem: ListView.isCurrentItem
        height: rcTitle.height * 0.7
        id: rcComponentBackground
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: {
          if(EComponentTypeRole === CXDefinitions.EArea) return rcLeftBorder.width
          if(EComponentTypeRole === CXDefinitions.EModule) return parent.width * 1/4
          return rcLeftBorder.width
        }
        anchors.rightMargin: {
          if(EComponentTypeRole === CXDefinitions.EArea) return 0
          if(EComponentTypeRole === CXDefinitions.EModule) return parent.width * 1/4
          return 0
        }

        color: {
          if(EComponentTypeRole === CXDefinitions.EArea) { if( boIsCurrentItem) return  coHighlightedAreaBackgroundColor; else return coAreaBackgroudColor }
          if(EComponentTypeRole === CXDefinitions.EModule) { if( boIsCurrentItem) return  coHighlightedModuleBackgroundColor; else return coModuleBackgroudColor }
          if(boIsCurrentItem) return  coHighlightedComponentBackgroundColor; else coComponentBackgroudColor
        }       
        radius: {
          if(EComponentTypeRole === CXDefinitions.EArea) return ACMeasures.fuToDots(reAreaRadius) * mCXDefinitions.mZoomFactor
          if(EComponentTypeRole === CXDefinitions.EModule) return ACMeasures.fuToDots(reModuleRadius) * mCXDefinitions.mZoomFactor
          return ACMeasures.fuToDots(reComponentRadius) * mCXDefinitions.mZoomFactor
        }
        Rectangle {
          z: rcComponentBackground.z - 1
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          color: {
            if(EComponentTypeRole === CXDefinitions.EArea) { if(boIsCurrentItem) return  coHighlightedAreaBackgroundColor; else return coAreaBackgroudColor }
            if(EComponentTypeRole === CXDefinitions.EModule) { if(boIsCurrentItem) return  coHighlightedModuleBackgroundColor; else return coModuleBackgroudColor }
            if(boIsCurrentItem) return  coHighlightedComponentBackgroundColor; else coComponentBackgroudColor
          }
          height: {
            if(EComponentTypeRole === CXDefinitions.EArea) return ACMeasures.fuToDots(reAreaRadius) * mCXDefinitions.mZoomFactor
            if(EComponentTypeRole === CXDefinitions.EModule) return (parent.height / 2) * mCXDefinitions.mZoomFactor
            return ACMeasures.fuToDots(reComponentRadius) * mCXDefinitions.mZoomFactor
          }
        }
        Image {
          id: xiType
          fillMode: Image.PreserveAspectFit
          smooth: true
          anchors.top: parent.top
          anchors.topMargin: parent.height * 1/3
          anchors.left: parent.left
          anchors.bottom: parent.bottom
          anchors.bottomMargin: parent.height * 1/3
          anchors.leftMargin: {
            if(EComponentTypeRole === CXDefinitions.EArea) return 0
            if(EComponentTypeRole === CXDefinitions.EModule) return 0
            return ACMeasures.fuToDots(0.2)
          }
          width: height
          Component.onCompleted: {
            if(EComponentTypeRole === CXDefinitions.EArea) xiType.source = urIconArea
            if(EComponentTypeRole === CXDefinitions.EModule) xiType.source = urIconModule
            if(EComponentTypeRole === CXDefinitions.EConfig) xiType.source = urIconConfig
            if(EComponentTypeRole === CXDefinitions.ECustom) xiType.source = urIconCustom
            if(EComponentTypeRole === CXDefinitions.EParameter) xiType.source = urIconParameter
            if(EComponentTypeRole === CXDefinitions.ERegister) xiType.source = urIconRegister
            if(EComponentTypeRole === CXDefinitions.ETransaction) xiType.source = urIconTransaction
            if(EComponentTypeRole === CXDefinitions.EProcess) xiType.source = urIconProcess
            if(EComponentTypeRole === CXDefinitions.EReport) xiType.source = urIconReport
          }
        }

        Text {
          anchors.top: parent.top
          anchors.left: xiType.right
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          text: EDisplayRole
          color: {
            if(EComponentTypeRole === CXDefinitions.EArea) { if(ListView.isCurrentItem) return coHightlightedAreaTextColor; else return coAreaTextColor; }
            if(EComponentTypeRole === CXDefinitions.EModule) { if(ListView.isCurrentItem) return coHightlightedModuleTextColor; else return coModuleTextColor }
            if(boIsCurrentItem) return  coHighlightedComponentTextColor; else coComponentTextColor
          }

          anchors.leftMargin: {
            if(EComponentTypeRole === CXDefinitions.EArea) return 0
            if(EComponentTypeRole === CXDefinitions.EModule) return 0
            return ACMeasures.fuToDots(0.2)
          }
          font.pixelSize: {
            if(EComponentTypeRole === CXDefinitions.EArea) return parent.height * 0.8
            if(EComponentTypeRole === CXDefinitions.EModule) return parent.height * 0.7
            return parent.height * 0.7
          }
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: {
            if(EComponentTypeRole === CXDefinitions.EArea) return Text.AlignHCenter
            if(EComponentTypeRole === CXDefinitions.EModule) return Text.AlignHCenter
            return Text.LeftRight
          }
        }
        MouseArea {
          anchors.fill: parent
          onClicked: {
            lvModulePanel.currentIndex = index
            if((EComponentTypeRole != CXDefinitions.EArea) && (EComponentTypeRole != CXDefinitions.EModule)) fuActivateComponent(EEditRole)
          }
        }
      }
    }
    ListView {
      id: lvModulePanel
      anchors.fill: parent
      highlightRangeMode: ListView.NoHighlightRange
      model: cmModulePanel
      delegate: coComponentBackground
      Component.onCompleted: { cmModulePanel.tLoadData(); }
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
  function fuScale() { width = ACMeasures.fuToDots(reDefaultWidth) * mCXDefinitions.mZoomFactor; }
  function fuActivateComponent(srComponentName) {
    var vaIndex = cmModulePanel.fComponentRow(srComponentName)
    if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady && (vaIndex >= 0)) {
      lvModulePanel.currentIndex = vaIndex
      var vaDependencies = cmModulePanel.fComponentDependencies(srComponentName)
      for (var i = 0; i < vaDependencies.length; i++) {
        var vaName = vaDependencies[i]
        var vaLabel = cmModulePanel.fComponentLabel(vaName)
        var vaCategory = cmModulePanel.fComponentCategory(vaName)
        var vaType = cmModulePanel.fComponentType(vaName)
        rcRoot.siComponentSelected(vaName, vaLabel, vaCategory, vaType, 0)
      }
      rcRoot.siComponentSelected(srComponentName, cmModulePanel.fComponentLabel(srComponentName), cmModulePanel.fComponentCategory(srComponentName), cmModulePanel.fComponentType(srComponentName), 1)
    }
  }
}

