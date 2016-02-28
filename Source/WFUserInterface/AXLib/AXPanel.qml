import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import ACMeasures.Lib 1.0
import WFCore.Lib 1.0
import WFDefinitions.Lib 1.0

GXWindow {
  id: wiRoot
  flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window
  color: /*"gray" //*/ "transparent"

  property string srFontFamily
  property color coTextColor
  property bool boFirstTime: true
  property bool boReady: mCXStatus.mDaemonStatus === CXDefinitions.EServiceReady ? true : false
  property bool boClosing: mCXStatus.mDaemonStatus === CXDefinitions.EServiceClosing ? true : false
  property bool boIsMaximized: false
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

  Rectangle {
    id: rcMask
    anchors.fill: parent // omMask
    color: "white"
    radius: ACMeasures.fuToDots(reCornerRadiusCm) * mCXDefinitions.mZoomFactor
    visible: false
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
  OpacityMask {
    id: omMask
    source: rcBackground
    maskSource: rcMask
    visible: true
    anchors.fill: parent
    focus: true
    Loader {
      id: loTitleBar
      anchors.top: parent.top
      anchors.leftMargin: ACMeasures.fuToDots(reCornerRadiusCm) * mCXDefinitions.mZoomFactor
      anchors.left: parent.left
      anchors.rightMargin: ACMeasures.fuToDots(reCornerRadiusCm) * mCXDefinitions.mZoomFactor
      anchors.right: parent.right
      source: urTitleBar
      onLoaded: {
        rcTitleBarBackground.color = item.color
        rcMask.color = item.color
        rcTitleBarBackground.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
        height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
        loTitleBar.item.reBorderWidth = reBorderWidth * mCXDefinitions.mZoomFactor
        loTitleBar.item.boMainWindowMaximized = Qt.binding(function() { return wiRoot.boIsMaximized })
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
      }
    }
    Image {
      id: rcResizeHandlerTopLeft
      anchors.top: loTitleBar.top
      anchors.bottom: loTitleBar.bottom
      anchors.left: omMask.left
      width: height
      source: urResizeHandlerImage
      fillMode: Image.Pad
      clip: true
      MouseArea {
        id: maResizeHandlerTopLeft
        anchors.fill: parent
        cursorShape: Qt.SizeFDiagCursor
        preventStealing: true
        onPressed: { poResizeClickPos = Qt.point(mouse.x,mouse.y) }
        onPositionChanged: {
          var vaDelta = Qt.point(mouse.x - poResizeClickPos.x, mouse.y - poResizeClickPos.y)
          rcTopBorder.fuResizeTop()
          rcLeftBorder.fuResizeLeft()
        }
      }
    }
    Image {
      id: rcResizeHandlerBottomLeft
      anchors.top: loStatusBar.top
      anchors.bottom: loStatusBar.bottom
      anchors.left: omMask.left
      width: height
      source: urResizeHandlerImage
      fillMode: Image.Pad
      clip: true
      MouseArea {
        id: maResizeHandlerBottomLeft
        anchors.fill: parent
        cursorShape: Qt.SizeBDiagCursor
        preventStealing: true
        onPressed: { poResizeClickPos = Qt.point(mouse.x,mouse.y) }
        onPositionChanged: {
          var vaDelta = Qt.point(mouse.x - poResizeClickPos.x, mouse.y - poResizeClickPos.y)
          rcBottomBorder.fuResizeBottom()
          rcLeftBorder.fuResizeLeft()
        }
      }
    }
    Image {
      id: rcResizeHandlerTopRight
      anchors.top: loTitleBar.top
      anchors.bottom: loTitleBar.bottom
      anchors.right: omMask.right
      width: height
      source: urResizeHandlerImage
      fillMode: Image.Pad
      clip: true
      MouseArea {
        id: maResizeHandlerTopRight
        anchors.fill: parent
        cursorShape: Qt.SizeBDiagCursor
        preventStealing: true
        onPressed: { poResizeClickPos = Qt.point(mouse.x,mouse.y) }
        onPositionChanged: {
          var vaDelta = Qt.point(mouse.x - poResizeClickPos.x, mouse.y - poResizeClickPos.y)
          rcTopBorder.fuResizeTop()
          rcRightBorder.fuResizeRight()
        }
      }
    }
    Image {
      id: rcResizeHandlerBottomRight
      anchors.top: loStatusBar.top
      anchors.bottom: loStatusBar.bottom
      anchors.right: omMask.right
      width: height
      source: urResizeHandlerImage
      fillMode: Image.Pad
      clip: true
      MouseArea {
        id: maResizeHandlerRight
        anchors.fill: parent
        cursorShape: Qt.SizeFDiagCursor
        preventStealing: true
        onPressed: { poResizeClickPos = Qt.point(mouse.x,mouse.y) }
        onPositionChanged: {
          var vaDelta = Qt.point(mouse.x - poResizeClickPos.x, mouse.y - poResizeClickPos.y)
          rcBottomBorder.fuResizeBottom()
          rcRightBorder.fuResizeRight()
        }
      }
    }
    Loader {
      id: loModulePanel
      anchors.top: loTitleBar.bottom
      anchors.left: parent.left
      anchors.bottom: loStatusBar.top
      source: urModulePanel
    }
    Loader {
      id: loInfoBar
      anchors.top: loTitleBar.bottom
      anchors.left: loModulePanel.right
      anchors.right: parent.right
      source: urInfoBar
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
    }
    Connections {
      target: loInfoBar.item
      onSiOpenUrl: { if(fuStartsWith(srUrl,"http://")) fOpenUrl(srUrl) }
      onSiComponentActivation: { loModulePanel.item.fuActivateComponent(srComponentName) }
      onSiHighlightComponentObject: { loWorkspace.item.fuHighlightObject(srComponentName, srObjectName) }
    }
    Connections {
      target: loTitleBar.item
      onSiCloseButtonClicked: {
        if(mCXDefinitions.mMinimizeOnClose == "0") {
          maRoot.propagateComposedEvents = false;
          maRoot.z = 10000;
          maRoot.enabled = false;
          loTitleBar.item.boMouseEnabled = false;
          wiRoot.siCloseRequested();
        }
        else wiRoot.hide()
      }
      onSiMinimizeButtonClicked: {
        if(mCXDefinitions.mMinimizeToTray == "0") wiRoot.showMinimized()
        else wiRoot.hide()
      }
      onSiMaximizeButtonClicked: { fuShowMaximized() }      
      onSiWindowMoved: {
        wiRoot.x = wiRoot.x + poDelta.x
        wiRoot.y = wiRoot.y + poDelta.y
        mCXDefinitions.mX = wiRoot.x
        mCXDefinitions.mY = wiRoot.y
      }
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
      target: mCXStatus
      onSDaemonStatusChanged: {
        if((mCXStatus.mDaemonStatus == CXDefinitions.EServiceReady) && boFirstTime) {
          WABalance.mPollingTime = inWapptomPollingTime; WABalance.mStartingOffset = 100; WABalance.mActive = true; WABalance.mPrecision = 8;// WABalance.mParams = "\"*\" " + fDaemonSetting(mCXDefinitions.fDefaultDaemon(), "BalanceMinConfirmations")
          WABalanceWithoutConf.mPollingTime = inWapptomPollingTime; WABalanceWithoutConf.mStartingOffset = 200; WABalanceWithoutConf.mActive = true; WABalanceWithoutConf.mPrecision = 8; //WABalanceWithoutConf.mParams = "\"*\""
          WABestBlockHash.mPollingTime = inWapptomPollingTime * 2; WABestBlockHash.mStartingOffset = 300; WABestBlockHash.mActive = true;
          WABlockCount.mPollingTime = inWapptomPollingTime; WABlockCount.mStartingOffset = 400; WABlockCount.mActive = true;
          WAConnectionCount.mPollingTime = inWapptomPollingTime * 3; WAConnectionCount.mStartingOffset = 500; WAConnectionCount.mActive = true;
          WADifficulty.mPollingTime = inWapptomPollingTime; WADifficulty.mStartingOffset = 600; WADifficulty.mActive = true;
          WANetworkHashPS.mPollingTime = inWapptomPollingTime; WANetworkHashPS.mStartingOffset = 700; WANetworkHashPS.mActive = true;
          WAEncrypted.mPollingTime = 0; WAEncrypted.mSingleShot = true; WAEncrypted.mStartingOffset = 0; WAEncrypted.mActive = true;
          WNTotalBlockCount.mPollingTime = inWapptomPollingTime * 4; WNTotalBlockCount.mStartingOffset = 0; WNTotalBlockCount.mActive = true; WNTotalBlockCount.mInput = "https://www.wdcexplorer.com/q/getblockcount"; WNTotalBlockCount.mSource = "www.wdcexplorer.com"
          WNExchangeRate.mPollingTime = inWapptomPollingTime * 4; WNExchangeRate.mStartingOffset = 0; WNExchangeRate.mPrecision = 8; WNExchangeRate.mActive = true; WNExchangeRate.mInput = "https://www.cryptodiggers.eu/api/api.php?a=get_exch_rate&currency_crypto=7&currency=2&public=1"; WNExchangeRate.mSource = "www.cryptodiggers.eu"
          WNPopularity.mPollingTime = inWapptomPollingTime; WNPopularity.mSingleShot = true; WNPopularity.mStartingOffset = 0; WNPopularity.mActive = true; WNPopularity.mInput = "http://cryptocoin.cc/table.php?cryptocoin=worldcoin"; WNPopularity.mSource = "http://www.cryptocoin.cc"
        }
      }
    }

    Component.onCompleted: {
      wiRoot.height = ACMeasures.fuToDots(wiRoot.reHeightCm) //* mCXDefinitions.mZoomFactor
      wiRoot.width = ACMeasures.fuToDots(wiRoot.reWidthCm) //* mCXDefinitions.mZoomFactor
      var vaX = 0
      if(mCXDefinitions.mX < 0) vaX = (Screen.width - wiRoot.width) / 2
      else vaX = mCXDefinitions.mX
      wiRoot.x = vaX
      var vaY
      if(mCXDefinitions.mY < 0) vaY = (Screen.height - wiRoot.height) / 2
      else vaY = mCXDefinitions.mY
      wiRoot.y = vaY
      loTitleBar.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
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
      reWidthCm: 20 * mCXDefinitions.mZoomFactor > ACMeasures.fuToCentimeters(axText.paintedWidth) + reBorderWidth ? 20 * mCXDefinitions.mZoomFactor : ACMeasures.fuToCentimeters(axText.paintedWidth) + reBorderWidth
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
    }
  }
  Rectangle {
    id: rcBackground
    anchors.fill: omMask
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
  Rectangle {
    id: rcTopBorder
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reCornerRadiusCm)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(reCornerRadiusCm)
    color: coTopBorderColor
    height: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeVerCursor
      onPositionChanged: { parent.fuResizeTop() }
    }
    function fuResizeTop() {
      var newY = fMouseGlobalPosition().y
      var newH = wiRoot.y - newY  + wiRoot.height
        //if(newY > wiRoot.y) loWorkspace.item.fuMoveBottomBorder()
      if(newH >= ACMeasures.fuToDots(reMinimumHeightCm)) {
        fSetGeometry(wiRoot.x, newY, wiRoot.width, newH)
        reHeightCm = ACMeasures.fuToCentimeters(newH)
        mCXDefinitions.mHeight = ACMeasures.fuToCentimeters(newH)
        mCXDefinitions.mY = newY
        boIsMaximized = false
      }
    }

  }
  Rectangle {
    id: rcBottomBorder
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(reCornerRadiusCm)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(reCornerRadiusCm)
    color: coBottomBorderColor
    height: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeVerCursor
      onPositionChanged: { parent.fuResizeBottom() }
    }
    function fuResizeBottom() {
      var newY = fMouseGlobalPosition().y
      var newH = newY - wiRoot.y
      if(newH >= ACMeasures.fuToDots(reMinimumHeightCm)) {
        wiRoot.height = newH
        reHeightCm = ACMeasures.fuToCentimeters(newH)
        mCXDefinitions.mHeight = ACMeasures.fuToCentimeters(newH)
        boIsMaximized = false
      }
    }
  }
  Rectangle {
    id: rcRightBorder
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reCornerRadiusCm)
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
    anchors.right: parent.right
    color: coRightBorderColor
    width: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeHorCursor
      onPositionChanged: { parent.fuResizeRight() }
    }
    function fuResizeRight() {
      var newX = fMouseGlobalPosition().x
      var newW = newX - wiRoot.x
      if(newW >= ACMeasures.fuToDots(reMinimumWidthCm)) {
        wiRoot.width = newW
        reWidthCm = ACMeasures.fuToCentimeters(newW)
        mCXDefinitions.mWidth = ACMeasures.fuToCentimeters(newW)
        boIsMaximized = false
      }
    }
  }
  Rectangle {
    id: rcLeftBorder
    anchors.top: parent.top
    anchors.topMargin: ACMeasures.fuToDots(reCornerRadiusCm)
    anchors.bottom: parent.bottom
    anchors.bottomMargin: ACMeasures.fuToDots(reStatusBarHeight) * mCXDefinitions.mZoomFactor
    anchors.left: parent.left
    color: coLeftBorderColor
    width: ACMeasures.fuToDots(reBorderWidth) * mCXDefinitions.mZoomFactor
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.SizeHorCursor
      onPositionChanged: { parent.fuResizeLeft() }
    }
    function fuResizeLeft() {
      var newX = fMouseGlobalPosition().x
      var newW = wiRoot.x - newX  + wiRoot.width
      if(newW >= ACMeasures.fuToDots(reMinimumWidthCm)) {
        wiRoot.x = newX
        wiRoot.width = newW
        reWidthCm = ACMeasures.fuToCentimeters(newW)
        mCXDefinitions.mWidth = ACMeasures.fuToCentimeters(newW)
        mCXDefinitions.mX = newX
        boIsMaximized = false
      }
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
    text: qsTr("Not implemented yet!\nTemporal placeholder.")
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
      var vaText = qsTr("-- Updater Status:\n")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeLow) return vaText + qsTr("Low priority update available!")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeMedium) return vaText + qsTr("Medium priority update available!")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeHigh) return vaText + qsTr("High priority update available!")
      if(loInfoBar.item.vaUpdatesButton.vaUpdatePriority == CXDefinitions.EUpgradeCritical) return vaText + qsTr("CRITICAL priority update available!")
      return vaText + qsTr("No updates available")
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
      var vaText = qsTr("-- Cloud services: \n")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceError) return vaText + qsTr("Connection Error!")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceReady) return vaText + qsTr("Connection succesfull!")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceStopped) return vaText + qsTr("Disconnected.")
      if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceProcessing) return vaText + qsTr("Attempting connection ...")
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
      var vaText = qsTr("-- Encryption Status:\n")
      if(WAEncrypted.mValue === "1") return vaText + qsTr("Wallet Encrypted!")
      return vaText + qsTr("Wallet not encrypted!\nPlease encrypt your wallet for enhanced security.")
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
      var vaText = qsTr("-- Sync Status:\n")
      if(Number(WNTotalBlockCount.mDisplayValue) > 0) {
        var vaPercent = Number(WABlockCount.mDisplayValue) / Number(WNTotalBlockCount.mDisplayValue) * 100
        if(vaPercent > 100) vaPercent = 100
        return vaText + qsTr(vaPercent.toString() + "%")
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
      var vaText = qsTr("-- Node connections:\n")
      if(Number(WAConnectionCount.mValue) <= 0) return vaText + qsTr("No peers available.\nSearching for more...")
      if((Number(WAConnectionCount.mValue) > 0) && (Number(WAConnectionCount.mValue) < 8)) return vaText + WAConnectionCount.mDisplayValue + qsTr(" peers available.\nSearching for more...")
      if(Number(WAConnectionCount.mValue) >= 8) return vaText + WAConnectionCount.mDisplayValue + qsTr(" peers available.\nNo more needed.")
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
      var vaText = qsTr("-- Popularity: (" + WNPopularity.mSource + ")\n")
      if(Number(WNPopularity.mValue) == 0) return vaText + qsTr("No info available")
      return vaText + WNPopularity.mDisplayValue
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

      loTitleBar.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
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
//    wiRoot.height =  ACMeasures.fuToDots(wiRoot.reHeightCm) * reZoomValue
//    wiRoot.width =  ACMeasures.fuToDots(wiRoot.reWidthCm) * reZoomValue

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

      loTitleBar.height = ACMeasures.fuToDots(reTitleBarHeight) * mCXDefinitions.mZoomFactor
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

