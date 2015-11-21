#include <QProcess>
#include <QTimer>

#include "CXStatus.h"

CXStatus::CXStatus(QObject *pParent)
        : QObject(pParent) {

}

CXStatus::~CXStatus() {

}

void CXStatus::tExecuteWizard() {
  QString lWizard = qApp->applicationDirPath() + "/" + cWizardExec;
  if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) lWizard.append(".exe");
  QProcess::startDetached(lWizard, QStringList() << "--install");

  QTimer::singleShot(0, qApp, SLOT(quit()));
}

void CXStatus::tSetConnectionsStatus(int lConnectionsStatus) {
  mConnectionsStatus = lConnectionsStatus;
  emit sConnectionsStatusChanged();
}

void CXStatus::tSetDaemonStatus(int lDaemonStatus) {
  mDaemonStatus = lDaemonStatus;
  if(mDaemonStatus == CXDefinitions::EServiceClosing) QTimer::singleShot(30000, this, SLOT(tExecuteWizard()));
  emit sDaemonStatusChanged();
}

void CXStatus::tSetLockStatus(int lLockStatus) {
  mLockStatus = lLockStatus;
  emit sLockStatusChanged();
}

void CXStatus::tSetServicesStatus(int lServicesStatus) {
  mServicesStatus = lServicesStatus;
  emit sServicesStatusChanged();
}

void CXStatus::tSetSyncStatus(int lSyncStatus) {
  mSyncStatus = lSyncStatus;
  emit sSyncStatusChanged();
}

void CXStatus::tSetUpdatesStatus(int lUpdatesStatus) {
  mUpdatesStatus = lUpdatesStatus;
  emit sUpdatesStatusChanged();
}
