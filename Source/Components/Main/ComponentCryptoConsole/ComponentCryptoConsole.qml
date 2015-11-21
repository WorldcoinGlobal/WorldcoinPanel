import QtQuick 2.4
import QtQuick.Controls 1.3
import WFDefinitions.Lib 1.0
import SStyleSheet.Lib 1.0
import "../../../WFUserInterface/AXLib"

AXComponent {
  id: rcRoot
  reHeightCm: 8
  reWidthCm: 17
  focus: true
  coDefaultFocus: tfCommand

  property string srLastCommand
  property real reColumnWidth: 2.5
  property real reViewHeight
  property real reViewWidth

  ListModel { id: lmConsole }
  ScrollView {
    id: scView
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: frFrame.top

    Rectangle {
      id: rcView
      color: "transparent"
      ListView {
        id: taConsole
        model: lmConsole
        anchors.fill: parent
        delegate: Row {
          id: rwDelegate
          spacing: 10
          height: xtData.paintedHeight > xtMetaData.paintedHeight ? xtData.paintedHeight : xtMetaData.paintedHeight
          AXTextEdit {
            id: xtMetaData
            readOnly: true
            selectByMouse: true
            textFormat: TextEdit.PlainText
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            reWidthCm: reColumnWidth
            color: "SteelBlue"
            text: vaMetadata
            font.family: SStyleSheet.srComponentFont
            font.italic: true
          }
          Rectangle {
            id: rcSep
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: SStyleSheet.coComponentTopBorderColor
          }
          AXTextEdit {
            id: xtData
            readOnly: true
            selectByMouse: true
            textFormat: TextEdit.PlainText
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "Black"
            text: vaData
            font.family: SStyleSheet.srComponentFont
            font.bold: vaBold
          }
          onWidthChanged: { xtData.width = xtData.paintedWidth }
          Component.onCompleted: {
            reViewHeight = reViewHeight + height
            if(reViewWidth < width) reViewWidth = width
          }
        }
        onCountChanged: {
          rcView.height = reViewHeight
          if(reViewHeight > scView.height) scView.flickableItem.contentY = reViewHeight - scView.height
          rcView.width = reViewWidth
        }
        add: Transition {
          NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
          NumberAnimation { property: "scale"; easing.type: Easing.OutQuad; from: 0; to: 1.0; duration: 750 }
        }
      }
    }
  }
  AXFrame {
    id: frFrame
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    reHeightCm: 0.5
    focus: true
    TextField {
      id: tfCommand
      anchors.fill: parent
      focus: true
      style: SXTextField {
        reHeightCm: SStyleSheet.reComponentRowHeight
        coBackgroundColor: SStyleSheet.coComponentInputNeutralColor
        font.family: SStyleSheet.srFontFamily
        font.pixelSize: tfCommand.height * 0.6
        textColor: SStyleSheet.coComponentInputTextColor
      }
      placeholderText: qsTr("Enter command")
      onAccepted: {
        fRawCallRequested("WDC", tfCommand.text)
        srLastCommand = tfCommand.text
        tfCommand.text = ""
      }
      Keys.onPressed: {
        if (event.key == Qt.Key_Up) {
           tfCommand.text = srLastCommand
           event.accepted = true;
        }
      }
    }
  }
  Connections {
    target: rcRoot
    onSMessageArrived: {
      var vaBold = false;
      if(lMessageType == CXDefinitions.EBugMessage) vaBold = true;
      if(lMessageType == CXDefinitions.EErrorMessage) vaBold = true;
      if(lMessageType == CXDefinitions.EWarningMessage) vaBold = true;
      if(lMessageType == CXDefinitions.ESuccessMessage) vaBold = false;
      lmConsole.append({"vaMetadata" : qsTr("Request[") + lRequestID + "]\n   --  " + mCXDefinitions.fCurrentDate() + "  --", "vaData" : "   --  " + lInput + "  --\n" + lMessage + "\n", "vaBold" : vaBold})
    }
  }
  function fuActivate() { }
  function fuSetup() {

  }
}
