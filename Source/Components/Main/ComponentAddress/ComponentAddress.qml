import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 4
  reWidthCm: 12

  readonly property string srCoin: "WDC"
  readonly property string srNewAddress: teAddressCreated.text
  property real reColumnWidth: 3
  property real reComboWidth: 5

  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  AXFrame {
    id: frValueTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
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
  AXFrame {
    id: frCreateTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: frValueTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Create Address")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  AXFrame {
    id: frAccount
    clip: true
    color: SStyleSheet.coComponentVerticalHeaderColor
    anchors.top: frCreateTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    reWidthCm: reColumnWidth
    reHeightCm: SStyleSheet.reComponentRowHeight
    radius: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) / 2
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: parent.height
      color: parent.color
    }
    Text {
      id: coAccountText
      anchors.fill: parent
      anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Account:")
      color: SStyleSheet.coComponentVerticalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  ComboBox {
    id: cbAccount
    currentIndex: 0
    editable: true
    anchors.top: frCreateTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: frAccount.right
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
    width: ACMeasures.fuToDots(reComboWidth)
    height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
    textRole: "miAccount"
    validator: RegExpValidator { regExp: /^[a-zA-Z0-9áéíóúÑñ_.-]+$/ }
    style: ComboBoxStyle {
      font.family: SStyleSheet.srComponentFont
      font.pixelSize: cbAccount.height * 0.7
    }
    model: lmAccountModel
  }
  ListModel { id: lmAccountModel }
  AXFrame {
    id: frAddressCreated
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: frAccount.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      id: txAddressCreated
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
      width: ACMeasures.fuToDots(reColumnWidth)
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Address:")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
    AXTextEdit {
      id: teAddressCreated
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: txAddressCreated.right
      anchors.right: parent.right
      readOnly: true
      selectByMouse: true
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      color: SStyleSheet.coComponentVerticalHeaderTextColor
      font.bold: false
      font.italic: false
      font.family: SStyleSheet.srComponentFont
    }
  }
  Connections {
    target: rcRoot
    onSMessageArrivedJson: {
      if(lList[0].indexOf("|") > -1 ) { // Not an object therefore the new address
        lmAccountModel.clear()
        for(var h = 0; h < lList.length; h++) {
           var vaAccountList = lList[h]
           var vaAccount = vaAccountList.split("|")
           if(vaAccount.length > 0) lmAccountModel.append({"miAccount": vaAccount[0]})
        }
      }
      else {
        var vaNewAccount = lList[0]
        teAddressCreated.text = vaNewAccount
      }
      sComponentProcessing(0)
    }
  }
  function fuAccept() {
    sComponentProcessing(1)
    fRawCallRequested(srCoin, "getnewaddress " + cbAccount.editText, 0)
  }
  function fuActivate() {
    teAddressCreated.text = ""
    fRawCallRequested(srCoin, "listaccounts", 0)
  }
  function fuSetup() { }
}
