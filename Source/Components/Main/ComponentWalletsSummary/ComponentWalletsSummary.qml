import QtQuick 2.4
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  readonly property string srBalance: WABalance.mDisplayValue
  readonly property string srEncrypted: WAEncrypted.mDisplayValue
  readonly property string srTotalBlockCount: WNTotalBlockCount.mDisplayValue
  readonly property string srBlockCount: WABlockCount.mDisplayValue
  readonly property string srConnections: WAConnectionCount.mDisplayValue
  readonly property string srDifficulty: WADifficulty.mDisplayValue
  readonly property string srNetworkHashPS: WANetworkHashPS.mDisplayValue
  readonly property string srExchangeRate: WNExchangeRate.mDisplayValue
  readonly property string srBestBlockHash: WABestBlockHash.mDisplayValue
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
      source:  mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady.svg"), false)
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
      text: WABalance.mConnector
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
      onLoaded: { item.srText = Qt.binding(function() { return  (parseFloat(WABalanceWithoutConf.mDisplayValue) - parseFloat(srBalance) )}) }
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
    color: SStyleSheet.coComponentHorizontalHeaderColor
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
      text: "*   Source: " + WNTotalBlockCount.mSource + "\n**  Source: " + WNExchangeRate.mSource
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  function fuActivate() { }
  function fuSetup() { }
}
