import QtQuick 2.4
import QtGraphicalEffects 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

Rectangle {
  id: rcRoot
  property alias coBottomBorderColor: rcBottomBorder.color
  property color coTextColor
  property real reSpacing
  property real reHeightCm
  property real reBorderWidth
  property real reDefaultHeight
  property url urIconDaemonOff
  property url urIconDaemonReady
  property url urIconDaemonProcessing
  property url urIconDaemonError
  property url urIconDefault
  property url urIconSyncOff
  property url urIconLockOff
  property url urIconLockOn
  property url urIconConnectionsOff
  property url urIconServicesOff
  property url urIconServicesReady
  property url urIconServicesProcessing
  property url urIconServicesError
  property url urIconUpdatesOff
  property url urIconUpdatesNoUpdates
  property url urIconUpdatesLowPriority
  property url urIconUpdatesMediumPriority
  property url urIconUpdatesHighPriority
  property url urIconUpdatesCriticalPriority
  property url urIconSyncOn
  property url urIconSyncFinished
  property point poClickPos
  property bool boTiltFlag
  property bool boServiceClosing
  property int vaUpdatePriority

  clip: true
  Timer {
    id: tmTiltTimer
    interval: 500;
    running: false;
    repeat: true
    onTriggered: { fuChangeUpdateIcon() }
  }
  Text {
    id: txVersion
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor

    horizontalAlignment: "AlignLeft"
    verticalAlignment: "AlignVCenter"
    text: qsTr("WorldcoinBC - " + mCXDefinitions.mCurrentVersion + "\n" + mCXDefinitions.mCurrentVersionName)
    color: coTextColor
    font.bold: true
    font.italic: false
    font.family: srFontFamily
    font.pixelSize: parent.height * 0.3
  }
  Image {
    id: imDaemon
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium
    /*HueSaturation {
      id: hsPressedEffect
      anchors.fill: parent
      source: imDaemon
      hue: 0
      saturation: 0
      lightness: 0
    }*/
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
  //    onEntered: { hsPressedEffect.lightness = hsPressedEffect.lightness + 0.15; }
  //    onExited: { hsPressedEffect.lightness = hsPressedEffect.lightness - 0.15; }
  //    onPressed: { hsPressedEffect.lightness = hsPressedEffect.lightness + 0.3; }
  //    onReleased: { hsPressedEffect.lightness = hsPressedEffect.lightness - 0.3; }
    }
  }
  Rectangle {
    id: rcSync
    clip: true
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: imDaemon.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    color: parent.color
    Rectangle {
      id: rcSyncFinished
      clip: true
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      width: {
        if(Number(WNTotalBlockCount.mDisplayValue) > 0) return  (rcSync.width * Number(WABlockCount.mDisplayValue) / Number(WNTotalBlockCount.mDisplayValue));
        else return 0;
      }
      color: "transparent"
      Image {
        id: imSynced
        fillMode: Image.Stretch
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: rcSync.width
        source: urIconSyncOn
        sourceSize.height: mCXDefinitions.ESizeMedium
        sourceSize.width: mCXDefinitions.ESizeMedium

      }
    }
    Rectangle {
      id: rcSyncInProgress
      clip: true
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      width: rcSync.width - rcSyncFinished.width
      color: "transparent"
      Image {
        id: imSyncInProgress
        fillMode: Image.Stretch
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: rcSync.width
        source: urIconSyncOff
        sourceSize.height: mCXDefinitions.ESizeMedium
        sourceSize.width: mCXDefinitions.ESizeMedium

      }
    }
    Image {
      id: imSyncFinished
      fillMode: Image.Stretch
      anchors.fill: parent
      source: urIconSyncFinished
      sourceSize.height: mCXDefinitions.ESizeMedium
      sourceSize.width: mCXDefinitions.ESizeMedium
      visible: (Number(WNTotalBlockCount.mDisplayValue) <= Number(WABlockCount.mDisplayValue)) && (Number(WNTotalBlockCount.mDisplayValue) > 0) ? true : false
    }
  }
  Image {
    id: imLock
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: rcSync.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium
    /*HueSaturation {
      id: hsLockPressesEffect
      anchors.fill: parent
      source: imLock
      hue: 0
      saturation: 0
      lightness: 0
    }*/
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
    //  onEntered: { hsLockPressesEffect.lightness = hsLockPressesEffect.lightness + 0.15; }
    //  onExited: { hsLockPressesEffect.lightness = hsLockPressesEffect.lightness - 0.15; }
    //  onPressed: { hsLockPressesEffect.lightness = hsLockPressesEffect.lightness + 0.3; }
    //  onReleased: { hsLockPressesEffect.lightness = hsLockPressesEffect.lightness - 0.3; }
    }
  }
  Image {
    id: imConnections
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: imLock.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    source: urIconConnectionsOff
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium

  }
  Image {
    id: imServices
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: imConnections.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    source: urIconServicesOff
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium
  }
  Image {
    id: imUpdates
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: imServices.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    source: urIconUpdatesOff
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium
    /*HueSaturation {
      id: hsUpdatesPressedEffect
      anchors.fill: parent
      source: imUpdates
      hue: 0
      saturation: 0
      lightness: 0
    }*/
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
     // onEntered: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness + 0.15; }
     // onExited: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness - 0.15; }
     // onPressed: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness + 0.3; }
     // onReleased: { hsUpdatesPressedEffect.lightness = hsUpdatesPressedEffect.lightness - 0.3; }
    }
  }
  Image {
    id: imIcon
    fillMode: Image.Stretch
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: imUpdates.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    source: urIconDefault
    sourceSize.height: mCXDefinitions.ESizeMedium
    sourceSize.width: mCXDefinitions.ESizeMedium
  }

  Rectangle {
    id: rcBottomBorder
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left

    height: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeVerCursor
      onPressed: { poClickPos = Qt.point(mouse.x,mouse.y) }
      onPositionChanged: {
        var newH = rcRoot.height + Qt.point(mouse.x - poClickPos.x, mouse.y - poClickPos.y).y
        if(newH <= 2 * rcBottomBorder.height) {
          newH = 2 * rcBottomBorder.height
        }
        rcRoot.height = newH
        reDefaultHeight = ACMeasures.fuToCentimeters(rcRoot.height)
      }
    }
  }
  Connections {
    target: mCXPulzarConnector
    onSConnectionStatusChanged: {
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceError) imServices.source = urIconServicesError
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceReady) imServices.source = urIconServicesReady
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceStopped) imServices.source = urIconServicesOff
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceProcessing) imServices.source = urIconServicesProcessing
    }
  }
  Connections {
    target: mCXStatus
    onSDaemonStatusChanged: {
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceStopped) {
        imDaemon.source = urIconDaemonOff
   //     btDaemon.tooltip = qsTr("Worldcoin daemon is stopped.")
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady) {
        imDaemon.source = urIconDaemonReady
        if(boServiceClosing) mCXStatus.mDaemonStatus = CXDefinitions.EServiceClosing
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceProcessing) {
        imDaemon.source = urIconDaemonProcessing
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceError) {
        imDaemon.source = urIconDaemonError
      }
    }
  }
  Connections {
    target: mCXPulzarConnector
    onSVersionLogChanged: {
      vaUpdatePriority = mCXPulzarConnector.fUpdatePriority()
      var vaCurrentVersion = /*"01.00.01" /*/ mCXDefinitions.fExtendVersion(mCXDefinitions.fCurrentVersion())
      var vaLastVersion = mCXPulzarConnector.fLastVersion()

      if(vaCurrentVersion < vaLastVersion) {
        tmTiltTimer.start()
        boTiltFlag = true
        if(vaUpdatePriority == CXDefinitions.EUpgradeCritical) {
          if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady) mCXStatus.mDaemonStatus = CXDefinitions.EServiceClosing
          else boServiceClosing = true
        }
      }
      else {
        tmTiltTimer.stop()
        imUpdates.source = urIconUpdatesNoUpdates
      }
    }
  }
  Connections {
    target: WAEncrypted
    onMValueChanged: { imLock.source = WAEncrypted.mValue === "1" ? urIconLockOn : urIconLockOff }
  }
  Component.onCompleted: {
    fuScale();
    imDaemon.source = urIconDaemonOff
    imLock.source = urIconLockOff
    boServiceClosing = false
  }

  function fuResizeView() {
    rcView.height = lvNewReleases.height + lvCurrentRelease.height + lvPreviousReleases.height
  }
  function fuChangeUpdateIcon() {
    if(vaUpdatePriority == CXDefinitions.EUpgradeLow && boTiltFlag) { boTiltFlag = !boTiltFlag; imUpdates.source = urIconUpdatesLowPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeMedium && boTiltFlag) { boTiltFlag = !boTiltFlag; imUpdates.source = urIconUpdatesMediumPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeHigh && boTiltFlag) { boTiltFlag = !boTiltFlag; imUpdates.source = urIconUpdatesHighPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeCritical && boTiltFlag) { boTiltFlag = !boTiltFlag; imUpdates.source = urIconUpdatesCriticalPriority; return }
    boTiltFlag = !boTiltFlag;
    imUpdates.source = urIconUpdatesOff;
  }
  function fuScale() { height = ACMeasures.fuToDots(reDefaultHeight) * mCXDefinitions.mZoomFactor; }
}

