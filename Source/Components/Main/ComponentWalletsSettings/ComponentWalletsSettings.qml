import QtQuick 2.4
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

AXComponent {
 // property real reColumnWidth: 4.5

  id: rcRoot
  reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight * 3 + SStyleSheet.reComponentHorizontalHeaderRowHeight * 8
  reWidthCm: 9

  Rectangle {
    anchors.fill: parent
    color: SStyleSheet.coComponentDetailBackgroundColor
  }
  AXFrame {
    id: rcUITitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("User Interface")
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
  FXCheckBox {
    id: cbMinimizeToTray
    enabled: true
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: rcUITitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    style: coCheckBox
    srSetting: "MinimizeToTray"
    srDefaultValue: "0"
    text: qsTr("Minimize to tray only")
  }
  FXCheckBox {
    id: cbMinimizeOnClose
    enabled: true
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: cbMinimizeToTray.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    style: coCheckBox
    srSetting: "MinimizeOnClose"
    srDefaultValue: "1"
    text: qsTr("Minimize to tray when close")
  }
  AXFrame {
    id: rcUpdateTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: cbMinimizeOnClose.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Updater")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  AXFrame {
    id: frUpdatePeriod
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: rcUpdateTitle.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    Text {
      id: txPeriodText
      clip: true
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: ACMeasures.fuToDots(3)
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Update check period:")
      color: SStyleSheet.coComboBoxTextColor
      font.family: SStyleSheet.srComponentFont
    }
    ComboBox {
      id: cbUpdatePeriod
      currentIndex: 5
      editable: false
      anchors.top: parent.top
      anchors.left: txPeriodText.right
      anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      textRole: "miPeriod"
      style: ComboBoxStyle {
    //    padding.top: 14
        font.family: SStyleSheet.srComponentFont
        font.pointSize: 8
      }
      model: ListModel {
        id: moItems
        ListElement { miPeriod: "1 Hour" }
        ListElement { miPeriod: "2 Hours" }
        ListElement { miPeriod: "3 Hours" }
        ListElement { miPeriod: "4 Hours" }
        ListElement { miPeriod: "5 Hours" }
        ListElement { miPeriod: "6 Hours" }
        ListElement { miPeriod: "7 Hours" }
        ListElement { miPeriod: "8 Hours" }
        ListElement { miPeriod: "9 Hours" }
        ListElement { miPeriod: "10 Hours" }
        ListElement { miPeriod: "11 Hours" }
        ListElement { miPeriod: "12 Hours" }
        ListElement { miPeriod: "13 Hours" }
        ListElement { miPeriod: "14 Hours" }
        ListElement { miPeriod: "15 Hours" }
        ListElement { miPeriod: "16 Hours" }
        ListElement { miPeriod: "17 Hours" }
        ListElement { miPeriod: "18 Hours" }
        ListElement { miPeriod: "19 Hours" }
        ListElement { miPeriod: "20 Hours" }
        ListElement { miPeriod: "21 Hours" }
        ListElement { miPeriod: "22 Hours" }
        ListElement { miPeriod: "23 Hours" }
        ListElement { miPeriod: "24 Hours" }
      }
    }
  }
  AXFrame {
    id: frUpdateChannel
    anchors.left: parent.left
    anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    anchors.top: frUpdatePeriod.bottom
    anchors.topMargin: ACMeasures.fuToDots(SStyleSheet.reComponentItemSpace)
    anchors.right: parent.right
    anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentIndentation)
    reHeightCm: SStyleSheet.reComponentRowHeight
    Text {
      id: txChannelText
      clip: true
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: ACMeasures.fuToDots(3)
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Type of update:")
      color: SStyleSheet.coComboBoxTextColor
      font.family: SStyleSheet.srComponentFont
    }
    ComboBox {
      id: cbUpdateChannel
      currentIndex: 3
      editable: false
      anchors.top: parent.top
      anchors.left: txChannelText.right
      anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      textRole: "miChannel"
      style: ComboBoxStyle {
    //    padding.top: 14
        font.family: SStyleSheet.srComponentFont
        font.pointSize: 8
      }
      model: ListModel {
        id: moChannel
        ListElement { miChannel: "Alpha" }
        ListElement { miChannel: "Beta" }
        ListElement { miChannel: "Release Candidate" }
        ListElement { miChannel: "Public Release" }
      }
    }
  }
  /*
  Component.onCompleted: {
    mStatus = Qt.binding(function() {
                if((tfWdcPassword.srValue != "") && (tfWdcPassword.srValue === tfWdcRepeatPassword.srValue)) return true
                if((tfWdcPassword.srValue != "") && (tfWdcRepeatPassword.srValue == "")) return true
                return false
              })
  }*/
  function fuAccept() {
    var boMinimizeOnTray = "0"
    var boMinimizeToTray = "0"
    if(cbMinimizeOnClose.checked) boMinimizeOnTray = "1"
    if(cbMinimizeToTray.checked) boMinimizeToTray = "1"
    mCXDefinitions.mMinimizeToTray = String(boMinimizeToTray)
    mCXDefinitions.mMinimizeOnClose = String(boMinimizeOnTray)
    mCXDefinitions.mUpdateCheckPeriod = String(cbUpdatePeriod.currentIndex + 1)
    mCXDefinitions.mUpdateChannel = String(cbUpdateChannel.currentIndex + 1)
    mCXDefinitions.fSaveSettings()
  }
  function fuActivate() {
    var boMinimizeOnTray = "0"
    var boMinimizeToTray = "0"
    if(mCXDefinitions.mMinimizeOnClose === "") {
      if(cbMinimizeOnClose.srDefaultValue == "0") {
        cbMinimizeOnClose.boValue = false
        mCXDefinitions.mMinimizeOnClose = "0"
      }
      else {
        cbMinimizeOnClose.boValue = true
        mCXDefinitions.mMinimizeOnClose = "1"
      }
    }
    if(mCXDefinitions.mMinimizeOnClose === "0") cbMinimizeOnClose.boValue = false
    if(mCXDefinitions.mMinimizeOnClose === "1") cbMinimizeOnClose.boValue = true

    if(mCXDefinitions.mMinimizeToTray === "") {
      if(cbMinimizeToTray.srDefaultValue == "0") {
        cbMinimizeToTray.boValue = false
        mCXDefinitions.mMinimizeToTray = "0"
      }
      else {
        cbMinimizeToTray.boValue = true
        mCXDefinitions.mMinimizeToTray = "1"
      }
    }
    if(mCXDefinitions.mMinimizeToTray === "0") cbMinimizeToTray.boValue = false
    if(mCXDefinitions.mMinimizeToTray === "1") cbMinimizeToTray.boValue = true

    cbUpdatePeriod.currentIndex = Number(mCXDefinitions.mUpdateCheckPeriod) - 1
    cbUpdateChannel.currentIndex = Number(mCXDefinitions.mUpdateChannel) - 1
  }
  function fuSetup() { }
}
