import QtQuick 2.4
import QtQuick.Controls 1.3
import "../../../WFUserInterface/AXLib"
import SStyleSheet.Lib 1.0
import ACMeasures.Lib 1.0
import WFDefinitions.Lib 1.0

AXComponent {
  id: rcRoot
  reHeightCm: 11
  reWidthCm: 15

  property real reColumnWidth: 7.5
  property bool boWaitingForBackup

  Component {
    id: coCategory   
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
    id: coVersionElement
    AXFrame {        
      id: frVersionElement
      reHeightCm: ACMeasures.fuToCentimeters(frVersion.height + frLogEntry.height + rcSpace.height + frUpdateInfo.height)
      width: parent.width
      Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: frVersion.bottom
        width: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
        color: SStyleSheet.coComponentVerticalHeaderColor
      }
      Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight / 2)
        width: frVersion.width
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
        id: frVersion
        clip: true
        color: SStyleSheet.coComponentVerticalHeaderColor
        reHeightCm: SStyleSheet.reComponentRowHeight
        reWidthCm: reColumnWidth
        anchors.top: parent.top
        anchors.right: parent.right
        radius: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) / 2
        Text {
          anchors.fill: parent
          anchors.rightMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          horizontalAlignment: "AlignRight"
          verticalAlignment: "AlignVCenter"
          text: miVersion + " - " + miVersionName
          color: SStyleSheet.coComponentVerticalHeaderTextColor
          font.bold: false
          font.italic: false
          font.family: SStyleSheet.srComponentFont
        }
      }
      AXFrame {          
        id: frLogEntry
        clip: true
        anchors.top: frVersion.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: SStyleSheet.coComponentDetailBackgroundColor
        //reHeightCm: SStyleSheet.reComponentRowHeight
        height: txLogEntry.paintedHeight
        Text {
          id: txLogEntry
          anchors.fill: parent
          anchors.leftMargin: ACMeasures.fuToDots(SStyleSheet.reComponentDetailLeftMargin)
          horizontalAlignment: "AlignLeft"
          verticalAlignment: "AlignVCenter"
          text: miLogEntry
          color: SStyleSheet.coComponentDetailTextColor
          font.bold: false
          font.italic: true
          font.family: SStyleSheet.srComponentFont
        }
      }
      Rectangle {
        id: rcSpace
        anchors.top: frLogEntry.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        height: ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight)
        color: "Transparent"
      }
      AXFrame {
        id: frUpdateInfo
        clip: true
        anchors.top: rcSpace.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: (scView.width - ACMeasures.fuToDots(reColumnWidth)) / 2.5
        anchors.leftMargin: (scView.width - ACMeasures.fuToDots(reColumnWidth)) / 2.5
        height: !index && miUpgradable ? ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) : 0
        color: SStyleSheet.coComponentDetailTotalBackgroundColor
        reHeightCm: SStyleSheet.reComponentRowHeight
        radius: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) / 2
        Rectangle {
          anchors.bottom: parent.bottom
          x: -1 * (scView.width - ACMeasures.fuToDots(reColumnWidth)) / 2
          width: scView.viewport.width
          height: 1
          color: SStyleSheet.coComponentDetailTotalBackgroundColor
        }
        Rectangle {
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          anchors.left: parent.left
          height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight / 2)
          color: SStyleSheet.coComponentDetailTotalBackgroundColor
        }
        Text {
          anchors.fill: parent
          horizontalAlignment: "AlignHCenter"
          verticalAlignment: "AlignVCenter"
          text: qsTr("Type: " + miChannel + "  -  Priority: " + miPriority)
          color: SStyleSheet.coComponentDetailTotalTextColor
          font.bold: true
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
  Rectangle {
    id: rcUpgradeInfo
    objectName: "UpgradeInfo"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: ACMeasures.fuToDots(SStyleSheet.reComponentHorizontalHeaderRowHeight) * 2
    color: SStyleSheet.coComponentInformationBackgroundColor
    Text {
      anchors.fill: parent
      horizontalAlignment: "AlignHCenter"
      verticalAlignment: "AlignVCenter"
      text: qsTr("If you click 'Ok', WBC will make a backup of the wallet (if selected in 'Backup Settings'), close and finally launch the wizard that will download the latest version available")
      color: SStyleSheet.coComponentDetailTotalTextColor
      font.bold: true
      wrapMode: Text.WordWrap
      font.pixelSize: parent.height * 0.3
      font.family: SStyleSheet.srComponentFont
    }
  }
  ScrollView {    
    id: scView
    anchors.fill: rcRoot
    anchors.topMargin: rcUpgradeInfo.height
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    Rectangle {
      id: rcView
      width: rcRoot.width
      color: "transparent"
      ListView {
        property string srTitle: qsTr("New Releases")

        id: lvNewReleases
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        clip: true
        header: coCategory
        model: lmNewVersions
        delegate: coVersionElement
        onContentHeightChanged: {
          height = contentHeight
          fuResizeView()
        }
      }
      ListView {
        property string srTitle: qsTr("Current Release")

        id: lvCurrentRelease
        anchors.top: lvNewReleases.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        clip: true
        height: headerItem.height + count * ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) * 2
        header: coCategory
        model: lmCurrentVersion
        delegate: coVersionElement
        onContentHeightChanged: {
          height = contentHeight
          fuResizeView()
        }
      }
      ListView {
        property string srTitle: qsTr("Previous Releases")

        id: lvPreviousReleases
        anchors.top: lvCurrentRelease.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: rcView.width - scView.viewport.width
        clip: true
        height: headerItem.height + count * ACMeasures.fuToDots(SStyleSheet.reComponentRowHeight) * 2
        header: coCategory
        model: lmPreviousVersions
        delegate: coVersionElement
        onContentHeightChanged: {
          height = contentHeight
          fuResizeView()
        }
      }
    }
  }
  ListModel { id: lmNewVersions }
  ListModel { id: lmCurrentVersion }
  ListModel { id: lmPreviousVersions }

  function fuActivate() {
    if(mCXPulzarConnector.mConnectionStatus == CXDefinitions.EServiceReady) fuFillModels()
  }
  function fuSetup() { mStatus = false; boWaitingForBackup = false }
  function fuAccept() {
    if(ComponentBackupSettings.boBackupOnUpdate) {
      boWaitingForBackup = true;
      ComponentBackupWallet.fuAccept()
    }
    else mCXStatus.tExecuteWizard();
  }
  function fuFillModels() {
    lmNewVersions.clear()
    lmCurrentVersion.clear()
    lmPreviousVersions.clear()

    var vaCurrentVersion = /*"01.00.01"/*/  mCXDefinitions.fExtendVersion(mCXDefinitions.fCurrentVersion())
    var vaUpdatePriority = mCXPulzarConnector.fUpdatePriority()
    var vaUpdateChannel = mCXDefinitions.mUpdateChannel

    if(vaUpdatePriority == CXDefinitions.EUpgradeLow) vaUpdatePriority = qsTr("Low")
    if(vaUpdatePriority == CXDefinitions.EUpgradeMedium) vaUpdatePriority = qsTr("Medium")
    if(vaUpdatePriority == CXDefinitions.EUpgradeHigh) vaUpdatePriority = qsTr("High")
    if(vaUpdatePriority == CXDefinitions.EUpgradeCritical) vaUpdatePriority = qsTr("CRITICAL")
    if(vaUpdateChannel == CXDefinitions.EChannelAlpha) vaUpdateChannel = qsTr("Alpha")
    if(vaUpdateChannel == CXDefinitions.EChannelBeta) vaUpdateChannel = qsTr("Beta")
    if(vaUpdateChannel == CXDefinitions.EChannelRC) vaUpdateChannel = qsTr("Release Candidate")
    if(vaUpdateChannel == CXDefinitions.EChannelRelease) vaUpdateChannel = qsTr("Public Release")

    var lNames = mCXPulzarConnector.fVersionName()
    var lLog = mCXPulzarConnector.fVersionLog()
    for(var vaVersion in lNames) {
      var vaCompressedVersion = mCXDefinitions.fCompressVersion(vaVersion)
      if(vaCurrentVersion < vaVersion) {
        lmNewVersions.insert(0, {"miVersion": vaCompressedVersion, "miVersionName": lNames[vaVersion], "miLogEntry": lLog[vaVersion], "miUpgradable": 1, "miPriority": vaUpdatePriority, "miChannel": vaUpdateChannel })
        mStatus = true;
      }
      if(vaCurrentVersion == vaVersion) lmCurrentVersion.insert(0, {"miVersion": vaCompressedVersion, "miVersionName": lNames[vaVersion], "miLogEntry": lLog[vaVersion], "miUpgradable": 0, "miPriority": "", "miChannel": "" })
      if(vaCurrentVersion > vaVersion) lmPreviousVersions.insert(0, {"miVersion": vaCompressedVersion, "miVersionName": lNames[vaVersion], "miLogEntry": lLog[vaVersion], "miUpgradable": 0, "miPriority": "", "miChannel": "" })
    }
  }
  function fuResizeView() {
    rcView.height = lvNewReleases.height + lvCurrentRelease.height + lvPreviousReleases.height
  }
  Connections {
    target: mCXPulzarConnector
    onSVersionLogChanged: {
      fuFillModels()
    }
  }
  Connections {
    target: ComponentBackupWallet
    onSiBackupCompleted: {
      if(boWaitingForBackup) mCXStatus.tExecuteWizard();
      boWaitingForBackup = false
    }
  }

}
