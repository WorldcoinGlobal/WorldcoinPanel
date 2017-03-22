import QtQuick 2.4
import QtQuick.Controls 1.3
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 6
  reWidthCm: 12

  property real reColumnWidth: 7
  property string srAmountToTransfer

  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  AXFrame {
    id: rcSendTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Image {
      id: imCrypto
      source: {
        if(mCurrentCoin === "BTC") return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_BTC.png"), false);
        if(mCurrentCoin === "LTC") return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_LTC.png"), false);
        if(mCurrentCoin === "DOGE") return mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_DOGE.png"), false);
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
  FXTextField {
    id: tfAddress
    property alias reRegExp: vlRegValidator.regExp
    anchors.top: rcSendTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    boSaveSetting: false
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Address:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: vlRegValidator
    srSetting: "TargetAddress"
    srDefaultValue: ""
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfAddress.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
    RegExpValidator {
      id: vlRegValidator
      regExp: /^W{1}[1-9A-HJ-NP-Za-km-z]{33}$/
    }
  }
  FXTextField {
    id: tfAmount
    anchors.top: tfAddress.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    boSaveSetting: false
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Amount:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /\d+(\.\d{1,8})?/ }
    srSetting: "TransferAmount"
    srDefaultValue: "0"
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfAddress.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  AXFrame {
    id: frBalance
    anchors.top: tfAmount.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentRowHeight
    reWidthCm: reColumnWidth
    radius: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) / 2
    color: SStyleSheet.coComponentDetailSubtotalBackgroundColor
    Rectangle {
      anchors.top: parent.top
      anchors.right: parent.right
      width: rcRoot.width
      height: 1
      color: SStyleSheet.coComponentDetailSubtotalBackgroundColor
    }
    Rectangle {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.left: parent.left
      height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight / 2)
      color: SStyleSheet.coComponentDetailSubtotalBackgroundColor
    }
    Rectangle {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      width: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
      color: SStyleSheet.coComponentDetailSubtotalBackgroundColor
    }
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Balance: " + ComponentWalletsSummary.srBalance)
      color: SStyleSheet.coComponentDetailSubtotalTextColor
      font.bold: false
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
    function fuClicked() { tfAmount.srValue = ComponentWalletsSummary.srBalance }
  }
  AXFrame {
    property alias srText: txText.text

    id: frTxID
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: frBalance.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      id: txText
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Last Tx:")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  AXFrame {
    id: rcDecryptTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: frTxID.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Unlock Wallet")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  FXTextField {
    id: tfPassphrase
    enabled: ComponentWalletsSummary.srEncrypted === "True" ? 1 : 0
    anchors.top: rcDecryptTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    boSaveSetting: false
    echoMode:TextInput.Password
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Passphrase:")
    srFontFamily: SStyleSheet.srFontFamily
//    vlValidator: RegExpValidator { regExp: /\d+(\.\d{1,8})?/ }
    srSetting: "Passphrase"
    srDefaultValue: ""
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfAddress.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  Rectangle {
    id: rcCover
    anchors.top: rcDecryptTitle.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    color: "Black"
    opacity: ComponentWalletsSummary.srEncrypted === "True" ? 0 : 0.3
    Behavior on opacity {
      NumberAnimation {
        duration: 1000
        easing.type: Easing.Linear
      }
    }
  }
  Rectangle {
    id: rcDisabled
    anchors.fill: parent
    color: "Black"
    opacity: 0
    Behavior on opacity {
      NumberAnimation {
        duration: 300
        easing.type: Easing.Linear
      }
    }
  }
  FXToolTip {
    id: ttBalance
    width: ACMeasures.fuToDots(6)
    target: frBalance
    text: qsTr("Click here in order to select maximum amount of available funds.")
    backgroundColor: SStyleSheet.coToolTipBackgroundColor
    textColor: SStyleSheet.coToolTipTextColor
    radius: ACMeasures.fuToDots(SStyleSheet.reToolTipRadius)
    font: SStyleSheet.srFontFamily
  }

  Timer {
    id: tmSend
    interval: 400;
    repeat: false
    onTriggered: fRawCallRequested(mCurrentCoin, "sendtoaddress " + tfAddress.srValue + " " + srAmountToTransfer, 1)
  }
  onMCurrentCoinChanged: {
    if(mCurrentCoin === "WDC") tfAddress.reRegExp = /^W{1}[1-9A-HJ-NP-Za-km-z]{33}$/
    if(mCurrentCoin === "BTC") tfAddress.reRegExp = /^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$/
    if(mCurrentCoin === "LTC") tfAddress.reRegExp = /^L[a-km-zA-HJ-NP-Z1-9]{26,33}$/
    if(mCurrentCoin === "DOGE") tfAddress.reRegExp = /^D{1}[5-9A-HJ-NP-U]{1}[1-9A-HJ-NP-Za-km-z]{32}$/
  }

  Connections {
    target: rcRoot
    onSMessageArrived: {
      rcDisabled.opacity = 0
      if(lMessageType == CXDefinitions.ESuccessMessage && lConnector == mCurrentCoin)  {
        frTxID.srText = qsTr("Last Tx:" + lMessage)
        tfAddress.srValue = tfAddress.srDefaultValue
        tfAmount.srValue = tfAmount.srDefaultValue
        if(ComponentBackupSettings.boBackupOnSending) ComponentBackupWallet.fuAccept()        
      }
      if(lConnector == mCurrentCoin) tfAmount.srValue = "0"
      sComponentProcessing(0)
    }
  }
  function fuAccept() {
    srAmountToTransfer = tfAmount.srValue
    if(ComponentWalletsSummary.srEncrypted === "True") fRawCallRequested(mCurrentCoin, "walletpassphrase " + tfPassphrase.srValue + " " + " 2", 0, CXDefinitions.ELogNone)
    sComponentProcessing(1)
    tmSend.running = true
    rcDisabled.opacity = 0.3    
  }
  function fuActivate() {
    tfAmount.fuLoad()
    tfAddress.fuLoad()
    tfPassphrase.fuLoad()
  }
  function fuSetup() { }
}
