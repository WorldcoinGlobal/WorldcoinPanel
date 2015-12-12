import QtQuick 2.4
import QtQuick.Controls 1.3
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import Qt.labs.folderlistmodel 2.1

AXComponent {
  id: rcRoot
  reHeightCm: 8
  reWidthCm: 13
  property string srBaseBackupName: ComponentBackupSettings.srBaseName
  property string srBaseBackupExtension: "dat"
  property string srCurrentFolder: moFolderModel.folder
  signal siBackupCompleted

  AXFrame {
    id: rcFileTitle
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Current Backup Directory ")
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  AXFrame {
    id: rcFileSubTitle
    color: SStyleSheet.coComponentVerticalHeaderColor
    anchors.top: rcFileTitle.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    reHeightCm: SStyleSheet.reComponentRowHeight
    Row {
      AXFrame {
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: 5
        clip: true
        Text {
          anchors.fill: parent
          text: qsTr("File Name")
          horizontalAlignment: "AlignHCenter"
          verticalAlignment: "AlignVCenter"
          color: SStyleSheet.coComponentVerticalHeaderTextColor
          font.bold: true
          font.family: SStyleSheet.srComponentFont
        }
      }
      AXFrame {
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: 2
        clip: true
        Text {
          anchors.fill: parent
          text: qsTr("Size")
          horizontalAlignment: "AlignHCenter"
          verticalAlignment: "AlignVCenter"
          color: SStyleSheet.coComponentVerticalHeaderTextColor
          font.bold: true
          font.family: SStyleSheet.srComponentFont
        }
      }
      AXFrame {
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: 3
        clip: true
        Text {
          anchors.fill: parent
          text: qsTr("Date")
          horizontalAlignment: "AlignHCenter"
          verticalAlignment: "AlignVCenter"
          color: SStyleSheet.coComponentVerticalHeaderTextColor
          font.bold: true
          font.family: SStyleSheet.srComponentFont
        }
      }
    }
  }
  Component {
    id: coFileDelegate
    Row {
      id: rwRow
      property bool boIsCurrentItem: ListView.isCurrentItem
      AXFrame {
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: 5
        clip: true
        color: {
          if(boIsCurrentItem) return SStyleSheet.coComponentDetailHighlightBackgroundColor
          else return "transparent"
        }
        Text {
          anchors.fill: parent
          anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          text: fileName
          font.family: SStyleSheet.srComponentFont
          color: SStyleSheet.coComponentDetailTextColor
          verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
          anchors.fill: parent
          onPressed: { lvFiles.currentIndex = index; }
          onClicked: { if(fileIsDir) fuChangeDir(fileName) }
        }
      }
      AXFrame {
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: 2
        clip: true
        color: {
          if(boIsCurrentItem) return SStyleSheet.coComponentDetailHighlightBackgroundColor
          else return "transparent"
        }
        Text {
          anchors.fill: parent
          anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          text: fileSize
          font.family: SStyleSheet.srComponentFont
          color: "Black"
          verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
          anchors.fill: parent
          onPressed: { lvFiles.currentIndex = index; }
          onClicked: { if(fileIsDir) fuChangeDir(fileName) }
        }
      }
      AXFrame {
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: 4
        clip: true
        color: {
          if(boIsCurrentItem) return SStyleSheet.coComponentDetailHighlightBackgroundColor
          else return "transparent"
        }
        Text {
          anchors.fill: parent
          anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          text: fileModified
          font.family: SStyleSheet.srComponentFont
          color: "Black"
          verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
          anchors.fill: parent
          onPressed: { lvFiles.currentIndex = index; }
          onClicked: { if(fileIsDir) fuChangeDir(fileName) }
        }
      }
    }
  }
  ScrollView {
    id: scView
    anchors.top: rcFileSubTitle.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: rcFilePath.top
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    Rectangle {
      id: rcFilesBackground
      color: SStyleSheet.coComponentDetailBackgroundColor
      width: scView.width
      height: lvFiles.contentHeight > scView.height ?  lvFiles.contentHeight : scView.height - 1

      ListView {
        id: lvFiles
        anchors.fill: parent
        clip: true
        highlightRangeMode: ListView.NoHighlightRange
        model: moFolderModel
        delegate: coFileDelegate

        FolderListModel {
          id: moFolderModel
          folder: mCXDefinitions.fCanonicalPath(ComponentBackupSettings.srBackupDirectory, false)
          nameFilters: ["*.dat"]
          showDirs : true
          showDirsFirst : true
          showDotAndDotDot : true
          showFiles : true
          showHidden : false
          showOnlyReadable : true
          sortReversed : false
        }
      }
    }
  }
  AXFrame {
    id: rcFilePath
    color: SStyleSheet.coComponentHorizontalHeaderColor
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    reHeightCm: SStyleSheet.reComponentHorizontalHeaderRowHeight
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignLeft"
      verticalAlignment: "AlignVCenter"
      text: qsTr("Path: " + mCXDefinitions.fCanonicalPath(srCurrentFolder, true))
      color: SStyleSheet.coComponentHorizontalHeaderTextColor
      font.bold: true
      font.italic: true
      font.family: SStyleSheet.srComponentFont
    }
  }
  Connections {
    target: rcRoot
    onSMessageArrived: { rcRoot.siBackupCompleted() }
  }
  function fuChangeDir(srNewDir) {
    var vaCurrentPath = moFolderModel.folder;
    var vaFileName = srNewDir;
    var vaNewPath = vaCurrentPath + "/" + vaFileName
    vaNewPath = mCXDefinitions.fCanonicalPath(vaNewPath, false)
    moFolderModel.folder = vaNewPath;
    lvFiles.currentIndex = -1;
  }
  function fuAccept() {
    var vaBackupName = mCXDefinitions.fCanonicalPath(moFolderModel.folder, true) + "/" + ComponentBackupSettings.srBaseName + "_" + ComponentBackupSettings.srCoin + "_" + mCXDefinitions.fCurrentDate() + ".dat"
    fRawCallRequested(ComponentBackupSettings.srCoin, "backupwallet " + vaBackupName)
  }
  function fuActivate() { }
  function fuSetup() { }
}
