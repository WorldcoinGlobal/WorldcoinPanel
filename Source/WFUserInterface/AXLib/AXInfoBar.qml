import QtQuick 2.4
import QtGraphicalEffects 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

Rectangle {
  id: rcRoot
  property alias coBottomBorderColor: rcBottomBorder.color
  property color coTextColor
  property color coSeparatorColor
  property real reSeparatorWidth
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
  property url urIconConnectionsMax
  property url urIconConnectionsProcessing
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
  property url urIconPopularityOff
  property url urIconPopularityOn
  property point poClickPos
  property bool boTiltFlag
  property bool boServiceClosing
  property int vaUpdatePriority
  readonly property alias vaDaemonButton: tbDaemon
  readonly property alias vaIconButton: tbIcon
  readonly property alias vaUpdatesButton: tbUpdates
  readonly property alias vaServicesButton: tbServices
  readonly property alias vaConnectionsButton: tbConnections
  readonly property alias vaLockButton: tbLock
  readonly property alias vaSyncButton: tbSync
  readonly property alias vaPopularity: rcPopularity

  signal siOpenUrl(string srUrl)
  signal siComponentActivation(string srComponentName)
  signal siHighlightComponentObject(string srComponentName, string srObjectName)

  clip: true
  Timer {
    id: tmTiltTimer
    interval: 500;
    running: false;
    repeat: true
    onTriggered: { fuChangeUpdateStatus() }
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
    property var vaStatus
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    function fuClicked() {
      siComponentActivation("ComponentDaemonSettings")
      siHighlightComponentObject("ComponentDaemonSettings", "DaemonSettingsInfo")
    }
  }
  AXToolButton {
    id: tbSync
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbDaemon.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    function fuClicked() {
      siComponentActivation("ComponentWalletsSummary")
      siHighlightComponentObject("ComponentWalletsSummary", "Grid.Sync")
    }
  }
  AXToolButton {
    id: tbLock
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbSync.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    function fuClicked() {
      siComponentActivation("ComponentWalletsSummary")
      siHighlightComponentObject("ComponentWalletsSummary", "Grid.Encrypted")
    }
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
    function fuClicked() {
      siComponentActivation("ComponentWalletsSummary")
      siHighlightComponentObject("ComponentWalletsSummary", "Grid.Peers")
    }
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
    function fuClicked() {
      siComponentActivation("ComponentWalletsSummary")
      siHighlightComponentObject("ComponentWalletsSummary", "Grid.PulzarStatus")
    }
  }
  AXToolButton {
    id: tbUpdates
    property var vaStatus
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: tbServices.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    urIcon: urIconUpdatesOff
   // onSiClicked: { fuClicked() }
    function fuClicked() {
      siComponentActivation("ComponentUpdater")
      siHighlightComponentObject("ComponentUpdater", "UpgradeInfo")
    }
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
    function fuClicked() { }
  }
  Rectangle {
    id: rcPopularity
    z: 1
    color: "Transparent"
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: rcSeparator2.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: rcRoot.bottom
   // anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    AXToolButton {
      id: tbPopularity
      anchors.fill: parent
      anchors.bottomMargin: parent.height * 0.30
      urIcon: urIconPopularityOff
    }
    Text {
      //clip: true
      anchors.top: tbPopularity.bottom
//        anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
      anchors.right: parent.right
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignBottom
      color: coTextColor
      fontSizeMode: Text.Fit
      font.pixelSize: height * 1.2
      text: {
        if(Number(WNPopularity.mValue) == 0) return "--"
        return WNPopularity.mValue
      }
    }
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: { parent.fuClicked() }
    }
    function fuClicked() {
      siOpenUrl(WNPopularity.mSource)
    }
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
  Rectangle {
    z: 2
    id: rcSeparator1
    anchors.top: parent.top
    anchors.left: txVersion.right
    anchors.leftMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: rcRoot.bottom
    width: ACMeasures.fuToDots(reSeparatorWidth) * mCXDefinitions.mZoomFactor
    color: coSeparatorColor
  }
  Rectangle {
    z: 2
    id: rcSeparator2
    anchors.top: parent.top
    anchors.right: tbIcon.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: rcRoot.bottom
    width: ACMeasures.fuToDots(reSeparatorWidth) * mCXDefinitions.mZoomFactor
    color: coSeparatorColor
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
        tbDaemon.vaStatus = CXDefinitions.EServiceStopped
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady) {
        tbDaemon.urIcon = urIconDaemonReady
        tbDaemon.vaStatus = CXDefinitions.EServiceReady
        if(boServiceClosing) mCXStatus.mDaemonStatus = CXDefinitions.EServiceClosing
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceProcessing) {
        tbDaemon.urIcon = urIconDaemonProcessing
        tbDaemon.vaStatus = CXDefinitions.EServiceProcessing
      }
      if(mCXStatus.mDaemonStatus === CXDefinitions.EServiceError) {
        tbDaemon.urIcon = urIconDaemonError
        tbDaemon.vaStatus = CXDefinitions.EServiceError
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
  Connections {
    target: WAConnectionCount
    onMValueChanged: {
      if(Number(WAConnectionCount.mValue) <= 0)  tbConnections.urIcon = urIconConnectionsOff
      if((Number(WAConnectionCount.mValue) > 0) && (Number(WAConnectionCount.mValue) < 8))  tbConnections.urIcon = urIconConnectionsProcessing
      if(Number(WAConnectionCount.mValue) >= 8)  tbConnections.urIcon = urIconConnectionsMax
    }
  }
  Connections {
    target: WABlockCount
    onMValueChanged: {
      if(Number(WABlockCount.mDisplayValue) === 0) { tbSync.urIcon = urIconSyncOff; return }
      if(Number(WABlockCount.mDisplayValue) < Number(WNTotalBlockCount.mDisplayValue)) { tbSync.urIcon = urIconSyncOn; return }
      tbSync.urIcon = urIconSyncFinished; return
    }
  }
  Connections {
    target: WNPopularity
    onMValueChanged: {
      if(Number(WNPopularity.mValue) == 0)  tbPopularity.urIcon = urIconPopularityOff
      else tbPopularity.urIcon = urIconPopularityOn
    }
  }
  Component.onCompleted: {
    fuScale();
    tbDaemon.urIcon = urIconDaemonOff
    tbDaemon.vaStatus = CXDefinitions.EServiceStopped
    tbLock.urIcon = urIconLockOff
    tbSync.urIcon = urIconSyncOff
    boServiceClosing = false
  }

  function fuResizeView() {
    rcView.height = lvNewReleases.height + lvCurrentRelease.height + lvPreviousReleases.height
  }
  function fuChangeUpdateStatus() {
    if(vaUpdatePriority == CXDefinitions.EUpgradeLow && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesLowPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeMedium && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesMediumPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeHigh && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesHighPriority; return }
    if(vaUpdatePriority == CXDefinitions.EUpgradeCritical && boTiltFlag) { boTiltFlag = !boTiltFlag; tbUpdates.urIcon = urIconUpdatesCriticalPriority; return }
    boTiltFlag = !boTiltFlag;
    tbUpdates.urIcon = urIconUpdatesOff;
  }
  function fuScale() { height = ACMeasures.fuToDots(reDefaultHeight) * mCXDefinitions.mZoomFactor; }
}

