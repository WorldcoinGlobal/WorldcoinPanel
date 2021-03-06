import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 8
  reWidthCm: 16

  property real reTextFieldWidth: 1
  property real reSubTotal

  Component {
    id: coHeaderDelegate
    AXCell {
      id: xhHeaderDelegate
      clip: true
      reLeftMargin: SStyleSheet.reHorizontalHeaderMargin
      reHeightCm: SStyleSheet.reHorizontalHeaderHeight
      anchors.left: parent.left
      anchors.right: parent.right
      color: SStyleSheet.coHorizontalHeaderColor
      coTextColor: SStyleSheet.coHorizontalHeaderTextColor
      reBorderWidth: SStyleSheet.reHorizontalHeaderBorderWidth
      reBottomBorderWidth: SStyleSheet.reHorizontalHeaderBorderWidth
      coBorderColor: SStyleSheet.coHorizontalHeaderBorderColor
      srText: styleData.value
      reTextRelativeSize: 0.7
      inHAlignment: Text.AlignLeft
      imIcon: {
        if(styleData.column === 0) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMImageTypeIcon.png"), false)
        if(styleData.column === 1) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMHashTypeIcon.png"), false)
        if(styleData.column === 2) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMCurrencyTypeIcon.png"), false)
        if(styleData.column === 3) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMNumberTypeIcon.png"), false)
        if(styleData.column === 4) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMDateTypeIcon.svg"), false)
        if(styleData.column === 5) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMStringTypeIcon.png"), false)
        return ""
      }
    }
  }
  Component {
    id: coRowDelegate
    Rectangle {
      color: SStyleSheet.coCellColor
      height: ACMeasures.fuToDots(SStyleSheet.reCellHeight)
    }
  }
  Component {
    id: coCellDelegate
    AXCell {
      id: xhCellDelegate
      clip: true
      reLeftMargin: SStyleSheet.reCellMargin
      anchors.fill: parent
      color: "transparent"
      coTextColor: SStyleSheet.coCellTextColor
      reBorderWidth: SStyleSheet.reCellBorderWidth
      reBottomBorderWidth: SStyleSheet.reCellBorderWidth
      coBorderColor: SStyleSheet.coCellBorderColor
      srText: styleData.value
      reTextRelativeSize: .65
      inHAlignment: {
        if(mLogModel.fHorizontalHeaderDataType(styleData.column) === CXDefinitions.EImageType) return Text.AlignHCenter
        return Text.AlignLeft
      }
      imIcon: {
        if(!model) return ""
        if((styleData.column === 0) && (styleData.value == qsTr("Sent"))) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMSendIcon.png"), false)
        if((styleData.column === 0) && (styleData.value == qsTr("Received"))) return mCXDefinitions.fCanonicalPath(fImageFile("Table_IMReceiveIcon.png"), false)

        return ""
      }
    }
  }
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
  Rectangle {
    id: rcParameters
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: rcTitle.bottom
    height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) * 2
    color: SStyleSheet.coComponentParameterBackgroundColor
    Button {
      id: btApply
      anchors.right: parent.right
      anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) + ACMeasures.fuToDots(SStyleSheet.reCommandBarTopMargin) / 2
      anchors.bottomMargin: ACMeasures.fuToDots(SStyleSheet.reCommandBarBottomMargin) / 2
      isDefault: true
      enabled: true
      width: ACMeasures.fuToDots(SStyleSheet.reCommandBarButtonWidth);
      height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) - ACMeasures.fuToDots(SStyleSheet.reCommandBarTopMargin + SStyleSheet.reCommandBarBottomMargin)
      style: ButtonStyle {
        background: Rectangle {
          border.width: ACMeasures.fuToDots(SStyleSheet.reCommandBarButtonBorderWidth)
          border.color: SStyleSheet.coCommandBarOkButtonBorderColor
          radius: ACMeasures.fuToDots(SStyleSheet.reCommandBarButtonRadius)
          color: control.pressed ? SStyleSheet.coCommandBarOkButtonPressedColor : SStyleSheet.coCommandBarOkButtonReleasedColor
        }
        label: Text {
          anchors.fill: parent
          color: SStyleSheet.coCommandBarOkButtonTextColor
          text: qsTr("Apply")
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.family: SStyleSheet.srFontFamily
          font.pixelSize: btApply.height * 0.85
        }
      }
      onClicked: {
        fuActivate()
        tfTransactionsDisplayed.fuSave()
      }
    }
  }

  FXTextField {
    id: tfTransactionsDisplayed
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: rcTitle.bottom
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
//      anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation * 4)
    boSaveSetting: true
    srSetting: "TransactionsDisplayed"
    echoMode:TextInput.Normal
    srLabelText: qsTr("Transactions Displayed: ")
    srFontFamily: SStyleSheet.srFontFamily
    srDefaultValue: "10"
    reTextFieldWidth: rcRoot.reTextFieldWidth
    coLabelTextColor: SStyleSheet.coComponentParameterTextColor
    stStyle: SXTextField {
      reHeightCm: SStyleSheet.reComponentRowHeight
      reRadius: SStyleSheet.reTextFieldRadius
      coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
      font.family: SStyleSheet.srFontFamily
      font.pixelSize: parent.height * 0.6
      textColor: SStyleSheet.coComponentInputTextColor
    }
  }
  ListModel { id: lmTransactions }
  ListModel { id: lmTransactionsBTC }
  ListModel { id: lmTransactionsLTC }
  ListModel { id: lmTransactionsDOGE }
  TableView {
    id: tvTransactions
    alternatingRowColors: true
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: rcParameters.bottom
    anchors.bottom: parent.bottom
    model: lmTransactions
    headerDelegate: coHeaderDelegate
    headerVisible: true
    itemDelegate: coCellDelegate
    rowDelegate: coRowDelegate

    TableViewColumn {
      role: "miTransactionType"
      title: "Type"
      width: ACMeasures.fuToDots(SStyleSheet.reTableImageWidth)
    }
    TableViewColumn {
      role: "miAddress"
      title: "Address"
      width: ACMeasures.fuToDots(SStyleSheet.reTableAddressWidth)
    }
    TableViewColumn {
      role: "miAmount"
      title: "Amount"
      width: ACMeasures.fuToDots(SStyleSheet.reTableCurrencyWidth)
    }
    TableViewColumn {
      role: "miConfirmations"
      title: "Confirmations"
      width: ACMeasures.fuToDots(SStyleSheet.reTableNumberWidth)
    }
    TableViewColumn {
      role: "miDate"
      title: "Date"
      width: ACMeasures.fuToDots(SStyleSheet.reTableDateWidth)
    }
    TableViewColumn {
      role: "miTxID"
      title: "Transaction ID"
      width: ACMeasures.fuToDots(SStyleSheet.reTableHashWidth)
    }
    Timer {
      id: tmRefreshTimer
      interval: 500;
      running: false;
      repeat: false
      onTriggered: { tvTransactions.positionViewAtRow(tvTransactions.rowCount - 1, ListView.End) }
    }
    onRowCountChanged: { tmRefreshTimer.running = true }
  }
  onMCurrentCoinChanged: {
    if(mCurrentCoin === "WDC") tvTransactions.model = lmTransactions
    if(mCurrentCoin === "BTC") tvTransactions.model = lmTransactionsBTC
    if(mCurrentCoin === "LTC") tvTransactions.model = lmTransactionsLTC
    if(mCurrentCoin === "DOGE") tvTransactions.model = lmTransactionsDOGE
  }

  Connections {
    target: rcRoot
    onSMessageArrivedJson: {
      if(lConnector === "WDC") lmTransactions.clear()
      if(lConnector === "BTC") lmTransactionsBTC.clear()
      if(lConnector === "LTC") lmTransactionsLTC.clear()
      if(lConnector === "DOGE") lmTransactionsDOGE.clear()
      for(var i = 0; i < lList.length; i++) {
        var vaTransaction = lList[i]
        var vaType = vaTransaction.category == "send" ? qsTr("Sent") : qsTr("Received")
        var vaAddress = vaTransaction.address
        var vaAmount = parseFloat(vaTransaction.amount).toFixed(8)
        var vaConfirmations = parseFloat(vaTransaction.confirmations).toFixed(0)
        var vaDate = new Date(0)
        vaDate.setUTCSeconds(vaTransaction.time);
        var vaTxID = vaTransaction.txid
        if(mCurrentCoin === "BTC") lmTransactionsBTC.append({"miTransactionType": vaType, "miAddress": vaAddress, "miAmount": vaAmount, "miConfirmations": vaConfirmations, "miDate": vaDate.toString(), "miTxID": vaTxID })
        if(mCurrentCoin === "LTC") lmTransactionsLTC.append({"miTransactionType": vaType, "miAddress": vaAddress, "miAmount": vaAmount, "miConfirmations": vaConfirmations, "miDate": vaDate.toString(), "miTxID": vaTxID })
        if(mCurrentCoin === "DOGE") lmTransactionsDOGE.append({"miTransactionType": vaType, "miAddress": vaAddress, "miAmount": vaAmount, "miConfirmations": vaConfirmations, "miDate": vaDate.toString(), "miTxID": vaTxID })
        if(mCurrentCoin === "WDC") lmTransactions.append({"miTransactionType": vaType, "miAddress": vaAddress, "miAmount": vaAmount, "miConfirmations": vaConfirmations, "miDate": vaDate.toString(), "miTxID": vaTxID })
      }
    }
  }
  Connections {
    target: ComponentWalletsSummary
    onSrBalanceChanged: {
      fuActivate()
    }
  }
  function fuActivate() { fRawCallRequested(mCurrentCoin, "listtransactions \"*\" " + tfTransactionsDisplayed.srValue, 0) }
  function fuSetup() { tfTransactionsDisplayed.fuLoad() }
}
