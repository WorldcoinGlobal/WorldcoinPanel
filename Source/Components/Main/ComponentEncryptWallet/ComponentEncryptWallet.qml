import QtQuick 2.4
//import QtQuick.Controls 1.3
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 5.5
  reWidthCm: 12

  property real reColumnWidth: 7

  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  AXFrame {
    id: rcTitle
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
  AXFrame {
    id: rcEncryption
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: rcTitle.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: ComponentWalletsSummary.srEncrypted === "True" ? qsTr("Change Passphrase") : qsTr("New Passphrase")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  FXTextField {
    id: tfOldPassphrase
    clip: true
    anchors.top: rcEncryption.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    boSaveSetting: false
    echoMode:TextInput.Password
    reHeightCm: ComponentWalletsSummary.srEncrypted === "True" ? SStyleSheet.reComponentRowHeight : 0
    srLabelText:  qsTr("Old Passphrase:")
    srFontFamily: SStyleSheet.srFontFamily
    srDefaultValue: ""
    stStyle: SXTextField {
      reHeightCm: parent.height
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfOldPassphrase.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfPassphrase
    anchors.top: tfOldPassphrase.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    boSaveSetting: false
    echoMode:TextInput.Password
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: ComponentWalletsSummary.srEncrypted === "True" ? qsTr("New Passphrase:") : qsTr("Passphrase:")
    srFontFamily: SStyleSheet.srFontFamily
    srDefaultValue: ""
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfPassphrase.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfRepeatPassphrase
    anchors.top: tfPassphrase.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    boSaveSetting: false
    echoMode:TextInput.Password
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Repeat:       ")
    srFontFamily: SStyleSheet.srFontFamily
    srDefaultValue: ""
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfRepeatPassphrase.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  Rectangle {
    id: rcSpace
    anchors.top: tfRepeatPassphrase.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
    color: "Transparent"
  }
  AXFrame {
    id: frWarning
    anchors.bottom: rcRoot.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation) / 2
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation) / 2
    height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight)
    color: SStyleSheet.coComponentWarningBackgroundColor
    reHeightCm: SStyleSheet.reComponentRowHeight
    radius: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) / 2
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.left: parent.left
      height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight / 2)
      color: SStyleSheet.coComponentWarningBackgroundColor
    }
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: {
        if(mStatus) return qsTr("After encryption WBC will close!")
        if(ComponentWalletsSummary.srEncrypted === "True") return qsTr("Wallet is encrypted!")
        if(tfPassphrase.srValue == "") return qsTr("Password can't be empty!")
        return qsTr("Passwords don't match!")
      }
      color: SStyleSheet.coComponentWarningTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  Rectangle {
    anchors.bottom: frWarning.bottom
    x: 0
    width: rcRoot.width
    height: 1
    color: SStyleSheet.coComponentWarningBackgroundColor
  }

/*  Rectangle {
    id: rcCover
    anchors.top: rcEncryption.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    color: "Black"
    opacity: ComponentWalletsSummary.srEncrypted === "True" ? 0.3 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 1000
        easing.type: Easing.Linear
      }
    }
  }*/
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
  Connections {
    target: rcRoot
    onSMessageArrivedJson: {
      rcDisabled.opacity = 0
      sComponentProcessing(0)
      fQuitApplication()
    }
  }
  Component.onCompleted: {
    mStatus = Qt.binding(function() {
                if((ComponentWalletsSummary.srEncrypted === "False") && (tfPassphrase.srValue != "") && (tfPassphrase.srValue === tfRepeatPassphrase.srValue)) return true
                if((ComponentWalletsSummary.srEncrypted === "True") && (tfOldPassphrase.srValue != "") && (tfPassphrase.srValue != "") && (tfPassphrase.srValue === tfRepeatPassphrase.srValue)) return true
                return false
              })
  }

  function fuAccept() {
    if(ComponentWalletsSummary.srEncrypted === "False")
      fRawCallRequested(mCurrentCoin, "encryptwallet " + tfPassphrase.srValue, 0, CXDefinitions.ELogPanel)
    else
      fRawCallRequested(mCurrentCoin, "walletpassphrasechange " + tfOldPassphrase.srValue  + " " + tfPassphrase.srValue, 0, CXDefinitions.ELogPanel)

    sComponentProcessing(1)
    rcDisabled.opacity = 0.3
    tfPassphrase.srValue = ""
    tfRepeatPassphrase.srValue = ""
  }
  function fuActivate() {

  }
  function fuSetup() { }
}
