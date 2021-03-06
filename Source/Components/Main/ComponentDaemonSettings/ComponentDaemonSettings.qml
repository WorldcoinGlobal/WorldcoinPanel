import QtQuick 2.4
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0

AXComponent {
 // property real reColumnWidth: 4.5

  id: rcRoot
  reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight * 4.7 + SStyleSheet.reComponentHorizontalHeaderRowHeight * 12
  reWidthCm: 11

  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  Rectangle {
    id: rcDaemonSettingsInfo
    objectName: "DaemonSettingsInfo"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) * 2
    color: SStyleSheet.coComponentInformationBackgroundColor
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("If you click 'Apply', WBC will close!\nChange these parameters only if you know exactly what you are doing!")
      color: SStyleSheet.coComponentDetailTotalTextColor
      font.bold: true
  //    wrapMode: Text.WordWrap
      font.pixelSize: parent.height * 0.3
      font.family: SStyleSheet.srComponentFont
    }
  }
  AXFrame {
    id: rcValueTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: rcDaemonSettingsInfo.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    property alias imImage: imCrypto.source
    property alias srText: txText.text
    Image {
      id: imCrypto
      source:  mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady.png"), false)
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
      text: WABalance.mConnector
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  Component {
    id: coCheckBox
    SXCheckBox {
      reHeightCm: SStyleSheet.reCheckBoxHeight
      reWidthCm: SStyleSheet.reCheckBoxWidth
      reCheckBoxRadius: SStyleSheet.reCheckBoxRadius
      coActiveBorderFocus: SStyleSheet.coCheckBoxActiveBorderFocus
      coInactiveBorderFocus: SStyleSheet.coCheckBoxInactiveBorderFocus
      coBackgroundColor: SStyleSheet.coCheckBoxBackgroundColor
      coActiveColor: SStyleSheet.coCheckBoxActiveColor
      coInactiveColor: SStyleSheet.coCheckBoxInactiveColor
      coTextColor: SStyleSheet.coCheckBoxTextColor
      srFontFamily: SStyleSheet.srFontFamily
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
  FXCheckBox {
    id: cbDaemonEnabled
    enabled: false
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: rcValueTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    style: coCheckBox
    srSetting: "Enabled"
    srDefaultValue: "1"
    srConnector: "WDC"
    boUseDaemonConf: true
    text: checked ? qsTr("Enabled") : qsTr("Disabled")
  }
  FXTextField {
    id: tfBinaryName
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: cbDaemonEnabled.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Executable file name:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_.@\\-]+$/ }
    srSetting: "BinaryName"
    srDefaultValue: "WorldcoinDaemon"
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfBinaryName.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfDataDirectory
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: tfBinaryName.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Data directory:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_.@\\-]+$/ }
    srSetting: "DataDirectory"
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfPort
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: tfDataDirectory.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Node Port:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[0-9]+$/ }
    srSetting: "Port"
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfRpcPort
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: tfPort.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("RPC Port:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[0-9]+$/ }
    srSetting: "RpcPort"
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfUser
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: tfRpcPort.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("User Name:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_.@\\-]+$/ }
    srSetting: "User"
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfUser.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfPassword
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: tfUser.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Rpc Password:   ")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_$.@\\-]+$/ }
    srSetting: "Password"
    echoMode:TextInput.Password
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfRepeatPassword
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: tfPassword.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Repeat Password:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_$.@\\-]+$/ }
    srSetting: "Repeat Password"
    boSaveSetting: false
    echoMode:TextInput.Password
    boUseDaemonConf: true
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
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
  onSCurrentCoinChanged: {
    if(mCurrentCoin === "WDC") {
      rcValueTitle.imImage =  mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady.png"), false)
      cbDaemonEnabled.enabled = false
    }
    else {
      cbDaemonEnabled.enabled = true
    }
    if(mCurrentCoin === "BTC") rcValueTitle.imImage =  mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_BTC.png"), false)
    if(mCurrentCoin === "LTC") rcValueTitle.imImage =  mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_LTC.png"), false)
    if(mCurrentCoin === "DOGE") rcValueTitle.imImage =  mCXDefinitions.fCanonicalPath(fImageFile("InfoBar_IMDaemonReady_DOGE.png"), false)
    rcValueTitle.srText = mCurrentCoin
    cbDaemonEnabled.srConnector = mCurrentCoin
    tfBinaryName.srConnector = mCurrentCoin
    tfDataDirectory.srConnector = mCurrentCoin
    tfPort.srConnector = mCurrentCoin
    tfRpcPort.srConnector = mCurrentCoin
    tfUser.srConnector = mCurrentCoin
    tfPassword.srConnector = mCurrentCoin
    tfRepeatPassword.srConnector = mCurrentCoin
    fuActivate()
  }

  Component.onCompleted: {
    mStatus = Qt.binding(function() {
                if((tfPassword.srValue != "") && (tfPassword.srValue === tfRepeatPassword.srValue)) return true
                if((tfPassword.srValue != "") && (tfRepeatPassword.srValue == "")) return true
                return false
              })
  }
  function fuAccept() {
    sComponentProcessing(1)
    rcDisabled.opacity = 0.3

    cbDaemonEnabled.fuSave()
    tfBinaryName.fuSave()
    tfDataDirectory.fuSave()
    tfPort.fuSave()
    tfRpcPort.fuSave()
    tfUser.fuSave()
    if(tfRepeatPassword.srValue != "")  tfPassword.fuSave()
    tfRepeatPassword.srValue = ""
    sClose()
    fQuitApplication()
  }
  function fuActivate() {
    cbDaemonEnabled.fuLoad()
    tfBinaryName.fuLoad()
    tfDataDirectory.fuLoad()
    tfPort.fuLoad()
    tfRpcPort.fuLoad()
    tfUser.fuLoad()
    tfPassword.fuLoad()
  }
  function fuSetup() { }
}
