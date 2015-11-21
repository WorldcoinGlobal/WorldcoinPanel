import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import ACMeasures.Lib 1.0

Rectangle {
  id: rcCommandBar
  clip: true
  property bool boStatus: true
  property alias coBorderColor: rcBorder.color
  property color coOkButtonTextColor
  property color coOkButtonBorderColor
  property color coOkButtonReleasedColor
  property color coOkButtonPressedColor
  property color coOkButtonDisabledColor
  property color coOkButtonDisabledBorderColor
  property color coCancelButtonTextColor
  property color coCancelButtonBorderColor
  property color coCancelButtonReleasedColor
  property color coCancelButtonPressedColor
  property real reButtonBorderWidth
  property real reButtonRadius
  property real reButtonWidth
  property real reTopMargin
  property real reLeftMargin
  property real reRightMargin
  property real reBottomMargin
  property real reButtonSpace
  //property real reDefaultHeight
  property string srFontFamily

  signal siCancelButtonClicked()
  signal siOkButtonClicked()

  anchors.fill: parent
/*  anchors.top: parent.top
  anchors.right: parent.right
  anchors.left: parent.left*/
 // anchors.bottom: parent.bottom

//  property url urButtonNetworkImage
//  property url urButtonEncryptedImage
  Rectangle {
    id: rcBorder
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
  }
  Row {
    anchors.top: rcBorder.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    anchors.topMargin: ACMeasures.fuToDots(reTopMargin) //* mCXDefinitions.mZoomFactor
    anchors.rightMargin: ACMeasures.fuToDots(reRightMargin) //* mCXDefinitions.mZoomFactor
    anchors.bottomMargin: ACMeasures.fuToDots(reBottomMargin) // * mCXDefinitions.mZoomFactor
    anchors.leftMargin: ACMeasures.fuToDots(reLeftMargin) // * mCXDefinitions.mZoomFactor
    spacing: ACMeasures.fuToDots(reButtonSpace)
    layoutDirection: Qt.RightToLeft
    Button {
      id: btOk
      isDefault: false
      enabled: boStatus
      width: ACMeasures.fuToDots(reButtonWidth) * mCXDefinitions.mZoomFactor;
      height: rcCommandBar.height - ACMeasures.fuToDots(reTopMargin + reBottomMargin) - rcBorder.height
      style: ButtonStyle {
        background: Rectangle {
          border.width: ACMeasures.fuToDots(reButtonBorderWidth)
          border.color: boStatus ? coOkButtonBorderColor : coOkButtonDisabledBorderColor
          radius: ACMeasures.fuToDots(reButtonRadius)
          color: control.pressed ? coOkButtonPressedColor : boStatus ? coOkButtonReleasedColor : coOkButtonDisabledColor
        }
        label: Text {
          anchors.fill: parent
          color: coOkButtonTextColor
          text: qsTr("Ok")
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.family: srFontFamily
          font.pixelSize: btOk.height
        }
      }
      onClicked: { siOkButtonClicked() }
    }
    Button {
      id: btCancel
      isDefault: true
      width: ACMeasures.fuToDots(reButtonWidth) * mCXDefinitions.mZoomFactor;
      height: rcCommandBar.height - ACMeasures.fuToDots(reTopMargin + reBottomMargin) - rcBorder.height
      style: ButtonStyle {
        background: Rectangle {
          border.width: ACMeasures.fuToDots(reButtonBorderWidth)
          border.color: coCancelButtonBorderColor
          radius: ACMeasures.fuToDots(reButtonRadius)
          color: control.pressed ? coCancelButtonPressedColor : coCancelButtonReleasedColor
        }
        label: Text {
          anchors.fill: parent
          color: coCancelButtonTextColor
          text: qsTr("Cancel")
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.family: srFontFamily
          font.pixelSize: btCancel.height
        }
      }
      onClicked: { siCancelButtonClicked() }
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

  function fuScale() {
    //btCancel.width = ACMeasures.fuToDots(reButtonWidth) * mCXDefinitions.mZoomFactor;
    //btOk.width = ACMeasures.fuToDots(reButtonWidth) * mCXDefinitions.mZoomFactor;
  }
  function fuDisable(boDisable) {
    if(boDisable) {
      rcDisabled.opacity = 0.3
      btOk.enabled = false
      btCancel.enabled = false
    }
    else {
      rcDisabled.opacity = 0
      btOk.enabled = true
      btCancel.enabled = true
    }
  }
}

