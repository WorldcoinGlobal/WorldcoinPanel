import QtQuick 2.4
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  property string srBalance: WABalance.mDisplayValue
  property string srBalanceWithoutConf: WABalanceWithoutConf.mDisplayValue
  property string srEncrypted: WAEncrypted.mDisplayValue
  property string srTotalBlockCount: WNTotalBlockCount.mDisplayValue
  property string srBlockCount: WABlockCount.mDisplayValue
  property string srConnections: WAConnectionCount.mDisplayValue
  property string srDifficulty: WADifficulty.mDisplayValue
  property string srNetworkHashPS: WANetworkHashPS.mDisplayValue
  property string srExchangeRate: WNExchangeRate.mDisplayValue
  property string srBestBlockHash: WABestBlockHash.mDisplayValue
  property real rePreviousBalance: 0
  property real reColumnWidth: 6.3

  id: rcRoot
  reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight * 4 + SStyleSheet.reComponentHorizontalHeaderRowHeight * grGrid.rows //6
  reWidthCm: 11

  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  AXFrame {
    id: rcConceptTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
    reWidthCm: reColumnWidth
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
  }
  AXFrame {
    id: rcValueTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: rcConceptTitle.right
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Image {
      id: imCrypto
      source: {
       if(mCurrentCoin === "BTC") return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_BTC.png"), false)
       if(mCurrentCoin === "LTC") return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_LTC.png"), false)
       if(mCurrentCoin === "DOGE") return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_DOGE.png"), false)
       return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady.png"), false)
      }
      fillMode: Image.Stretch
      anchors.left: parent.left
      anchors.leftMargin: parent.width / 3
      anchors.top: parent.top
      anchors.topMargin: parent.height / 10
      anchors.bottomMargin: parent.height / 10
      anchors.bottom: parent.bottom
      sourceSize.height: mCXDefinitions.ESizeSmall
      sourceSize.width: mCXDefinitions.ESizeSmall
      width: height

    }
    Text {
      anchors.left: imCrypto.right
      anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: mCurrentCoin
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }

  Component {
    id: coConcept
    AXFrame {        
      property alias srText: coConceptText.text
      clip: true
      color: SStyleSheet.coComponentVerticalHeaderColor
      reHeightCm: SStyleSheet.reComponentRowHeight
      reWidthCm: reColumnWidth
      radius: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) / 2
      Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.height
        color: parent.color
      }
      Text {
        id: coConceptText
        anchors.fill: parent
        anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
        horizontalAlignment: "AlignLeft"
        verticalAlignment: "AlignVCenter"
        color: SStyleSheet.coComponentVerticalHeaderTextColor
        font.bold: true
        font.family: SStyleSheet.srComponentFont
      }
    }
  }
  Component {
    id: coValue
    Rectangle {
      property alias srText: coValueText.text

      color: "transparent"
      height: rcValueTitle.height
      width: rcValueTitle.width
      AXTextEdit {
        id: coValueText
        anchors.fill: parent
        anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
        readOnly: true
        selectByMouse: true
        horizontalAlignment: "AlignLeft"
        verticalAlignment: "AlignVCenter"
        color: SStyleSheet.coComponentDetailTextColor
        font.family: SStyleSheet.srComponentFont
      }
    }
  }

  Grid {
    id: grGrid
    objectName: "Grid"
    anchors.top: rcConceptTitle.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    columns: 2
    rows: 10
    spacing: -1
    flow: Grid.TopToBottom

    Loader {
      objectName: "Peers"
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("# of Connections") }
    }
    Loader { 
      objectName: "Sync"
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Block Count / Total Blocks *") }
    }
    Loader {
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Difficulty") }
    }
    Loader {
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Hashrate") }
    }
    Loader {
      objectName: "Encrypted"
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Wallet Encryption") }
    }
    Loader {
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Balance") }
    }
    Loader {
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Unconfirmed") }
    }
    Loader {
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Exchange Rate / Total (Usd.) **") }
    }
    Loader {
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Best Block Hash") }
    }
    Loader {
      objectName: "PulzarStatus"
      sourceComponent: coConcept
      onLoaded: { item.srText = qsTr("Cloud Services (Pulzar)") }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: {
        item.srText = Qt.binding(function() {
          var vaConnections = "";
          if(srConnections == "1") vaConnections = srConnections + "   Connection"
          else vaConnections = srConnections + "   Connections"
          return vaConnections
        } )
      }
    }
    Loader {        
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srBlockCount + " / " + srTotalBlockCount}) }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srDifficulty}) }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srNetworkHashPS + " h/s"}) }
    }
    Loader {
      id: loEncrypted
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srEncrypted }) }
    }
    Loader {
      id: loBalance
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return  srBalance}) }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srBalanceWithoutConf }) }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srExchangeRate + " / " + (parseFloat(srExchangeRate) * parseFloat(srBalance)).toFixed(8) }) }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() { return srBestBlockHash }) }
    }
    Loader {
      sourceComponent: coValue
      onLoaded: { item.srText = Qt.binding(function() {
        if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceError) return qsTr("Error")
        if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceReady) return qsTr("Ready!")
        if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceStopped) return qsTr("Stopped")
        if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceProcessing) return qsTr("Processing...")
      }) }
    }
  }
  AXFrame {
    id: rcSources
    clip: true
    color: SStyleSheet.coComponentInternalBorderColor
    anchors.top: grGrid.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight * 2
    Text {
      anchors.fill: parent
      anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: {
        var vaTotSource = WNTotalBlockCount.mSource
        var vaExchangeRate = WNExchangeRate.mSource
        if(mCurrentCoin === "BTC") {
          vaTotSource = WNTotalBlockCountBTC.mSource
          vaExchangeRate = WNExchangeRateBTC.mSource
        }
        if(mCurrentCoin === "LTC") {
          vaTotSource = WNTotalBlockCountLTC.mSource
          vaExchangeRate = WNExchangeRateLTC.mSource
        }
        if(mCurrentCoin === "DOGE") {
          vaTotSource = WNTotalBlockCountDOGE.mSource
          vaExchangeRate = WNExchangeRateDOGE.mSource
        }

        return ("*   Source: " + vaTotSource + "\n**  Source: " + vaExchangeRate)
      }
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  onMCurrentCoinChanged: {
    if(mCurrentCoin === "WDC") {
      srBalance = Qt.binding(function() { return WABalance.mDisplayValue })
      srEncrypted = Qt.binding(function() { return WAEncrypted.mDisplayValue })
      srTotalBlockCount = Qt.binding(function() { return WNTotalBlockCount.mDisplayValue })
      srBlockCount = Qt.binding(function() { return WABlockCount.mDisplayValue })
      srConnections = Qt.binding(function() { return WAConnectionCount.mDisplayValue })
      srDifficulty = Qt.binding(function() { return WADifficulty.mDisplayValue })
      srNetworkHashPS = Qt.binding(function() { return WANetworkHashPS.mDisplayValue })
      srExchangeRate = Qt.binding(function() { return WNExchangeRate.mDisplayValue })
      srBestBlockHash = Qt.binding(function() { return WABestBlockHash.mDisplayValue })
      srBalanceWithoutConf = Qt.binding(function() { return WABalanceWithoutConf.mDisplayValue })
    }
    if(mCurrentCoin === "BTC") {
      srBalance = Qt.binding(function() { return WABalanceBTC.mDisplayValue })
      srEncrypted = Qt.binding(function() { return WAEncryptedBTC.mDisplayValue })
      srTotalBlockCount = Qt.binding(function() { return WNTotalBlockCountBTC.mDisplayValue })
      srBlockCount = Qt.binding(function() { return WABlockCountBTC.mDisplayValue })
      srConnections = Qt.binding(function() { return WAConnectionCountBTC.mDisplayValue })
      srDifficulty = Qt.binding(function() { return WADifficultyBTC.mDisplayValue })
      srNetworkHashPS = Qt.binding(function() { return WANetworkHashPSBTC.mDisplayValue })
      srExchangeRate = Qt.binding(function() { return WNExchangeRateBTC.mDisplayValue })
      srBestBlockHash = Qt.binding(function() { return WABestBlockHashBTC.mDisplayValue })
      srBalanceWithoutConf = Qt.binding(function() { return WABalanceWithoutConfBTC.mDisplayValue })
    }
    if(mCurrentCoin === "LTC") {
      srBalance = Qt.binding(function() { return WABalanceLTC.mDisplayValue })
      srEncrypted = Qt.binding(function() { return WAEncryptedLTC.mDisplayValue })
      srTotalBlockCount = Qt.binding(function() { return WNTotalBlockCountLTC.mDisplayValue })
      srBlockCount = Qt.binding(function() { return WABlockCountLTC.mDisplayValue })
      srConnections = Qt.binding(function() { return WAConnectionCountLTC.mDisplayValue })
      srDifficulty = Qt.binding(function() { return WADifficultyLTC.mDisplayValue })
      srNetworkHashPS = Qt.binding(function() { return WANetworkHashPSLTC.mDisplayValue })
      srExchangeRate = Qt.binding(function() { return WNExchangeRateLTC.mDisplayValue })
      srBestBlockHash = Qt.binding(function() { return WABestBlockHashLTC.mDisplayValue })
      srBalanceWithoutConf = Qt.binding(function() { return WABalanceWithoutConfLTC.mDisplayValue })
    }
    if(mCurrentCoin === "DOGE") {
      srBalance = Qt.binding(function() { return WABalanceDOGE.mDisplayValue })
      srEncrypted = Qt.binding(function() { return WAEncryptedDOGE.mDisplayValue })
      srTotalBlockCount = Qt.binding(function() { return WNTotalBlockCountDOGE.mDisplayValue })
      srBlockCount = Qt.binding(function() { return WABlockCountDOGE.mDisplayValue })
      srConnections = Qt.binding(function() { return WAConnectionCountDOGE.mDisplayValue })
      srDifficulty = Qt.binding(function() { return WADifficultyDOGE.mDisplayValue })
      srNetworkHashPS = Qt.binding(function() { return WANetworkHashPSDOGE.mDisplayValue })
      srExchangeRate = Qt.binding(function() { return WNExchangeRateDOGE.mDisplayValue })
      srBestBlockHash = Qt.binding(function() { return WABestBlockHashDOGE.mDisplayValue })
      srBalanceWithoutConf = Qt.binding(function() { return WABalanceWithoutConfDOGE.mDisplayValue })
    }
  }

  function fuActivate() { }
  function fuSetup() { }
}
