import QtQuick 2.4
import SStyleSheet.Lib 1.0

import "../../AXLib"
import "../"

AXInfoBar {
  color: SStyleSheet.coInfoBarBackgroudColor
  reSpacing: SStyleSheet.reInfoBarSpacing
  reDefaultHeight: SStyleSheet.reInfoBarHeight
  reBorderWidth: SStyleSheet.reInfoBarBorderWidth
  coBottomBorderColor: SStyleSheet.coInfoBarBottomBorderColor
  coTextColor: SStyleSheet.coInfoBarTextColor

  urIconDefault: "../Images/InfoBar_IMDefaultAvatar.svg"
  urIconDaemonOff: "../Images/InfoBar_IMDaemonOff.svg"
  urIconDaemonReady: "../Images/InfoBar_IMDaemonReady.svg"
  urIconDaemonProcessing: "../Images/InfoBar_IMDaemonProcessing.svg"
  urIconDaemonError: "../Images/InfoBar_IMDaemonError.svg"
  urIconSyncOff: "../Images/InfoBar_IMSyncOff.png"
  urIconSyncOn: "../Images/InfoBar_IMSyncOn.png"
  urIconSyncFinished: "../Images/InfoBar_IMSyncFinished.png"
  urIconLockOff: "../Images/InfoBar_IMLockOff.svg"
  urIconLockOn: "../Images/InfoBar_IMLockOn.svg"
  urIconConnectionsOff: "../Images/InfoBar_IMConnectionsOff.svg"
  urIconConnectionsMax: "../Images/InfoBar_IMConnectionsMax.png"
  urIconConnectionsProcessing: "../Images/InfoBar_IMConnectionsProcessing.png"
  urIconServicesOff: "../Images/InfoBar_IMServicesOff.svg"
  urIconServicesReady: "../Images/InfoBar_IMServicesReady.svg"
  urIconServicesProcessing: "../Images/InfoBar_IMServicesProcessing.png"
  urIconServicesError: "../Images/InfoBar_IMServicesError.png"
  urIconUpdatesOff: "../Images/InfoBar_IMUpdatesOff.svg"
  urIconUpdatesNoUpdates: "../Images/InfoBar_IMUpdatesNoUpdates.svg"
  urIconUpdatesLowPriority: "../Images/InfoBar_IMUpdatesLowPriority.svg"
  urIconUpdatesMediumPriority: "../Images/InfoBar_IMUpdatesMediumPriority.svg"
  urIconUpdatesHighPriority: "../Images/InfoBar_IMUpdatesHighPriority.svg"
  urIconUpdatesCriticalPriority: "../Images/InfoBar_IMUpdatesCriticalPriority.svg"
}

