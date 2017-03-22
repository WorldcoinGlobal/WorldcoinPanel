import QtQuick 2.7
import QtGraphicalEffects 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0
import QtQuick.Controls 2.0
import SStyleSheet.Lib 1.0

Rectangle {
  id: rcRoot
  property alias coBottomBorderColor: rcBottomBorder.color
  property color coTextColor
  property color coVersionTextColor
  property color coSeparatorColor
  property real reSeparatorWidth
  property real reSpacing
  property real reHeightCm
  property real reBorderWidth
  property real reDefaultHeight
  property url urIconDaemonOff_BTC
  property url urIconDaemonReady_BTC
  property url urIconDaemonProcessing_BTC
  property url urIconDaemonError_BTC
  property url urIconDaemonOff_LTC
  property url urIconDaemonReady_LTC
  property url urIconDaemonProcessing_LTC
  property url urIconDaemonError_LTC
  property url urIconDaemonOff_DOGE
  property url urIconDaemonReady_DOGE
  property url urIconDaemonProcessing_DOGE
  property url urIconDaemonError_DOGE
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
  readonly property alias srCurrentCoin: cbCoins.displayText

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
    color: coVersionTextColor
    font.bold: true
    font.italic: false
    font.family: srFontFamily
    font.pixelSize: parent.height * 0.3
  }
  AXToolButton {
    id: tbDOGEDaemon
    visible: false
    width: 0
    property var vaStatus
    property string vaName: "DOGE"
    anchors.right: tbLTCDaemon.left
  }
  AXToolButton {
    id: tbLTCDaemon
    visible: false
    width: 0
    property var vaStatus
    property string vaName: "LTC"
    anchors.right: tbBTCDaemon.left
  }
  AXToolButton {
    id: tbBTCDaemon
    visible: false
    width: 0
    property var vaStatus
    property string vaName: "BTC"
    anchors.right: tbDaemon.left
  }
  AXToolButton {
    id: tbDaemon
    visible: false
    width: 0
    property var vaStatus
    property string vaName: "WDC"
    anchors.right: cbCoins.left
  }
  ComboBox {
    id: cbCoins
    width: ACMeasures.fuToDots(5.5) * mCXDefinitions.mZoomFactor
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    model: [tbDaemon.vaName, tbBTCDaemon.vaName, tbLTCDaemon.vaName, tbDOGEDaemon.vaName]
    delegate:
      ItemDelegate {
        width: cbCoins.width
        text: modelData + " - " + mCXDefinitions.fStatusText(cbCoins.fuStatus(modelData))
        font.weight: cbCoins.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: cbCoins.highlightedIndex == index
      }
    background: Rectangle {
      radius: ACMeasures.fuToDots(SStyleSheet.reComboBoxRadius)
    }
    indicator: Canvas {
        x: cbCoins.width - width - cbCoins.rightPadding
        y: cbCoins.topPadding + (cbCoins.availableHeight - height) / 2
        width: height
        height: parent.height * 0.3
        contextType: "2d"
        Connections {
            target: cbCoins
            onPressedChanged: cbCoins.indicator.requestPaint()
        }
        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = cbCoins.pressed ? SStyleSheet.coComboBoxIndicatorActiveColor : SStyleSheet.coComboBoxIndicatorInactiveColor;
            context.fill();
        }
    }
    contentItem: Rectangle {
      id: rcEnabled
      radius: ACMeasures.fuToDots(SStyleSheet.reComboBoxRadius)
      anchors.topMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
      anchors.leftMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
      anchors.bottomMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: cbCoins.width - cbCoins.indicator.width - cbCoins.spacing - ACMeasures.fuToDots(reBorderWidth)
      CheckBox {
        id: cbEnabled
        property bool boChangingState: false
        enabled: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: height
        indicator: Rectangle {
            x: cbEnabled.leftPadding
            y: parent.height / 2 - height / 2
            color: SStyleSheet.coCheckBoxBackgroundColor
            implicitWidth: ACMeasures.fuToDots(SStyleSheet.reCheckBoxWidth)
            implicitHeight: ACMeasures.fuToDots(SStyleSheet.reCheckBoxHeight)
            radius: ACMeasures.fuToDots( SStyleSheet.reCheckBoxRadius)
            border.color: cbEnabled.activeFocus ? SStyleSheet.coCheckBoxActiveBorderFocus : SStyleSheet.coCheckBoxInactiveBorderFocus
            border.width: 1
            Rectangle {
              visible: cbEnabled.checked
              color: cbEnabled.enabled ? SStyleSheet.coCheckBoxActiveColor : SStyleSheet.coCheckBoxInactiveColor
              border.color: SStyleSheet.coCheckBoxActiveColor
              radius: SStyleSheet.reCheckBoxRadius
              anchors.margins: ACMeasures.fuToDots(SStyleSheet.reCheckBoxHeight) * 0.2
              anchors.fill: parent
            }
        }
        onCheckedChanged: {
          if(boChangingState) {
            boChangingState = false
            return
          }
          boChangingState = true
          var vaSuccess = true;
          if(cbEnabled.checked) {
            vaSuccess = mCXConnectorManager.fStartDaemon(cbCoins.displayText)
            if(!vaSuccess) cbEnabled.checked = false;
          }
          else {
            vaSuccess = mCXConnectorManager.fStopDaemon(cbCoins.displayText)
            if(!vaSuccess) cbEnabled.checked = true;
          }
          boChangingState = false
        }
        function fuChangeState(boState) {
          boChangingState = true
          cbEnabled.checked = boState
          boChangingState = false
        }
      }
      AXToolButton {
        id: tbCurrentDaemon
        property var vaStatus

        anchors.left: cbEnabled.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width:height
        function fuClicked() {
          siComponentActivation("ComponentDaemonSettings")
          siHighlightComponentObject("ComponentDaemonSettings", "DaemonSettingsInfo")
        }
      }
      AXText {
        anchors.left: tbCurrentDaemon.right
        anchors.leftMargin: 15 // * mCXDefinitions.mZoomFactor //ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: {/* console.log(cbCoins.displayText + " - " + mCXDefinitions.fStatusText(cbCoins.fuStatus(cbCoins.displayText)));*/ return (cbCoins.width - cbEnabled.width - tbCurrentDaemon.width - 10 )}
     //   leftPadding: 0
        text: cbCoins.displayText + " - " + mCXDefinitions.fStatusText(cbCoins.fuStatus(cbCoins.displayText))
        font: cbCoins.font
     //   font.pixelSize: parent.height * 0.6
        color: SStyleSheet.coComboBoxTextColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }
    }
    onActivated: {
      if(cbCoins.displayText === "WDC") {
        cbEnabled.enabled = false
        tbCurrentDaemon.urIcon = tbDaemon.urIcon
        tbCurrentDaemon.vaStatus = tbDaemon.vaStatus
        tbLock.urIcon = WAEncrypted.mValue === "1" ? urIconLockOn : urIconLockOff
      }
      else {
        if(mCXConnectorManager.fStatus(cbCoins.displayText) === CXDefinitions.EServiceProcessing) cbEnabled.enabled = false
        else cbEnabled.enabled = true
      }
      if(cbCoins.displayText === "BTC") {
        tbCurrentDaemon.urIcon = tbBTCDaemon.urIcon
        tbCurrentDaemon.vaStatus = tbBTCDaemon.vaStatus
        tbLock.urIcon = WAEncryptedBTC.mValue === "1" ? urIconLockOn : urIconLockOff
      }
      if(cbCoins.displayText === "LTC") {
        tbCurrentDaemon.urIcon = tbLTCDaemon.urIcon
        tbCurrentDaemon.vaStatus = tbLTCDaemon.vaStatus
        tbLock.urIcon = WAEncryptedLTC.mValue === "1" ? urIconLockOn : urIconLockOff
    /// console.log()
      }
      if(cbCoins.displayText === "DOGE") {
        tbCurrentDaemon.urIcon = tbDOGEDaemon.urIcon
        tbCurrentDaemon.vaStatus = tbDOGEDaemon.vaStatus
        tbLock.urIcon = WAEncryptedDOGE.mValue === "1" ? urIconLockOn : urIconLockOff
      }


      var vaStatus = mCXConnectorManager.fStatus(cbCoins.displayText)
      if((vaStatus === mCXDefinitions.EServiceError) || (vaStatus === CXDefinitions.EServiceStopped)) cbEnabled.fuChangeState(false);
      else cbEnabled.fuChangeState(true);
    }
    Component.onCompleted: { currentIndex = 0; onActivated(currentIndex) }
    function fuStatus(srCoin) {
      var vaStatus;
      if(srCoin === "WDC") vaStatus = tbDaemon.vaStatus
      if(srCoin === "BTC") vaStatus = tbBTCDaemon.vaStatus
      if(srCoin === "LTC") vaStatus = tbLTCDaemon.vaStatus
      if(srCoin === "DOGE") vaStatus = tbDOGEDaemon.vaStatus
      return vaStatus
    }
  }
  MouseArea {
    anchors.left: cbCoins.left
    anchors.top: cbCoins.top
    anchors.topMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    anchors.leftMargin: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor + tbCurrentDaemon.width
    width: tbCurrentDaemon.width
    height: tbCurrentDaemon.height
    onClicked: tbCurrentDaemon.fuClicked()
  }
  AXToolButton {
    id: tbSync
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.right: rcSeparator3.left
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
    anchors.right: rcSeparator2.left
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
    anchors.right: tbIcon.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: rcRoot.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
   // anchors.bottomMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    width: height
    AXToolButton {
      id: tbPopularity
      anchors.fill: parent
   //   anchors.bottomMargin: parent.height * 0.30
      urIcon: urIconPopularityOff
    }
    Text {
      //clip: true
      anchors.top: parent.top
//        anchors.topMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
      anchors.right: parent.right
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      color: coTextColor
      fontSizeMode: Text.Fit
      font.pixelSize: height * 0.5
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
      siOpenUrl(WNPopularity.mSource + "/table.php?cryptocoin=worldcoin")
    }
  }
  Rectangle {
    id: rcBottomBorder    
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    height: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
  }
  MouseArea {
    anchors.fill: rcBottomBorder
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
    anchors.right: tbConnections.left
    anchors.rightMargin: ACMeasures.fuToDots(reSpacing) * mCXDefinitions.mZoomFactor
    anchors.bottom: rcRoot.bottom
    width: ACMeasures.fuToDots(reSeparatorWidth) * mCXDefinitions.mZoomFactor
    color: coSeparatorColor
  }
  Rectangle {
    z: 2
    id: rcSeparator3
    visible: false
    anchors.top: parent.top
    anchors.right: tbDOGEDaemon.left
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
    target: mCXConnectorManager
    onSStatusChanged: { fuCheckStatus(lName) }
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
          if(mCXConnectorManager.fStatus(mCXDefinitions.fDefaultDaemon()) === CXDefinitions.EServiceReady) mCXConnectorManager.fSetStatus(mCXDefinitions.fDefaultDaemon(), CXDefinitions.EServiceClosing)
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
    onMValueChanged: {
      if(cbCoins.displayText != "WDC") return;
      tbLock.urIcon = WAEncrypted.mValue === "1" ? urIconLockOn : urIconLockOff
    }
  }
  Connections {
    target: WAEncryptedBTC
    onMValueChanged: {
      if(cbCoins.displayText != "BTC") return;
      tbLock.urIcon = WAEncryptedBTC.mValue === "1" ? urIconLockOn : urIconLockOff
    }
  }
  Connections {
    target: WAEncryptedLTC
    onMValueChanged: {
      if(cbCoins.displayText != "LTC") return;
      tbLock.urIcon = WAEncryptedLTC.mValue === "1" ? urIconLockOn : urIconLockOff
    }
  }
  Connections {
    target: WAEncryptedDOGE
    onMValueChanged: {
      if(cbCoins.displayText != "DOGE") return;
      tbLock.urIcon = WAEncryptedDOGE.mValue === "1" ? urIconLockOn : urIconLockOff
    }
  }

  Connections {
    target: WAConnectionCount
    onMValueChanged: {
      if(cbCoins.displayText != "WDC") return;
      if(Number(WAConnectionCount.mValue) <= 0)  tbConnections.urIcon = urIconConnectionsOff
      if((Number(WAConnectionCount.mValue) > 0) && (Number(WAConnectionCount.mValue) < 8))  tbConnections.urIcon = urIconConnectionsProcessing
      if(Number(WAConnectionCount.mValue) >= 8)  tbConnections.urIcon = urIconConnectionsMax
    }
  }
  Connections {
    target: WAConnectionCountBTC
    onMValueChanged: {
      if(cbCoins.displayText != "BTC") return;
      if(Number(WAConnectionCountBTC.mValue) <= 0)  tbConnections.urIcon = urIconConnectionsOff
      if((Number(WAConnectionCountBTC.mValue) > 0) && (Number(WAConnectionCountBTC.mValue) < 8))  tbConnections.urIcon = urIconConnectionsProcessing
      if(Number(WAConnectionCountBTC.mValue) >= 8)  tbConnections.urIcon = urIconConnectionsMax
    }
  }
  Connections {
    target: WAConnectionCountLTC
    onMValueChanged: {
      if(cbCoins.displayText != "LTC") return;
      if(Number(WAConnectionCountLTC.mValue) <= 0)  tbConnections.urIcon = urIconConnectionsOff
      if((Number(WAConnectionCountLTC.mValue) > 0) && (Number(WAConnectionCountLTC.mValue) < 8))  tbConnections.urIcon = urIconConnectionsProcessing
      if(Number(WAConnectionCountLTC.mValue) >= 8)  tbConnections.urIcon = urIconConnectionsMax
    }
  }
  Connections {
    target: WAConnectionCountDOGE
    onMValueChanged: {
      if(cbCoins.displayText != "DOGE") return;
      if(Number(WAConnectionCountDOGE.mValue) <= 0)  tbConnections.urIcon = urIconConnectionsOff
      if((Number(WAConnectionCountDOGE.mValue) > 0) && (Number(WAConnectionCountDOGE.mValue) < 8))  tbConnections.urIcon = urIconConnectionsProcessing
      if(Number(WAConnectionCountDOGE.mValue) >= 8)  tbConnections.urIcon = urIconConnectionsMax
    }
  }
  Connections {
    target: WABlockCount
    onMValueChanged: {
      if(cbCoins.displayText != "WDC") return;
      if(Number(WABlockCount.mDisplayValue) === 0) { tbSync.urIcon = urIconSyncOff; return }
      if(Number(WABlockCount.mDisplayValue) < Number(WNTotalBlockCount.mDisplayValue)) { tbSync.urIcon = urIconSyncOn; return }
      tbSync.urIcon = urIconSyncFinished; return
    }
  }
  Connections {
    target: WABlockCountBTC
    onMValueChanged: {
      if(cbCoins.displayText != "BTC") return;
      if(Number(WABlockCountBTC.mDisplayValue) === 0) { tbSync.urIcon = urIconSyncOff; return }
      if(Number(WABlockCountBTC.mDisplayValue) < Number(WNTotalBlockCountBTC.mDisplayValue)) { tbSync.urIcon = urIconSyncOn; return }
      tbSync.urIcon = urIconSyncFinished; return
    }
  }
  Connections {
    target: WABlockCountLTC
    onMValueChanged: {
      if(cbCoins.displayText != "LTC") return;
      if(Number(WABlockCountLTC.mDisplayValue) === 0) { tbSync.urIcon = urIconSyncOff; return }
      if(Number(WABlockCountLTC.mDisplayValue) < Number(WNTotalBlockCountLTC.mDisplayValue)) { tbSync.urIcon = urIconSyncOn; return }
      tbSync.urIcon = urIconSyncFinished; return
    }
  }
  Connections {
    target: WABlockCountDOGE
    onMValueChanged: {
      if(cbCoins.displayText != "DOGE") return;
      if(Number(WABlockCountDOGE.mDisplayValue) === 0) { tbSync.urIcon = urIconSyncOff; return }
      if(Number(WABlockCountDOGE.mDisplayValue) < Number(WNTotalBlockCountDOGE.mDisplayValue)) { tbSync.urIcon = urIconSyncOn; return }
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
    tbLock.urIcon = urIconLockOff
    tbSync.urIcon = urIconSyncOff
    boServiceClosing = false
 //   tbCurrentDaemon.urIcon = urIconDaemonOff_BTC
    tbCurrentDaemon.urIcon = urIconDaemonOff
    fuCheckStatus("WDC")
    fuCheckStatus("BTC")
    fuCheckStatus("LTC")
    fuCheckStatus("DOGE")
  }
  function fuCheckStatus(lName) {
    if(lName === "WDC") {
      if(mCXConnectorManager.fStatus("WDC") === CXDefinitions.EServiceStopped) {
        tbDaemon.urIcon = urIconDaemonOff
        tbDaemon.vaStatus = CXDefinitions.EServiceStopped
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("WDC") === CXDefinitions.EServiceReady) {
        tbDaemon.urIcon = urIconDaemonReady
        tbDaemon.vaStatus = CXDefinitions.EServiceReady
        if(boServiceClosing) mCXConnectorManager.fSetStatus(lName, CXDefinitions.EServiceClosing)
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("WDC") === CXDefinitions.EServiceProcessing) {
        tbDaemon.urIcon = urIconDaemonProcessing
        tbDaemon.vaStatus = CXDefinitions.EServiceProcessing
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("WDC") === CXDefinitions.EServiceError) {
        tbDaemon.urIcon = urIconDaemonError
        tbDaemon.vaStatus = CXDefinitions.EServiceError
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
    }
    if(lName === "BTC") {
      if(mCXConnectorManager.fStatus("BTC") === CXDefinitions.EServiceStopped) {
        tbBTCDaemon.urIcon = urIconDaemonOff_BTC
        tbBTCDaemon.vaStatus = CXDefinitions.EServiceStopped
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("BTC") === CXDefinitions.EServiceReady) {
        tbBTCDaemon.urIcon = urIconDaemonReady_BTC
        tbBTCDaemon.vaStatus = CXDefinitions.EServiceReady
        if(boServiceClosing) mCXConnectorManager.fSetStatus(lName, CXDefinitions.EServiceClosing)
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("BTC") === CXDefinitions.EServiceProcessing) {
        tbBTCDaemon.urIcon = urIconDaemonProcessing_BTC
        tbBTCDaemon.vaStatus = CXDefinitions.EServiceProcessing
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("BTC") === CXDefinitions.EServiceError) {
        tbBTCDaemon.urIcon = urIconDaemonError_BTC
        tbBTCDaemon.vaStatus = CXDefinitions.EServiceError
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
    }
    if(lName === "LTC") {
      if(mCXConnectorManager.fStatus("LTC") === CXDefinitions.EServiceStopped) {
        tbLTCDaemon.urIcon = urIconDaemonOff_LTC
        tbLTCDaemon.vaStatus = CXDefinitions.EServiceStopped
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("LTC") === CXDefinitions.EServiceReady) {
        tbLTCDaemon.urIcon = urIconDaemonReady_LTC
        tbLTCDaemon.vaStatus = CXDefinitions.EServiceReady
        if(boServiceClosing) mCXConnectorManager.fSetStatus(lName, CXDefinitions.EServiceClosing)
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("LTC") === CXDefinitions.EServiceProcessing) {
        tbLTCDaemon.urIcon = urIconDaemonProcessing_LTC
        tbLTCDaemon.vaStatus = CXDefinitions.EServiceProcessing
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("LTC") === CXDefinitions.EServiceError) {
        tbLTCDaemon.urIcon = urIconDaemonError_LTC
        tbLTCDaemon.vaStatus = CXDefinitions.EServiceError
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
    }
    if(lName === "DOGE") {
      if(mCXConnectorManager.fStatus("DOGE") === CXDefinitions.EServiceStopped) {
        tbDOGEDaemon.urIcon = urIconDaemonOff_DOGE
        tbDOGEDaemon.vaStatus = CXDefinitions.EServiceStopped
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("DOGE") === CXDefinitions.EServiceReady) {
        tbDOGEDaemon.urIcon = urIconDaemonReady_DOGE
        tbDOGEDaemon.vaStatus = CXDefinitions.EServiceReady
        if(boServiceClosing) mCXConnectorManager.fSetStatus(lName, CXDefinitions.EServiceClosing)
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("DOGE") === CXDefinitions.EServiceProcessing) {
        tbDOGEDaemon.urIcon = urIconDaemonProcessing_DOGE
        tbDOGEDaemon.vaStatus = CXDefinitions.EServiceProcessing
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
      if(mCXConnectorManager.fStatus("DOGE") === CXDefinitions.EServiceError) {
        tbDOGEDaemon.urIcon = urIconDaemonError_DOGE
        tbDOGEDaemon.vaStatus = CXDefinitions.EServiceError
        cbCoins.onActivated(cbCoins.currentIndex)
        return
      }
    }
    if(mCXConnectorManager.fStatus("WDC") === CXDefinitions.EServiceReady) cbCoins.enabled = true
    else cbCoins.enabled = false
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

