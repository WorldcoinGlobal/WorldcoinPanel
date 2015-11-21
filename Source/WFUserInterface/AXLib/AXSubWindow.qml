import QtQuick 2.4
import QtGraphicalEffects 1.0
import ACMeasures.Lib 1.0
import WFCore.Lib 1.0

GXSubWindow {
  id: coRoot
  z: mActive ? 1 : 0
  clip: true
  property alias rcWorkspace : rcComponentWorkspace
  property alias rcCommandBarFrame : rcComponentCommandBarFrame
  property color coComponentTopBorderColor
  property color coComponentActiveTopBorderColor
  property color coComponentBottomBorderColor
  property color coComponentRightBorderColor
  property color coComponentLeftBorderColor
  property color coComponentWorkspaceColor  
  property real reComponentBorderWidth
  property real reComponentCornerRadiusCm
  property real reHeightCm
  property real reWidthCm
  property real reComponentTitleBarHeight
  property real reComponentStatusBarHeight
  property real reCommandBarHeight
  property real reCurrentZoomFactor    
  property string srComponentTitleText
  property url urComponentTitleBar
  property url urComponentStatusBar
  property url urComponentWorkspace
  signal siComponentCloseRequested

  Loader {
    id: loComponentTitleBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    source: urComponentTitleBar
    onLoaded: {
      rcTitleBarBackground.color = Qt.binding(function() { return item.color })
      height = ACMeasures.fuToDots(reComponentTitleBarHeight) * mCXDefinitions.mZoomFactor
      loComponentTitleBar.item.reBorderWidth = reComponentBorderWidth * mCXDefinitions.mZoomFactor
      loComponentTitleBar.item.radius = ACMeasures.fuToDots(reComponentCornerRadiusCm) * mCXDefinitions.mZoomFactor
    }
    Rectangle {
      id: rcTitleBarBackground
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: parent.height / 2
    }

  }
  Loader {
    id: loComponentStatusBar
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    source: urComponentStatusBar
    onLoaded: {
      rcStatusBarBackground.color = item.color
      height = ACMeasures.fuToDots(reComponentStatusBarHeight) * mCXDefinitions.mZoomFactor
      loComponentStatusBar.item.reBorderWidth = reComponentBorderWidth * mCXDefinitions.mZoomFactor
      loComponentStatusBar.item.radius = ACMeasures.fuToDots(reComponentCornerRadiusCm) * mCXDefinitions.mZoomFactor
    }
    Rectangle {
      id: rcStatusBarBackground
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: parent.height / 2
    }
  }

  Rectangle {
    id: rcComponentTopBorder
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reComponentCornerRadiusCm) * mCXDefinitions.mZoomFactor
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(reComponentCornerRadiusCm) * mCXDefinitions.mZoomFactor
    color: mActive ?  rcTitleBarBackground.color : coComponentTopBorderColor
    height: ACMeasures.fuToDots(reComponentBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeVerCursor
      preventStealing: true
      onPositionChanged: {
        var newY = mapToItem(coRoot.parent,  mouseX, mouseY).y
        fuMoveTopBorder(newY)
      }
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }
  }
  Rectangle {
    id: rcComponentBottomBorder
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reComponentCornerRadiusCm) * mCXDefinitions.mZoomFactor
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(reComponentCornerRadiusCm) * mCXDefinitions.mZoomFactor
    color: coComponentBottomBorderColor
    height: ACMeasures.fuToDots(reComponentBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeVerCursor
      preventStealing: true
      onPositionChanged: {
        var newY = mapToItem(coRoot.parent,  mouseX, mouseY).y
        fuMoveBottomBorder(newY)
      }
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }
  }
  Rectangle {
    id: rcComponentRightBorder
    anchors.top: loComponentTitleBar.bottom
    anchors.bottom: loComponentStatusBar.top
    anchors.right: parent.right
    color: coComponentRightBorderColor
    width: ACMeasures.fuToDots(reComponentBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeHorCursor
      preventStealing: true
      onPositionChanged: {
        var newX = mapToItem(coRoot.parent,  mouseX, mouseY).x
        fuMoveRightBorder(newX)
      }
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }
  }
  Rectangle {
    id: rcComponentLeftBorder
    anchors.top: loComponentTitleBar.bottom
    anchors.bottom: loComponentStatusBar.top
    anchors.left: parent.left
    color: coComponentLeftBorderColor
    width: ACMeasures.fuToDots(reComponentBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeHorCursor
      preventStealing: true
      onPositionChanged: {
        var newX = mapToItem(coRoot.parent,  mouseX, mouseY).x
        fuMoveLeftBorder(newX)
      }
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }
  }
  Rectangle {
    id: rcResizeLeft
    anchors.top: loComponentStatusBar.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    width: height
    color: "transparent" //coComponentLeftBorderColor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeBDiagCursor
      preventStealing: true
      onPositionChanged: {
        var curPoint = mapToItem(coRoot.parent,  mouseX, mouseY)
        var newX = curPoint.x
        var newY = curPoint.y
        fuMoveLeftBorder(newX)
        fuMoveBottomBorder(newY)
      }
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }
  }
  Rectangle {
    id: rcResizeRight
    anchors.top: loComponentStatusBar.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    width: height
    color: "transparent" //coComponentLeftBorderColor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeFDiagCursor
      preventStealing: true
      onPositionChanged: {
        var curPoint = mapToItem(coRoot.parent,  mouseX, mouseY)
        var newX = curPoint.x
        var newY = curPoint.y
        fuMoveRightBorder(newX)
        fuMoveBottomBorder(newY)
      }
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }
  }
  Rectangle {
    id: rcComponentWorkspace
    clip: true
    color: coComponentWorkspaceColor
    anchors.bottom: rcComponentCommandBarFrame.top
    anchors.left: rcComponentLeftBorder.right
    anchors.top: loComponentTitleBar.bottom
    anchors.right: rcComponentRightBorder.left    
 /*   MouseArea {
      z: 1
      propagateComposedEvents: true
      anchors.fill: parent
//      cursorShape: Qt.SizeHorCursor
      onPressed: {  mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    }*/

    function fuRawCallRequested(srConnector, srRequest, srComponentName)  { sRawCallRequested(srConnector, srRequest, srComponentName); }
  }
  Rectangle {
    id: rcComponentCommandBarFrame
    z: -1
    clip: true
    anchors.bottom: loComponentStatusBar.top
    anchors.left: rcComponentLeftBorder.right
    anchors.right: rcComponentRightBorder.left
    height: ACMeasures.fuToDots(reCommandBarHeight) * mCXDefinitions.mZoomFactor
  }

  Connections {
    target: coRoot
    onSScaleRequested: { fuScale() }
 //   onSMoveBottomBorder: { fuMoveBottomBorder(coRoot.y + coRoot.height) }
 //   onSMoveRightBorder: { fuMoveRightBorder(coRoot.x + coRoot.width) }
  }
  Connections {
    target: loComponentTitleBar.item
    onSiCloseButtonClicked: { fuCloseSubWindow() }
    onSiTitleBarPressed: { mCXComponentManager.fSetActiveComponent(coRoot.objectName)}
 /*   onSiMinimizeButtonClicked: { wiRoot.showMinimized() }
    onSiMaximizeButtonClicked: { fuShowMaximized() }*/
    onSiWindowMoved: {
      var newX = coRoot.x + poDelta.x
      if(newX < 0) newX = 0
      if(newX > coRoot.parent.width - coRoot.width) coRoot.parent.width = newX + coRoot.width
      var newY = coRoot.y + poDelta.y
      if(newY < 0) newY = 0
      if(newY > (coRoot.parent.height - coRoot.height)) coRoot.parent.height = newY  + coRoot.height
      coRoot.x = newX
      coRoot.y = newY
    }
  }
  Connections {
    target: loComponentStatusBar.item
    onSiStatusBarPressed: { mCXComponentManager.fSetActiveComponent(coRoot.objectName) }
    onSiWindowMoved: {
      var newX = coRoot.x + poDelta.x
      if(newX < 0) newX = 0
      if(newX > coRoot.parent.width - coRoot.width) coRoot.parent.width = newX + coRoot.width
      var newY = coRoot.y + poDelta.y
      if(newY < 0) newY = 0
      if(newY > (coRoot.parent.height - coRoot.height))  coRoot.parent.height = newY  + coRoot.height
      coRoot.x = newX
      coRoot.y = newY
    }
  }
  Component.onCompleted: {
    reCurrentZoomFactor = mCXDefinitions.mZoomFactor
    fuScale()
  }
  function fuScale() {
    coRoot.x = coRoot.x * ( mCXDefinitions.mZoomFactor / reCurrentZoomFactor)
    coRoot.y = coRoot.y * ( mCXDefinitions.mZoomFactor / reCurrentZoomFactor)
    coRoot.height =  ACMeasures.fuToDots(coRoot.reHeightCm) * (mCXDefinitions.mZoomFactor)
    coRoot.width =  ACMeasures.fuToDots(coRoot.reWidthCm) * (mCXDefinitions.mZoomFactor)
    loComponentTitleBar.height = ACMeasures.fuToDots(reComponentTitleBarHeight) * mCXDefinitions.mZoomFactor
    loComponentStatusBar.height = ACMeasures.fuToDots(reComponentStatusBarHeight) * mCXDefinitions.mZoomFactor
    fuResizeWorkspace()
    if((coRoot.x + coRoot.width) > coRoot.parent.width) coRoot.parent.width = coRoot.x + coRoot.width
    if((coRoot.y + coRoot.height) > coRoot.parent.height) coRoot.parent.height = coRoot.y + coRoot.height
    reCurrentZoomFactor = mCXDefinitions.mZoomFactor

  //  scale = mCXDefinitions.mZoomFactor
  }
  function fuResizeWorkspace() {
    for(var i = 0; i < rcWorkspace.children.length; ++i) {
      rcWorkspace.children[i].height = rcWorkspace.height /  mCXDefinitions.mZoomFactor
      rcWorkspace.children[i].width = rcWorkspace.width /  mCXDefinitions.mZoomFactor
      rcWorkspace.children[i].scale = mCXDefinitions.mZoomFactor
    }
    for(var j = 0; j < rcComponentCommandBarFrame.children.length; ++j) {
      rcComponentCommandBarFrame.children[j].fuScale()
    }

  }
  function fuSetTitleText(srTitle) {
    loComponentTitleBar.item.srTitleText = srTitle
  }
  function fuMoveTopBorder(newY) {
    if(newY <= 0) { newY = 0 }
    var newH = coRoot.y - newY  + coRoot.height
    if(newH < (loComponentTitleBar.height + loComponentStatusBar.height)) {
      newH = loComponentTitleBar.height + loComponentStatusBar.height
      newY = coRoot.y + coRoot.height - newH
    }
    coRoot.reHeightCm = ACMeasures.fuToCentimeters(newH)
    tSetGeometry(coRoot.x, newY, coRoot.width, newH)
    coRoot.y = newY
    fuResizeWorkspace()
  }
  function fuMoveBottomBorder(newY) {
    var newH = newY - coRoot.y
    if(newH < (loComponentTitleBar.height + loComponentStatusBar.height)) {
      newH = loComponentTitleBar.height + loComponentStatusBar.height // coRoot.height
      newY = coRoot.y
    }
    if(newY >= coRoot.parent.height) { /*newH = (coRoot.parent.height - coRoot.y )*/ coRoot.parent.height = newY}
    coRoot.reHeightCm = ACMeasures.fuToCentimeters(newH)
    tSetGeometry(coRoot.x, coRoot.y, coRoot.width, newH)
    fuResizeWorkspace()
  }
  function fuMoveLeftBorder(newX) {
    if(newX <= 0) newX = 0

    var newW = coRoot.x - newX  + coRoot.width
    var minimumWidth = loComponentTitleBar.item.reTitleWidth + rcComponentLeftBorder.width + rcComponentRightBorder.width
    if(newW < minimumWidth) {
      newW = coRoot.width
      newX = coRoot.x
    }
    tSetGeometry(newX, coRoot.y, newW, coRoot.height)
    coRoot.reWidthCm = ACMeasures.fuToCentimeters(newW)
    fuResizeWorkspace()
  }
  function fuMoveRightBorder(newX) {
    var newW = newX - coRoot.x
    var minimumWidth = loComponentTitleBar.item.reTitleWidth + rcComponentLeftBorder.width + rcComponentRightBorder.width
    if(newW < minimumWidth) {
      newW = minimumWidth
      newX = coRoot.x
    }
    if(newX >= coRoot.parent.width) { coRoot.parent.width = newX }
    coRoot.reWidthCm = ACMeasures.fuToCentimeters(newW)
    tSetGeometry(coRoot.x, coRoot.y, newW, coRoot.height)
    fuResizeWorkspace()
  }
  function fuCloseSubWindow() {
    coRoot.enabled = false
    coRoot.visible = false
    mActive = false
  }
}

