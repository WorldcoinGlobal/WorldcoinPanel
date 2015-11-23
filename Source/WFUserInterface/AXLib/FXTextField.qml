import QtQuick 2.4
import ACMeasures.Lib 1.0
import QtQuick.Controls 1.3

Item {
  id: itRoot
  property bool boSaveSetting: true
  property alias coLabelTextColor: txLabelText.color
  property alias echoMode: tfText.echoMode
  property real reHeightCm  
  property real reWidthCm
  property real reTextFieldWidth
  property alias stStyle: tfText.style
  property alias srLabelText: txLabelText.text
  property alias srFontFamily: txLabelText.font.family  
  property alias vlValidator: tfText.validator
  property string srDefaultValue
  property alias srValue: tfText.text
  property string srSetting
  signal siAccepted

  width: ACMeasures.fuToDots(reWidthCm)
  height: ACMeasures.fuToDots(reHeightCm)
  Text {
    id: txLabelText
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    width: paintedWidth
//      height: control.height * 0.8
  //  color: coTextColor
    verticalAlignment: Text.AlignVCenter
   // font.family: tfText.style.font.family
    font.bold: false
    font.italic: false
  }
  TextField {
    id: tfText
    clip: true
    anchors.top: parent.top
    anchors.left: txLabelText.right
    anchors.leftMargin: ACMeasures.fuToDots(reHeightCm * 0.5)
    anchors.bottom: parent.bottom
 //   width: reTextFieldWidth > 0 ? ACMeasures.fuToDots(reTextFieldWidth) : parent.width
    anchors.right: parent.right
    onAccepted: { itRoot.siAccepted() }
  }
  function fuSave() {
    parent.tSetSetting(srSetting, tfText.text)
  }
  function fuLoad() {
    tfText.text = srDefaultValue

    if(boSaveSetting && parent.fSetting(srSetting) === '') {
      parent.tSetSetting(srSetting, srDefaultValue)
      tfText.text = srDefaultValue
    }
    if(boSaveSetting && parent.fSetting(srSetting) !== '') {
      tfText.text = parent.fSetting(srSetting)
    }
  }
}



