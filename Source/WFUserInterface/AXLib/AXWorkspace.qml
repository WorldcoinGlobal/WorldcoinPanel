import QtQuick 2.4
import QtQuick.Controls 1.3
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

Rectangle {
  id: rcRoot
  color: coPanelBackgroudColor
  property color coTabBackgroudColor
  property color coPanelBackgroudColor
  property color coTabTextColor
  property color coBorderColor
  property color coHighlightingColor
  property real reTabHeight
  property real reTabRadius
  property real reTabWidth
  property string srTextFontFamily
  property bool srTextFontBold
  property bool srTextFontItalic

  Rectangle {
    id: rcTab
    color: coTabBackgroudColor
    radius: ACMeasures.fuToDots(reTabRadius) * mCXDefinitions.mZoomFactor
    width: ACMeasures.fuToDots(reTabWidth) * mCXDefinitions.mZoomFactor
    height: ACMeasures.fuToDots(2 * reTabHeight) * mCXDefinitions.mZoomFactor
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    AXText {
      anchors.top: parent.top
      anchors.topMargin: ACMeasures.fuToDots(reTabHeight) * mCXDefinitions.mZoomFactor + 2
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      horizontalAlignment: Text.AlignHCenter
      font.family: srTextFontFamily
      font.bold: srTextFontBold
      font.italic: srTextFontItalic
      text: qsTr("Workspace: ") + "01"
      color: coTabTextColor
    }
  }
  ScrollView {
    id: svScrollView
    anchors.bottomMargin: ACMeasures.fuToDots(reTabHeight) * mCXDefinitions.mZoomFactor
    anchors.fill: parent
    Rectangle {
      id: rcWorkspace
      height: (rcRoot.height - rcTab.height / 2)
      width: rcRoot.width
      clip: true
      color: coPanelBackgroudColor
      border.color: coBorderColor
      border.width: 1
    }
  }
  function fuActivateComponent(srComponentName, srComponentLabel, inComponentCategory, inComponentType, boShow) {
    if(mCXComponentManager.fIsComponentLoaded(srComponentName)) {
      var coStoredComponent = mCXComponentManager.fComponent(srComponentName)
      if(coStoredComponent.mActive == false && boShow) {
        coStoredComponent.enabled = true
        coStoredComponent.visible = true
        if(boShow) mCXComponentManager.fSetActiveComponent(srComponentName)
        var coStoredComponentContent = mCXComponentManager.fComponentContent(srComponentName)
        coStoredComponentContent.fuActivate()
        mCXComponentManager.fComponentContent(srComponentName).sComponentActivated();
      }
    }
    else {
      var coWindow = Qt.createComponent("../../WFUserInterface/" + mCXDefinitions.mTheme + "/Layout/Panel_UIComponent.qml")
      var coCommandBar = Qt.createComponent("../../WFUserInterface/" + mCXDefinitions.mTheme + "/Layout/Component_UICommandBar.qml")
      if(coCommandBar.status !== Component.Ready) {
        wiRoot.siLogMessageRequest(5200005, "Component_UICommandBar.qml", null);
        return;
      }
      if(coWindow.status !== Component.Ready) wiRoot.siLogMessageRequest(5200005, "Panel_UIComponent.qml", null)
      else {
        var coLoadedWindow = coWindow.createObject(rcWorkspace, { "x": 100, "y": 100 })        
        coLoadedWindow.objectName = srComponentName
  // print(mCXComponentManager.fComponentDirectory(inComponentCategory) + srComponentName + "/" + srComponentName + mCXComponentManager.fComponentExtension())
        var coComponent = Qt.createComponent(mCXComponentManager.fComponentDirectory(inComponentCategory) + srComponentName + "/" + srComponentName + mCXComponentManager.fComponentExtension())
        if(coComponent.status !== Component.Ready){ wiRoot.siLogMessageRequest(3200016,srComponentName , qsTr("Error Message: '" + coComponent.errorString + "'")) }
        else {
          var coLoadedComponent = coComponent.createObject(coLoadedWindow.rcWorkspace, {'x': 0, 'y': 0, 'mName': srComponentName})
          coLoadedComponent.fuSetup()
          if((inComponentType != CXDefinitions.ECustom) && (inComponentType != CXDefinitions.EDetail) && (inComponentType != CXDefinitions.EReport) && (inComponentType != CXDefinitions.ESystemParameter)) {
            var coLoadedCommandBar = coCommandBar.createObject(coLoadedWindow.rcCommandBarFrame, { })
            coLoadedCommandBar.siCancelButtonClicked.connect(coLoadedWindow.fuCloseSubWindow)
            coLoadedCommandBar.siOkButtonClicked.connect(coLoadedComponent.fuAccept)
            coLoadedComponent.sComponentProcessing.connect(coLoadedCommandBar.fuDisable)
            coLoadedCommandBar.boStatus = Qt.binding(function() { return coLoadedComponent.mStatus })
          }
          else
            coLoadedWindow.reCommandBarHeight = 0
          coLoadedComponent.tSetType(inComponentType)
      //    coLoadedComponent.objectName = srComponentName
          mCXComponentManager.fRegisterComponent(srComponentName, coLoadedWindow, coLoadedComponent)
          wiRoot.siLogMessageRequest(1200002, srComponentName, null)

          if(boShow) mCXComponentManager.fSetActiveComponent(srComponentName)
          coLoadedWindow.visible = boShow
          coLoadedWindow.enabled = boShow
          coLoadedWindow.fuSetTitleText(srComponentLabel)
          coLoadedWindow.reHeightCm = coLoadedComponent.reHeightCm
          coLoadedWindow.reWidthCm = coLoadedComponent.reWidthCm
          coLoadedWindow.tScale()
          coLoadedComponent.sComponentActivated();
          coLoadedComponent.fuActivate()
        }
      }
    }
  }
  function fuHighlightObject(srComponentName, srObjectName) {
    if(mCXComponentManager.fIsComponentLoaded(srComponentName)) {
      var vaComps = srObjectName.split(".")
      var childList = mCXComponentManager.fComponentContent(srComponentName).children
      for(var i = 0; i < childList.length; i++) {
        if(vaComps[0] === childList[i].objectName) {
          var vaParent = childList[i]
          if(vaComps.length === 2) {
            var vaGrandChildList = vaParent.children
            for(var j = 0; j < vaGrandChildList.length; j++) {
              if(vaComps[1] === vaGrandChildList[j].objectName) {
                vaParent = vaGrandChildList[j]
                break;
              }
            }
          }
          var vaNewObject = Qt.createQmlObject('import QtQuick 2.5;
              Rectangle {
                property real reShowingDelay: 500
                property real reHidingDelay: 1000
                id: rcHighlight
                color: coHighlightingColor
                opacity: 0
                anchors.fill: rcHighlight.parent
                states: [
                  State { // when: rcHighlight.visible
                    name: "stShowing"
                    PropertyChanges { target: rcHighlight; opacity: 0.8 }
                    onCompleted: { /*tmHideTimer.start()*/ state = "stHiding" }
                  },
                  State { //when: !rcHighlight.visible
                    name: "stHiding"
                    PropertyChanges { target: rcHighlight; opacity: 0.0 }
                    onCompleted: { rcHighlight.destroy() }
                  }
                ]
                transitions: [ Transition {
                  to: "stShowing"
                  NumberAnimation { target: rcHighlight; property: "opacity"; duration: reShowingDelay }
                }, Transition {
                  to: "stHiding"
                  NumberAnimation { target: rcHighlight; property: "opacity"; duration: reHidingDelay }
                } ]
                Component.onCompleted: { state = "stShowing" }
              }',
              vaParent, "");
          break;
        }
      }
    }
  }
  function fuScaleComponents() { mCXComponentManager.fScaleComponents() }
  function fuAdjustWorkspaceSize() {
    //console.log(svScrollView.width,rcWorkspace.width,svScrollView.height,svScrollView.height)
    if(svScrollView.width > rcWorkspace.width)  rcWorkspace.width = svScrollView.width
    if(svScrollView.height > rcWorkspace.height)  rcWorkspace.height = svScrollView.height
  //  console.log(svScrollView.width,rcWorkspace.width,svScrollView.height,svScrollView.height)
  }
  Connections {
    target: svScrollView
    onWidthChanged: { if(svScrollView.width > rcWorkspace.width)  rcWorkspace.width = svScrollView.width }
    onHeightChanged: { if(svScrollView.height > rcWorkspace.height)  rcWorkspace.height = svScrollView.height }
  }
 // function fuMoveBottomBorder() { mCXComponentManager.fMoveBottomBorder() }
 // function fuMoveRightBorder() { mCXComponentManager.fMoveRightBorder() }
}

