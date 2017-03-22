import QtQuick 2.4
import QtQuick.Controls 1.3
import WFDefinitions.Lib 1.0
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import "../../../WFUserInterface/AXLib"

AXComponent {
  id: rcRoot
  reHeightCm: 8
  reWidthCm: 17
  focus: true
  coDefaultFocus: tfCommand

  property string srLastCommand
  property real reColumnWidth: 3
  property real reViewHeight
  property real reViewWidth

  ListModel { id: lmConsole }
  ListModel { id: lmConsoleBTC }
  ListModel { id: lmConsoleLTC }
  ListModel { id: lmConsoleDOGE }
  AXFrame {
    id: rcTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    property alias imImage: imCrypto.source
    property alias srText: txText.text
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
      id: txText
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
  ScrollView {
    id: scView
    anchors.top: rcTitle.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: frFrame.top

    Rectangle {
      id: rcView
      color: "transparent"
      ListView {
        id: taConsole
        model: lmConsole
        anchors.fill: parent
        delegate: Row {
          id: rwDelegate
          spacing: 10
          height: xtData.paintedHeight > xtMetaData.paintedHeight ? xtData.paintedHeight : xtMetaData.paintedHeight
          AXTextEdit {
            id: xtMetaData
            readOnly: true
            selectByMouse: true
            textFormat: TextEdit.PlainText
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            reWidthCm: reColumnWidth
            color: "SteelBlue"
            text: vaMetadata
            font.family: SStyleSheet.srComponentFont
            font.italic: true
          }
          Rectangle {
            id: rcSep
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: SStyleSheet.coComponentTopBorderColor
          }
          AXTextEdit {
            id: xtData
            readOnly: true
            selectByMouse: true
            textFormat: TextEdit.PlainText
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "Black"
            text: vaData
            font.family: SStyleSheet.srComponentFont
            font.bold: vaBold
          }
          onWidthChanged: { xtData.width = xtData.paintedWidth }
          Component.onCompleted: {
            reViewHeight = reViewHeight + height
            if(reViewWidth < width) reViewWidth = width
          }
        }
        onCountChanged: {
          rcView.height = reViewHeight
          if(reViewHeight > scView.height) scView.flickableItem.contentY = reViewHeight - scView.height
          rcView.width = reViewWidth
        }
        add: Transition {
          NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
          NumberAnimation { property: "scale"; easing.type: Easing.OutQuad; from: 0; to: 1.0; duration: 750 }
        }
      }
    }
  }
  AXFrame {
    id: frFrame
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    reHeightCm: 0.5
    focus: true
    TextField {
      id: tfCommand
      anchors.fill: parent
      focus: true
      style: SXTextField {
        reHeightCm: SStyleSheet.reComponentRowHeight
        coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
        font.family: SStyleSheet.srFontFamily
        font.pixelSize: tfCommand.height * 0.6
        textColor: SStyleSheet.coComponentInputTextColor
      }
      placeholderText: qsTr("Enter command")
      onAccepted: {
        fRawCallRequested(mCurrentCoin, tfCommand.text)
        srLastCommand = tfCommand.text
        tfCommand.text = ""
      }
      Keys.onPressed: {
        if (event.key == Qt.Key_Up) {
           tfCommand.text = srLastCommand
           event.accepted = true;
        }
      }
    }
  }
  Connections {
    target: rcRoot
    onSMessageArrived: {
      var vaBold = false;
      if(lMessageType == CXDefinitions.EBugMessage) vaBold = true;
      if(lMessageType == CXDefinitions.EErrorMessage) vaBold = true;
      if(lMessageType == CXDefinitions.EWarningMessage) vaBold = true;
      if(lMessageType == CXDefinitions.ESuccessMessage) vaBold = false;
      if(lConnector === "WDC") lmConsole.append({"vaMetadata" : qsTr("Request[") + lRequestID + "]\n   --  " + mCXDefinitions.fCurrentDate() + "  --", "vaData" : "   --  " + lInput + "  --\n" + lMessage + "\n", "vaBold" : vaBold})
      if(lConnector === "BTC") lmConsoleBTC.append({"vaMetadata" : qsTr("Request[") + lRequestID + "]\n   --  " + mCXDefinitions.fCurrentDate() + "  --", "vaData" : "   --  " + lInput + "  --\n" + lMessage + "\n", "vaBold" : vaBold})
      if(lConnector === "LTC") lmConsoleLTC.append({"vaMetadata" : qsTr("Request[") + lRequestID + "]\n   --  " + mCXDefinitions.fCurrentDate() + "  --", "vaData" : "   --  " + lInput + "  --\n" + lMessage + "\n", "vaBold" : vaBold})
      if(lConnector === "DOGE") lmConsoleDOGE.append({"vaMetadata" : qsTr("Request[") + lRequestID + "]\n   --  " + mCXDefinitions.fCurrentDate() + "  --", "vaData" : "   --  " + lInput + "  --\n" + lMessage + "\n", "vaBold" : vaBold})
    }
  }
  onSCurrentCoinChanged: {
    if(srCurrentCoin === "WDC") taConsole.model = lmConsole
    if(srCurrentCoin === "BTC") taConsole.model = lmConsoleBTC
    if(srCurrentCoin === "LTC") taConsole.model = lmConsoleLTC
    if(srCurrentCoin === "DOGE") taConsole.model = lmConsoleDOGE
  }

  function fuActivate() { }
  function fuSetup() {

  }
}
