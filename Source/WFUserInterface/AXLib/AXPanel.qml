import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import ACMeasures.Lib 1.0
import WFCore.Lib 1.0
import WFDefinitions.Lib 1.0

GXWindow {
  id: wiRoot
  color: "gray"

  property string srFontFamily
  property string srCurrentCoin
  property color coTextColor
  property bool boWDCFirstTime: true
  property bool boBTCFirstTime: true
  property bool boLTCFirstTime: true
  property bool boDOGEFirstTime: true
  property bool boIsMaximized: false
  property bool boReady
  property bool boClosing
  property color coTopBorderColor
  property color coBottomBorderColor
  property color coRightBorderColor
  property color coLeftBorderColor
  property color coInfoBackgroundColor
  property color coInfoTextColor
  property color coCriticalBackgroundColor
  property color coCriticalTextColor
  property color coToolTipBackgroundColor
  property color coToolTipTextColor
  property int inAnimationDuration: mCXDefinitions.mAnimationDuration
  property int inWapptomPollingTime: 2000
  property real reBorderWidth
  property real reCornerRadiusCm
  property real reHeightCm
  property real reModulePanelDefaultWidth
  property real reWidthCm
  property real reMinimumWidthCm
  property real reMinimumHeightCm
  property real reTitleBarHeight
  property real reStatusBarHeight
  property real reZoomDelta
  property real reOriginalZoom
  property url urBackgroundImage
  property url urTitleBar
  property url urStatusBar
  property url urModulePanel
  property url urSearchPanel
  property url urLogPanel
  property url urInfoBar
  property url urWorkspace
  property url urResizeHandlerImage
  property point poResizeClickPos
  property real rePreviousX
  property real rePreviousY
  property real rePreviousHeight
  property real rePreviousWidth
  property real reMinimumZoom
  property real reMaximumZoom
  property real reToolTipRadius

  signal siCloseRequested
  signal siLogMessageRequest(int inCode, string srParam, string srCustomText)

  Connections {
    target: mCXConnectorManager
    onSStatusChanged: {
      boReady = mCXConnectorManager.fStatus(mCXDefinitions.fDefaultDaemon()) === CXDefinitions.EServiceReady ? true : false
      boClosing = mCXConnectorManager.fStatus(mCXDefinitions.fDefaultDaemon()) === CXDefinitions.EServiceClosing ? true : false
    }
  }
  MouseArea {
    id: maRoot
    anchors.fill: parent
    propagateComposedEvents: true
    onWheel: {
      if(wheel.modifiers & Qt.ControlModifier) {
        if((mCXDefinitions.mZoomFactor <= reMaximumZoom) && wheel.angleDelta.y > 0) fuScaleMainWindow(reZoomDelta, 1)
        if((mCXDefinitions.mZoomFactor >= reMinimumZoom) && wheel.angleDelta.y <= 0) fuScaleMainWindow(reZoomDelta, 0)
      }
    }
  }
    Loader {
      id: loStatusBar
      anchors.leftMargin: ACMeasures.fuToDots(reCornerRadiusCm)
      anchors.left: parent.left
      anchors.rightMargin: ACMeasures.fuToDots(reCornerRadiusCm)
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      source: urStatusBar
      onLoaded: {
        rcStatusBarBackground.color = item.color
        rcStatusBarBackground.height = ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
        height = ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
        loStatusBar.item.reBorderWidth = reBorderWidth * mCXDefinitions.mZoomFactor
        loStatusBar.item.reMaximumZoom = reMaximumZoom
        loStatusBar.item.reMinimumZoom = reMinimumZoom
        loStatusBar.item.srCurrentCoin = Qt.binding(function() { return wiRoot.srCurrentCoin })
      }
    }
    Loader {
      id: loModulePanel
      anchors.top: parent.top //loTitleBar.bottom
      anchors.left: parent.left
      anchors.bottom: loStatusBar.top
      source: urModulePanel
    }
    Loader {
      id: loInfoBar
      anchors.top: parent.top//loTitleBar.bottom
      anchors.left: loModulePanel.right
      anchors.right: parent.right
      source: urInfoBar
      onLoaded: { srCurrentCoin = Qt.binding(function() { return item.srCurrentCoin }) }
    }
    Loader {
      id: loSearchPanel
      anchors.bottom: loStatusBar.top
      anchors.left: loModulePanel.right
      source: urSearchPanel
    }
    Loader {
      id: loLogPanel
      anchors.bottom: loStatusBar.top
      anchors.left: loSearchPanel.right
      anchors.top: loSearchPanel.top
      anchors.right: parent.right
      source: urLogPanel
      MouseArea {
        id: maLogPanel
        x: 0; y: 0; z: 1
        onWheel: { maRoot.onWheel(wheel) }
        Component.onCompleted: {
          height = 0
          width = 0
        }
      }
    }
    Loader {
      id: loWorkspace
      anchors.bottom: loSearchPanel.top
      anchors.left: loModulePanel.right
      anchors.top: loInfoBar.bottom
      anchors.right: parent.right
      source: urWorkspace
      MouseArea {
        id: maWorkspace
        x: 0; y: 0; z: 1
        onWheel: { maRoot.onWheel(wheel) }
        Component.onCompleted: {
          height = 0
          width = 0
        }
      }
      onLoaded: {
        loWorkspace.item.srCurrentCoin = Qt.binding(function() { return wiRoot.srCurrentCoin })
      }
    }
    Connections {
      target: loInfoBar.item
      onSiOpenUrl: { if(fuStartsWith(srUrl,"http://")) fOpenUrl(srUrl) }
      onSiComponentActivation: { loModulePanel.item.fuActivateComponent(srComponentName) }
      onSiHighlightComponentObject: { loWorkspace.item.fuHighlightObject(srComponentName, srObjectName) }
    }
    Connections {
      target: loModulePanel.item
      onSiComponentSelected: {
        loWorkspace.item.fuActivateComponent(srComponentName, srComponentLabel, inComponentCategory, inComponentType, boShow)
      }
    }
    Connections {
      target: loStatusBar.item
      onSiZoomChanged: { fuZoomMainWindow(reValue) }
      onSiWindowMoved: {
        wiRoot.x = wiRoot.x + poDelta.x
        wiRoot.y = wiRoot.y + poDelta.y
       mCXDefinitions.mX = wiRoot.x
        mCXDefinitions.mY = wiRoot.y
      }
    }

    Connections {
      target: mCXConnectorManager
      onSStatusChanged: {
        if(lName == "WDC" && (mCXConnectorManager.fStatus(lName) == CXDefinitions.EServiceReady) && boWDCFirstTime) {
          boWDCFirstTime = false;
          WABalance.mPollingTime = inWapptomPollingTime; WABalance.mStartingOffset = 100; WABalance.mActive = true; WABalance.mPrecision = 8;// WABalance.mParams = "\"*\" " + fDaemonSetting(mCXDefinitions.fDefaultDaemon(), "BalanceMinConfirmations")
          WABalanceWithoutConf.mPollingTime = inWapptomPollingTime; WABalanceWithoutConf.mStartingOffset = 200; WABalanceWithoutConf.mActive = true; WABalanceWithoutConf.mPrecision = 8; //WABalanceWithoutConf.mParams = "\"*\""
          WABestBlockHash.mPollingTime = inWapptomPollingTime * 2; WABestBlockHash.mStartingOffset = 300; WABestBlockHash.mActive = true;
          WABlockCount.mPollingTime = inWapptomPollingTime; WABlockCount.mStartingOffset = 400; WABlockCount.mActive = true;
          WAConnectionCount.mPollingTime = inWapptomPollingTime * 3; WAConnectionCount.mStartingOffset = 500; WAConnectionCount.mActive = true;
          WADifficulty.mPollingTime = inWapptomPollingTime; WADifficulty.mStartingOffset = 600; WADifficulty.mActive = true;
          WANetworkHashPS.mPollingTime = inWapptomPollingTime; WANetworkHashPS.mStartingOffset = 700; WANetworkHashPS.mActive = true;
          WAEncrypted.mPollingTime = 0; WAEncrypted.mSingleShot = true; WAEncrypted.mStartingOffset = 0; WAEncrypted.mActive = true;
          WNTotalBlockCount.mPollingTime = inWapptomPollingTime * 4; WNTotalBlockCount.mStartingOffset = 0; WNTotalBlockCount.mActive = true; WNTotalBlockCount.mInput = "https://www.wdcexplorer.com/q/getblockcount"; WNTotalBlockCount.mSource = "www.wdcexplorer.com"
          WNExchangeRate.mPollingTime = inWapptomPollingTime * 4; WNExchangeRate.mStartingOffset = 0; WNExchangeRate.mPrecision = 8; WNExchangeRate.mActive = true; WNExchangeRate.mInput = "https://api.cryptonator.com/api/ticker/wdc-usd"; WNExchangeRate.mSource = "www.cryptonator.com"
          WNPopularity.mPollingTime = inWapptomPollingTime * 10; WNPopularity.mSingleShot = false; WNPopularity.mStartingOffset = 0; WNPopularity.mActive = true; WNPopularity.mInput = "http://cryptocoin.cc/table.php?cryptocoin=worldcoin"; WNPopularity.mSource = "http://www.cryptocoin.cc"
        }
        if(lName == "BTC" && (mCXConnectorManager.fStatus(lName) == CXDefinitions.EServiceReady) && boBTCFirstTime) {
          boBTCFirstTime = false;
          WABalanceBTC.mPollingTime = inWapptomPollingTime;/* WABalanceBTC.mStartingOffset = 100;*/ WABalanceBTC.mActive = true; WABalanceBTC.mPrecision = 8;
          WABalanceWithoutConfBTC.mPollingTime = inWapptomPollingTime; WABalanceWithoutConfBTC.mStartingOffset = 200; WABalanceWithoutConfBTC.mActive = true; WABalanceWithoutConfBTC.mPrecision = 8; //WABalanceWithoutConf.mParams = "\"*\""
          WABestBlockHashBTC.mPollingTime = inWapptomPollingTime * 2; WABestBlockHashBTC.mStartingOffset = 300; WABestBlockHashBTC.mActive = true;
          WABlockCountBTC.mPollingTime = inWapptomPollingTime; WABlockCountBTC.mStartingOffset = 400; WABlockCountBTC.mActive = true;
          WAConnectionCountBTC.mPollingTime = inWapptomPollingTime * 3; WAConnectionCountBTC.mStartingOffset = 500; WAConnectionCountBTC.mActive = true;
          WADifficultyBTC.mPollingTime = inWapptomPollingTime; WADifficultyBTC.mStartingOffset = 600; WADifficultyBTC.mActive = true;
          WANetworkHashPSBTC.mPollingTime = inWapptomPollingTime; WANetworkHashPSBTC.mStartingOffset = 700; WANetworkHashPSBTC.mActive = true;
          WAEncryptedBTC.mPollingTime = 0; WAEncryptedBTC.mSingleShot = true; WAEncryptedBTC.mStartingOffset = 0; WAEncryptedBTC.mActive = true;
          WNTotalBlockCountBTC.mPollingTime = inWapptomPollingTime * 4; WNTotalBlockCountBTC.mStartingOffset = 0; WNTotalBlockCountBTC.mActive = true; WNTotalBlockCountBTC.mInput = "https://blockexplorer.com/api/status?q=getBlockCount"; WNTotalBlockCountBTC.mSource = "blockexplorer.com"
          WNExchangeRateBTC.mPollingTime = inWapptomPollingTime * 4; WNExchangeRateBTC.mStartingOffset = 0; WNExchangeRateBTC.mPrecision = 8; WNExchangeRateBTC.mActive = true; WNExchangeRateBTC.mInput = "https://api.cryptonator.com/api/ticker/btc-usd"; WNExchangeRateBTC.mSource = "www.cryptonator.com"
        }
        if(lName == "LTC" && (mCXConnectorManager.fStatus(lName) == CXDefinitions.EServiceReady) && boLTCFirstTime) {
          boLTCFirstTime = false;
          WABalanceLTC.mPollingTime = inWapptomPollingTime;/* WABalanceLTC.mStartingOffset = 100;*/ WABalanceLTC.mActive = true; WABalanceLTC.mPrecision = 8;
          WABalanceWithoutConfLTC.mPollingTime = inWapptomPollingTime; WABalanceWithoutConfLTC.mStartingOffset = 200; WABalanceWithoutConfLTC.mActive = true; WABalanceWithoutConfLTC.mPrecision = 8; //WABalanceWithoutConf.mParams = "\"*\""
          WABestBlockHashLTC.mPollingTime = inWapptomPollingTime * 2; WABestBlockHashLTC.mStartingOffset = 300; WABestBlockHashLTC.mActive = true;
          WABlockCountLTC.mPollingTime = inWapptomPollingTime; WABlockCountLTC.mStartingOffset = 400; WABlockCountLTC.mActive = true;
          WAConnectionCountLTC.mPollingTime = inWapptomPollingTime * 3; WAConnectionCountLTC.mStartingOffset = 500; WAConnectionCountLTC.mActive = true;
          WADifficultyLTC.mPollingTime = inWapptomPollingTime; WADifficultyLTC.mStartingOffset = 600; WADifficultyLTC.mActive = true;
          WANetworkHashPSLTC.mPollingTime = inWapptomPollingTime; WANetworkHashPSLTC.mStartingOffset = 700; WANetworkHashPSLTC.mActive = true;
          WAEncryptedLTC.mPollingTime = 0; WAEncryptedLTC.mSingleShot = true; WAEncryptedLTC.mStartingOffset = 0; WAEncryptedLTC.mActive = true;
          WNTotalBlockCountLTC.mPollingTime = inWapptomPollingTime * 4; WNTotalBlockCountLTC.mStartingOffset = 0; WNTotalBlockCountLTC.mActive = true; WNTotalBlockCountLTC.mInput = "http://chainz.cryptoid.info/ltc/api.dws?q=getblockcount"; WNTotalBlockCountLTC.mSource = "chainz.cryptoid.info"
          WNExchangeRateLTC.mPollingTime = inWapptomPollingTime * 4; WNExchangeRateLTC.mStartingOffset = 0; WNExchangeRateLTC.mPrecision = 8; WNExchangeRateLTC.mActive = true; WNExchangeRateLTC.mInput = "https://api.cryptonator.com/api/ticker/ltc-usd"; WNExchangeRateLTC.mSource = "www.cryptonator.com"
        }
        if(lName == "DOGE" && (mCXConnectorManager.fStatus(lName) == CXDefinitions.EServiceReady) && boDOGEFirstTime) {
          boDOGEFirstTime = false;
          WABalanceDOGE.mPollingTime = inWapptomPollingTime;/* WABalanceDOGE.mStartingOffset = 100;*/ WABalanceDOGE.mActive = true; WABalanceDOGE.mPrecision = 8;
          WABalanceWithoutConfDOGE.mPollingTime = inWapptomPollingTime; WABalanceWithoutConfDOGE.mStartingOffset = 200; WABalanceWithoutConfDOGE.mActive = true; WABalanceWithoutConfDOGE.mPrecision = 8; //WABalanceWithoutConf.mParams = "\"*\""
          WABestBlockHashDOGE.mPollingTime = inWapptomPollingTime * 2; WABestBlockHashDOGE.mStartingOffset = 300; WABestBlockHashDOGE.mActive = true;
          WABlockCountDOGE.mPollingTime = inWapptomPollingTime; WABlockCountDOGE.mStartingOffset = 400; WABlockCountDOGE.mActive = true;
          WAConnectionCountDOGE.mPollingTime = inWapptomPollingTime * 3; WAConnectionCountDOGE.mStartingOffset = 500; WAConnectionCountDOGE.mActive = true;
          WADifficultyDOGE.mPollingTime = inWapptomPollingTime; WADifficultyDOGE.mStartingOffset = 600; WADifficultyDOGE.mActive = true;
          WANetworkHashPSDOGE.mPollingTime = inWapptomPollingTime; WANetworkHashPSDOGE.mStartingOffset = 700; WANetworkHashPSDOGE.mActive = true;
          WAEncryptedDOGE.mPollingTime = 0; WAEncryptedDOGE.mSingleShot = true; WAEncryptedDOGE.mStartingOffset = 0; WAEncryptedDOGE.mActive = true;
          WNTotalBlockCountDOGE.mPollingTime = inWapptomPollingTime * 4; WNTotalBlockCountDOGE.mStartingOffset = 0; WNTotalBlockCountDOGE.mActive = true; WNTotalBlockCountDOGE.mInput = "https://dogechain.info/chain/Dogecoin/q/getblockcount"; WNTotalBlockCountDOGE.mSource = "dogechain.info"
          WNExchangeRateDOGE.mPollingTime = inWapptomPollingTime * 100; WNExchangeRateDOGE.mStartingOffset = 0; WNExchangeRateDOGE.mPrecision = 8; WNExchangeRateDOGE.mActive = true; WNExchangeRateDOGE.mInput = "https://api.cryptonator.com/api/ticker/doge-usd"; WNExchangeRateDOGE.mSource = "www.cryptonator.com"
        }
      }
    }

    Component.onCompleted: {
      wiRoot.height = ACMeasures.fuToDots(wiRoot.reHeightCm)
      wiRoot.width = ACMeasures.fuToDots(wiRoot.reWidthCm)
      var vaX = 0
      if(mCXDefinitions.mX < 0) vaX = (Screen.width - wiRoot.width) / 2
      else vaX = mCXDefinitions.mX
      wiRoot.x = vaX
      var vaY
      if(mCXDefinitions.mY < 0) vaY = (Screen.height - wiRoot.height) / 2
      else vaY = mCXDefinitions.mY
      wiRoot.y = vaY
      rcTitleBarBackground.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
      reOriginalZoom = mCXDefinitions.mZoomFactor      
    }
    Rectangle {
      id: rcCover
      anchors.fill: parent
      radius: ACMeasures.fuToDots(reCornerRadiusCm) * mCXDefinitions.mZoomFactor
      color: "Black"
      opacity: boReady ? 0 : 0.3

      Behavior on opacity {
        NumberAnimation {
          duration: 1000
          easing.type: Easing.Linear
        }
      }
    }
    AXFrame {
      id: rcNameTitle
      color: (boClosing) ? coCriticalBackgroundColor : coInfoBackgroundColor
      anchors.centerIn: rcCover
      opacity: (!boReady) ? 1 : 0
      reHeightCm: 1.5 * mCXDefinitions.mZoomFactor
     // reWidthCm: 20 * mCXDefinitions.mZoomFactor > ACMeasures.fuToCentimeters(axText.paintedWidth) + reBorderWidth ? 20 * mCXDefinitions.mZoomFactor : ACMeasures.fuToCentimeters(axText.paintedWidth) + reBorderWidth
      width: parent.width
      radius: ACMeasures.fuToDots(0.2)  * mCXDefinitions.mZoomFactor
      AXText {
        id: axText
        anchors.fill: parent
        horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
        text: (boClosing) ? qsTr("A critical update has been released. In order to preserve the security of the network as a whole an update is needed.\nWBC will close in a few seconds and the wizard will dowload necesary files") :
              qsTr("The wallet is indexing the database. This can take a few seconds/minutes.\nIf you downloaded the block chain and this is the first time you are running the wallet, this process can take a couple of hours")
        color: (boClosing) ? coCriticalTextColor : coInfoTextColor
    //    reSizeCm: parent.reHeightCm * 0.2
        font.bold: true
        font.italic: false
        font.family: srFontFamily
      }
      Behavior on opacity {
        NumberAnimation {
          duration: 1000
          easing.type: Easing.Linear
        }
      }

 /*   MouseArea {
      anchors.fill: parent
      enabled: (!boReady) ? 1 : 0
    }*/
  }
  Rectangle {
    id: rcBackground
    anchors.fill:  parent // omMask
    visible: false
    AXImage {
      fillMode: Image.Stretch
      anchors.fill: parent
      source: urBackgroundImage
    }
    Rectangle {
      id: rcTitleBarBackground
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
    }
    Rectangle {
      id: rcStatusBarBackground
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
    }

  }
  FXToolTip {
    id: ttDaemon
    width: ACMeasures.fuToDots(5)
    target: loInfoBar.item.vaDaemonButton
    text: {
      var vaText = qsTr("-- Backend Status (Daemon):\n")
      if(loInfoBar.item.vaDaemonButton.vaStatus === CXDefinitions.EServiceStopped) vaText += "Stopped."
      if(loInfoBar.item.vaDaemonButton.vaStatus === CXDefinitions.EServiceReady) vaText += "Ready!"
      if(loInfoBar.item.vaDaemonButton.vaStatus === CXDefinitions.EServiceProcessing) vaText += "Processing..."
      if(loInfoBar.item.vaDaemonButton.vaStatus === CXDefinitions.EServiceError) vaText += "Error!"
      return vaText
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttIcon
    width: ACMeasures.fuToDots(5.5)
    target: loInfoBar.item.vaIconButton
    text: qsTr("Feature Coming Soon\n\nPlaceholder for future feature.
")
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttUpdates
    width: ACMeasures.fuToDots(5.5)
    target: loInfoBar.item.vaUpdatesButton
    text: {
      var vaText = qsTr("Updater Status\n\n")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeLow) return vaText + qsTr("Low priority update available!")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeMedium) return vaText + qsTr("Medium priority update available!")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeHigh) return vaText + qsTr("High priority update available!")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeCritical) return vaText + qsTr("CRITICAL priority update available!")
      return vaText + qsTr("No new updates available.")
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttServices
    width: ACMeasures.fuToDots(4)
    target: loInfoBar.item.vaServicesButton
    text: {
      var vaText = qsTr("Cloud Connection\n\n")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceError) return vaText + qsTr("Connecting to cloud services failed. Please check your internet connection and firewall settings.")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceReady) return vaText + qsTr("Connection to cloud services successfully established.")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceStopped) return vaText + qsTr("Connection to cloud services is disconnected.")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceProcessing) return vaText + qsTr("System is connecting to cloud services. Please wait.")
      return vaText + qsTr("No information available.")
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttLock
    width: ACMeasures.fuToDots(4.5)
    target: loInfoBar.item.vaLockButton
    text: {
      var vaText = qsTr("Wallet Encryption\n\n")
      var vaValue = WAEncrypted.mValue
      if(loInfoBar.item.srCurrentCoin === "BTC")
        vaValue = WAEncryptedBTC.mValue
      if(loInfoBar.item.srCurrentCoin === "LTC")
        vaValue = WAEncryptedLTC.mValue
      if(loInfoBar.item.srCurrentCoin === "DOGE")
        vaValue = WAEncryptedDOGE.mValue
      if(vaValue === "1") return vaText + qsTr("Your wallet is encrypted and safe to use.")
      return vaText + qsTr("Your wallet is currently not encrypted.\nPlease encrypt your wallet in order to improve your security.")
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttSync
    width: ACMeasures.fuToDots(4)
    target: loInfoBar.item.vaSyncButton
    text: {
      var vaText = qsTr("Synchronization Status\n\n")
      var vaBlockCount = WABlockCount.mDisplayValue
      var vaTotalBlockCount = WNTotalBlockCount.mDisplayValue
      if(loInfoBar.item.srCurrentCoin === "BTC") {
        vaBlockCount = WABlockCountBTC.mDisplayValue
        vaTotalBlockCount = WNTotalBlockCountBTC.mDisplayValue
      }
      if(loInfoBar.item.srCurrentCoin === "LTC") {
        vaBlockCount = WABlockCountLTC.mDisplayValue
        vaTotalBlockCount = WNTotalBlockCountLTC.mDisplayValue
      }
      if(loInfoBar.item.srCurrentCoin === "DOGE") {
        vaBlockCount = WABlockCountDOGE.mDisplayValue
        vaTotalBlockCount = WNTotalBlockCountDOGE.mDisplayValue
      }

      if(Number(vaTotalBlockCount) > 0) {
        var vaPercent = Number(vaBlockCount) / Number(vaTotalBlockCount) * 100
        var vaBody;
        if(vaPercent >= 100) {
          vaPercent = 100
          vaBody = qsTr("Wallet is fully synchronized and ready to use.")
        }
        else vaBody = qsTr("Wallet is ") + vaPercent.toFixed(5) + qsTr("% synchronized. Please wait.")

        return vaText + vaBody
      }
      return vaText + qsTr("Information unavailable.")
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttConnections
    width: ACMeasures.fuToDots(4)
    target: loInfoBar.item.vaConnectionsButton
    text: {
      var vaConnectionCount = WAConnectionCount.mValue
      var vaConnectionCountDisplay = WAConnectionCount.mDisplayValue
      if(loInfoBar.item.srCurrentCoin === "BTC") {
        vaConnectionCount = WAConnectionCountBTC.mValue
        vaConnectionCountDisplay = WAConnectionCountBTC.mDisplayValue
      }
      if(loInfoBar.item.srCurrentCoin === "LTC") {
        vaConnectionCount = WAConnectionCountLTC.mValue
        vaConnectionCountDisplay = WAConnectionCountLTC.mDisplayValue
      }
      if(loInfoBar.item.srCurrentCoin === "DOGE") {
        vaConnectionCount = WAConnectionCountDOGE.mValue
        vaConnectionCountDisplay = WAConnectionCountDOGE.mDisplayValue
      }

      var vaText = qsTr("Node Connections\n\n")
      if(Number(vaConnectionCount) <= 0) return vaText + qsTr("No peers available.\nSearching for more.")
      if((Number(vaConnectionCount) > 0) && (Number(vaConnectionCount) < 8)) return  vaText + qsTr("You are connected to ") + vaConnectionCountDisplay + qsTr("/8 peers.\nSearching for more.")
      if(Number(vaConnectionCount) >= 8) return vaText + qsTr("You are connected to ") + vaConnectionCountDisplay + qsTr("/8 peers.\n")
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  FXToolTip {
    id: ttPopularity
    width: ACMeasures.fuToDots(8)
    target: loInfoBar.item.vaPopularity
    text: {
      var vaText = qsTr("Currency Ranking\n\n")
    //  qsTr("-- Popularity: (" + WNPopularity.mSource + ")\n")
      if(Number(WNPopularity.mValue) == 0) return vaText + qsTr("No info available")
      var vaSource = WNPopularity.mSource
      return vaText + WNPopularity.mDisplayValue + "\n\nSource: " + vaSource
    }
    backgroundColor: coToolTipBackgroundColor
    textColor: coToolTipTextColor
    radius: ACMeasures.fuToDots(reToolTipRadius)
    font: srFontFamily
  }
  Connections {
    target: wiRoot
    onSKeyPressed: {
      if(lKeyCode == Qt.Key_Control) {
        maLogPanel.height = loLogPanel.height
        maLogPanel.width = loLogPanel.width
        maWorkspace.height = loWorkspace.height
        maWorkspace.width = loWorkspace.width
      }
      if(lKeyCode == Qt.Key_Escape && boIsMaximized) {
        fuShowMaximized()
      }
      if ((lKeyCode == Qt.Key_Plus) && (lModifiers & Qt.ControlModifier)) if(mCXDefinitions.mZoomFactor <= reMaximumZoom) fuScaleMainWindow(0.03, 1)
      if ((lKeyCode == Qt.Key_Minus) && (lModifiers & Qt.ControlModifier)) if(mCXDefinitions.mZoomFactor >= reMinimumZoom) fuScaleMainWindow(0.03, 0)
    }
    onSKeyReleased: {
      if(lKeyCode == Qt.Key_Control) {
        maLogPanel.height = 0
        maLogPanel.width = 0
        maWorkspace.height = 0
        maWorkspace.width = 0
      }
    }
  }
  function fuScaleMainWindow(reZoomDelta, boExpanding) {
    var vaCurrentWidth = wiRoot.width
    var vaCurrentHeight = wiRoot.height
    var vaCurrentX = wiRoot.x
    var vaCurrentY = wiRoot.y
    var vaZoomFactor = 0
    if(boExpanding) vaZoomFactor = 1 / (1 - reZoomDelta)
    else vaZoomFactor = (1 - reZoomDelta)

    if((wiRoot.x < 0) || (wiRoot.y < 0)/* || ((wiRoot.x + wiRoot.width) > Screen.width) || ((wiRoot.y + wiRoot.height) > Screen.height)*/
      || ((wiRoot.height < ACMeasures.fuToDots(reMinimumHeightCm)) && !boExpanding) || ((wiRoot.width < ACMeasures.fuToDots(reMinimumWidthCm)) && !boExpanding)) {
      wiRoot.height = vaCurrentHeight
      wiRoot.width = vaCurrentWidth
      wiRoot.x = vaCurrentX
      wiRoot.y = vaCurrentY
    }
    else {
      if((wiRoot.x + wiRoot.width) > Screen.width) wiRoot.width = Screen.width - wiRoot.x
      if((wiRoot.y + wiRoot.height) > Screen.height) wiRoot.height = Screen.height - wiRoot.y
      mCXDefinitions.mX = wiRoot.x
      mCXDefinitions.mY = wiRoot.y
      mCXDefinitions.mWidth = ACMeasures.fuToCentimeters(wiRoot.width)
      mCXDefinitions.mHeight = ACMeasures.fuToCentimeters(wiRoot.height)   

      if(boExpanding) mCXDefinitions.mZoomFactor = mCXDefinitions.mZoomFactor / (1 - reZoomDelta)
      else mCXDefinitions.mZoomFactor = mCXDefinitions.mZoomFactor * (1 - reZoomDelta)

      reHeightCm = mCXDefinitions.mHeight
      reWidthCm = mCXDefinitions.mWidth

      loStatusBar.height = ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
      loModulePanel.item.fuScale()
      loInfoBar.item.fuScale()
      loSearchPanel.item.fuScale()
      loWorkspace.item.fuScaleComponents()
      rcTitleBarBackground.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
      rcStatusBarBackground.height = ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
    }
  }
  function fuZoomMainWindow(reZoomValue) {
    var vaCurrentWidth = wiRoot.width
    var vaCurrentHeight = wiRoot.height
    var vaCurrentX = wiRoot.x
    var vaCurrentY = wiRoot.y

    if((wiRoot.x < 0) || (wiRoot.y < 0) /*|| (wiRoot.height < ACMeasures.fuToDots(reMinimumHeightCm))  || (wiRoot.width < ACMeasures.fuToDots(reMinimumWidthCm))*/) {
        wiRoot.height = vaCurrentHeight
        wiRoot.width = vaCurrentWidth
        wiRoot.x = vaCurrentX
        wiRoot.y = vaCurrentY
    }
    else {
      if((wiRoot.x + wiRoot.width) > Screen.width) wiRoot.width = Screen.width - wiRoot.x
      if((wiRoot.y + wiRoot.height) > Screen.height) wiRoot.height = Screen.height - wiRoot.y
      mCXDefinitions.mX = wiRoot.x
      mCXDefinitions.mY = wiRoot.y
      mCXDefinitions.mWidth = ACMeasures.fuToCentimeters(wiRoot.width)
      mCXDefinitions.mHeight = ACMeasures.fuToCentimeters(wiRoot.height)
      mCXDefinitions.mZoomFactor = reZoomValue
      reHeightCm = mCXDefinitions.mHeight
      reWidthCm = mCXDefinitions.mWidth

 /**     loTitleBar.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor  **/
      loStatusBar.height = ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
      loModulePanel.item.fuScale()
      loInfoBar.item.fuScale()
      loSearchPanel.item.fuScale()
      loWorkspace.item.fuScaleComponents()
      rcTitleBarBackground.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
      rcStatusBarBackground.height = ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
    }
  }
  function fuShowMaximized() {
    if(boIsMaximized) {
      wiRoot.height = rePreviousHeight
      wiRoot.width = rePreviousWidth
      wiRoot.x = rePreviousX
      wiRoot.y = rePreviousY
      boIsMaximized = false
    }
    else {
      rePreviousHeight = wiRoot.height
      rePreviousWidth = wiRoot.width
      rePreviousX = wiRoot.x
      rePreviousY = wiRoot.y

      wiRoot.height = Screen.height
      wiRoot.width = Screen.width
      wiRoot.x = 0
      wiRoot.y = 0
      boIsMaximized = true
    }
    mCXDefinitions.mX = wiRoot.x
    mCXDefinitions.mY = wiRoot.y
    mCXDefinitions.mWidth = ACMeasures.fuToCentimeters(wiRoot.width)
    mCXDefinitions.mHeight = ACMeasures.fuToCentimeters(wiRoot.height)
    reWidthCm = ACMeasures.fuToCentimeters(wiRoot.width)
    reHeightCm = ACMeasures.fuToCentimeters(wiRoot.height)
  }
  function fuStartsWith(srString, srPrefix) {
    return srString.slice(0, srPrefix.length) == srPrefix;
  }
}

