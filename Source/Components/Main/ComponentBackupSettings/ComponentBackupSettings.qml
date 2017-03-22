import QtQuick 2.4
import QtQuick.Controls 1.3
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 5.5
  reWidthCm: 8

  readonly property string srBaseName: tfBaseName.srValue
  readonly property string srBackupDirectory: tfBackupDirectory.srValue
  readonly property bool boEncryptionBackup: cbEncryptionBackup.boValue
  readonly property bool boBackupOnSending: cbSendingBackup.boValue
  readonly property bool boBackupOnUpdate: cbUpdateBackup.boValue

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
      coTextColor: SStyleSheet.coCheckBoxTextColor
      srFontFamily: SStyleSheet.srFontFamily
    }
  }
  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  AXFrame {
    id: rcPolicyTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Backup Policy")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  FXCheckBox {
    id: cbEncryptionBackup
    visible: false
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.top: rcPolicyTitle.bottom
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentRowHeight
    style: coCheckBox
    text: qsTr("Backup when encryption is performed")
    srSetting: "BackupOnEncryption"
    srDefaultValue: "1"

  }
  FXCheckBox {
    id: cbSendingBackup
    anchors.top: rcPolicyTitle.bottom //cbEncryptionBackup.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentRowHeight
    style: coCheckBox
    text: qsTr("Backup when sending coins")
    srSetting: "BackupOnSending"
    srDefaultValue: "1"
  }
  FXCheckBox {
    id: cbUpdateBackup
    anchors.top: cbSendingBackup.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentRowHeight
    style: coCheckBox
    text: qsTr("Backup before update")
    srSetting: "BackupOnUpdate"
    srDefaultValue: "1"
  }

  AXFrame {
    id: rcNameTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: cbUpdateBackup.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Name Policy")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  FXTextField {
    id: tfBaseName
    anchors.top: rcNameTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Base name:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_.@\\-]+$/ }
    srSetting: "BaseName"
    srDefaultValue: qsTr("Wallet")
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfBaseName.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  FXTextField {
    id: tfBackupDirectory
    anchors.top: tfBaseName.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    srLabelText: qsTr("Directory:")
    srFontFamily: SStyleSheet.srFontFamily
    vlValidator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_.@\\-]+$/ }
    srSetting: "BackupDirectory"
    srDefaultValue: mCXDefinitions.fBackupDir()
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: tfBaseName.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  function fuAccept() {
    tfBaseName.fuSave()
    tfBackupDirectory.fuSave()
    cbSendingBackup.fuSave()
    cbEncryptionBackup.fuSave()
    cbUpdateBackup.fuSave()
    sClose()
  }
  function fuActivate() {
    tfBaseName.fuLoad()
    tfBackupDirectory.fuLoad()
    cbSendingBackup.fuLoad()
    cbEncryptionBackup.fuLoad()
    cbUpdateBackup.fuLoad()
  }
  function fuSetup() { }
}
