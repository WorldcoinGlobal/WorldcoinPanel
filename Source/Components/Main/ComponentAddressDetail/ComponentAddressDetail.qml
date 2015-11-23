import QtQuick 2.4
import QtQuick.Controls 1.3
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 8
  reWidthCm: 13

  property real reColumnWidth: 8.5
  property string srCoin: "WDC"
  property real vaAddressSubtotal
  property real vaChangeSubtotal
  property bool boUseReceiveByAddress // listaddressgrouping doesn't work for new wallets
  property real reTotal: cComponentWalletsSummary.srBalance

  Component {
    id: coAddressHeader
    AXFrame {     
     id: frRoot
     color: SStyleSheet.coComponentHorizontalHeaderColor
     reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
     width: parent.width
     Text {
       id: txText
       anchors.fill: parent
       horizontalAlignment: "AlignHCenter"
       verticalAlignment: "AlignVCenter"
       text: frRoot.ListView.view.srTitle
       color: SStyleSheet.coComponentHorizontalHeaderTextColor
       font.bold: true
       font.italic: false
       font.family: SStyleSheet.srComponentFont
      }
    }
  }
  Component {
    id: coSubtotal
    AXFrame {
      id: frRoot
      anchors.right: parent.right
      color: SStyleSheet.coComponentDetailSubtotalBackgroundColor
      reHeightCm: SStyleSheet.reComponentRowHeight
      reWidthCm: reColumnWidth
      radius: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) / 2
      Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        width: scView.viewport.width
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
        text: qsTr("Subtotal: ") + frRoot.ListView.view.reSubtotal
        color: SStyleSheet.coComponentDetailSubtotalTextColor
        font.bold: false
        font.italic: true
        font.family: SStyleSheet.srComponentFont
      }
    }
  }
  Component {
    id: coAddressElement
    AXFrame {
      reHeightCm: miAccount.length > 0 ? SStyleSheet.reComponentRowHeight * 3 : SStyleSheet.reComponentRowHeight * 2
      width: parent.width
      Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
        color: SStyleSheet.coComponentVerticalHeaderColor
      }
      Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight / 2)
        width: frAddress.width
        color: SStyleSheet.coComponentVerticalHeaderColor
      }
      Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: SStyleSheet.coComponentVerticalHeaderColor
      }
      AXFrame {
        id: frAddress
        color: SStyleSheet.coComponentVerticalHeaderColor
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: reColumnWidth
        radius: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) / 2
        AXTextEdit {
          anchors.fill: parent
          readOnly: true
          selectByMouse: true
          anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          horizontalAlignment: "AlignLeft"
          verticalAlignment: "AlignVCenter"
          text: miAddress
          color: SStyleSheet.coComponentVerticalHeaderTextColor
          font.bold: false
          font.italic: false
          font.family: SStyleSheet.srComponentFont
        }
      }
      AXFrame {
        id: frAmount
        anchors.top: frAddress.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: SStyleSheet.coComponentDetailBackgroundColor
        reHeightCm: SStyleSheet.reComponentRowHeight
        Text {
          anchors.fill: parent
          anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          horizontalAlignment: "AlignRight"
          verticalAlignment: "AlignVCenter"
          text: "Amount: " + miAmount
          color: SStyleSheet.coComponentDetailTextColor
          font.bold: false
          font.italic: true
          font.family: SStyleSheet.srComponentFont
        }
      }
      AXFrame { 
        id: frAccount        
        anchors.top: frAmount.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: SStyleSheet.coComponentDetailBackgroundColor
        reHeightCm: miAccount.length > 0 ? SStyleSheet.reComponentRowHeight : 0
        Text {
          anchors.fill: parent
          anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          horizontalAlignment: "AlignRight"
          verticalAlignment: "AlignVCenter"
          text: miAccount.length > 0 ?  "Account: " + miAccount : ""
          color: SStyleSheet.coComponentDetailTextColor
          font.bold: false
          font.italic: true
          font.family: SStyleSheet.srComponentFont
        }
      }
    }
  }
  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  ScrollView {    
    id: scView
    anchors.fill: rcRoot
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    Rectangle {
      id: rcView
      height: lvAddress.height + rcSpace.height + lvChangeAddress.height +rcSpace2.height + frTotal.height
      width: rcRoot.width
      color: "transparent"
      ListView {
        property string srTitle: qsTr("Standard Addresses")
        property real reSubtotal: vaAddressSubtotal.toFixed(8)

        id: lvAddress
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        clip: true
        height: headerItem.height + count * ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) * 3 + footerItem.height
        header: coAddressHeader
        footer: coSubtotal
        model: lmAddressModel
        delegate: coAddressElement
      }
      Rectangle {
        id: rcSpace
        anchors.top: lvAddress.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
        color: "Transparent"
      }
      ListView {
        property string srTitle: qsTr("Change Addresses")
        property real reSubtotal: vaChangeSubtotal.toFixed(8)

        id: lvChangeAddress
        anchors.top: rcSpace.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        clip: true
        height: headerItem.height + count * ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) * 2 + footerItem.height
        header: coAddressHeader
        footer: coSubtotal
        model: lmChangeAddressModel
        delegate: coAddressElement
      }
      Rectangle {
        id: rcSpace2
        anchors.top: lvChangeAddress.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
        color: "Transparent"
      }

      AXFrame {
        id: frTotal
        anchors.top: rcSpace2.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: (scView.width - ACMeasures.fuToDots(reColumnWidth)) / 2
        anchors.leftMargin: (scView.width - ACMeasures.fuToDots(reColumnWidth)) / 2
        height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight)
        color: SStyleSheet.coComponentDetailTotalBackgroundColor
        reHeightCm: SStyleSheet.reComponentRowHeight
        radius: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) / 2
        Rectangle {
          anchors.top: parent.top
          x: -1 * (scView.width - ACMeasures.fuToDots(reColumnWidth)) / 2
          width: scView.viewport.width
          height: 1
          color: SStyleSheet.coComponentDetailTotalBackgroundColor
        }
        Rectangle {
          anchors.top: parent.top
          anchors.right: parent.right
          anchors.left: parent.left
          height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight / 2)
          color: SStyleSheet.coComponentDetailTotalBackgroundColor
        }
        Text {
          anchors.fill: parent
          horizontalAlignment: "AlignHCenter"
          verticalAlignment: "AlignVCenter"
          text: qsTr("Total: ") + reTotal
          color: SStyleSheet.coComponentDetailTotalTextColor
          font.bold: true
          font.italic: true
          font.family: SStyleSheet.srComponentFont
        }
      }
    }
  }
  ListModel { id: lmAddressModel }
  ListModel { id: lmChangeAddressModel }

  onReTotalChanged: { fuActivate() }
  function fuActivate() {
    boUseReceiveByAddress = 0
    fRawCallRequested(srCoin, "listaddressgroupings", 0)
  }
  function fuSetup() { }
  Connections {
    target: rcRoot
    onSMessageArrivedJson: {
      if(boUseReceiveByAddress) {
        var vaAddress = lList[0]['address']
        lmAddressModel.append({"miAddress": vaAddress, "miAmount": 0, "miAccount": ""})
        boUseReceiveByAddress = 0
      }
      else {
        lmAddressModel.clear()
        lmChangeAddressModel.clear()
        vaAddressSubtotal = 0
        vaChangeSubtotal = 0
        if(lList.length === 0) {
          boUseReceiveByAddress = 1
          fRawCallRequested(srCoin, "listreceivedbyaddress 1 1", 0)
        }
        else {
          for(var h = 0; h < lList.length; h++) {
            for(var i = 0; i < lList[h].length; i++) {
              var vaList = lList[h][i]
              var vaAddress = vaList[0]
              var vaAmount = vaList[1]
              if(vaList.length === 3) {
                var vaAccount = vaList[2]
                if(vaAccount === "") vaAccount = qsTr("-- Default")
                lmAddressModel.append({"miAddress": vaAddress, "miAmount": vaAmount, "miAccount": vaAccount})
                vaAddressSubtotal += parseFloat(vaAmount)
              }
              else {
                if(vaAmount > 0) lmChangeAddressModel.append({"miAddress": vaAddress, "miAmount": vaAmount, "miAccount": "" })
                vaChangeSubtotal += parseFloat(vaAmount)
              }
            }
          }
        }
      }
    }
  }
}
