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
  signal siComponentActivation(string srComponentName)

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
  AXToolButton {
    id: tbDaemon
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
  }
  Rectangle {
    id: rcSync
    clip: true
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbDaemon.left
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
      AXToolButton {
        id: tbSynced
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: rcSync.width
        urIcon: urIconSyncOn
      }
   /*   Image {
        id: imSynced
        fillMode: Image.Stretch
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: rcSync.width
        source: urIconSyncOn
        sourceSize.height: mCXDefinitions.ESizeMedium
        sourceSize.width: mCXDefinitions.ESizeMedium

      }*/
    }
    Rectangle {
      id: rcSyncInProgress
      clip: true
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      width: rcSync.width - rcSyncFinished.width
      color: "transparent"
      AXToolButton {
        id: tbSyncInProgress
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: rcSync.width
        urIcon: urIconSyncOff
      }
    }
    AXToolButton {
      id: tbSyncFinished
      anchors.fill: parent
      urIcon: urIconSyncFinished
      visible: (Number(WNTotalBlockCount.mDisplayValue) <= Number(WABlockCount.mDisplayValue)) && (Number(WNTotalBlockCount.mDisplayValue) > 0) ? true : false
    }
  }
  AXToolButton {
    id: tbLock
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: rcSync.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
  }
  AXToolButton {
    id: tbConnections
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbLock.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    urIcon: urIconConnectionsOff
  }
  AXToolButton {
    id: tbServices
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbConnections.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    urIcon: urIconServicesOff
  }
  AXToolButton {
    id: tbUpdates
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbServices.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    urIcon: urIconUpdatesOff
    onSiClicked: { siComponentActivation("ComponentUpdater"); }
  }
  AXToolButton {
    id: tbIcon
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbUpdates.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    urIcon: urIconDefault
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
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceError) tbServices.urIcon = urIconServicesError
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceReady) tbServices.urIcon = urIconServicesReady
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceStopped) tbServices.urIcon = urIconServicesOff
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceProcessing) tbServices.urIcon = urIconServicesProcessing
    }
  }
  Connections {
    target: mCXStatus
    onSDaemonStatusChanged: {
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceStopped) {
        tbDaemon.urIcon = urIconDaemonOff
   //     btDaemon.tooltip = qsTr("Worldcoin daemon is stopped.")
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady) {
        tbDaemon.urIcon = urIconDaemonReady
        if(boServiceClosing) mCXStatus.mDaemonStatus = CXDefinitions.EServiceClosing
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceProcessing) {
        tbDaemon.urIcon = urIconDaemonProcessing
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceError) {
        tbDaemon.urIcon = urIconDaemonError
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
    //    imUpdates.source = urIconUpdatesNoUpdates
          tbUpdates.urIcon = urIconUpdatesNoUpdates
      }
    }
  }
  Connections {
    target: WAEncrypted
    onMValueChanged: { tbLock.urIcon = WAEncrypted.mValue === "1" ? urIconLockOn : urIconLockOff }
  }
  Component.onCompleted: {
    fuScale();
    tbDaemon.urIcon = urIconDaemonOff
    tbLock.urIcon = urIconLockOff
    boServiceClosing = false
  }

  function fuResizeView() {
    rcView.height = lvNewReleases.height + lvCurrentRelease.height + lvPreviousReleases.height
  }
  function fuChangeUpdateIcon() {
    if(vaUpdatePriority == CXDefinitions.EUpgradeLow && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesLowPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeMedium && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesMediumPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeHigh && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesHighPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeCritical && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesCriticalPriority; return }
    boTiltFlag = !boTiltFlag;
    tbUpdates.urIcon = urIconUpdatesOff;
  }
  function fuScale() { height = ACMeasures.fuToDots(reDefaultHeight) * mCXDefinitions.mZoomFactor; }
}

