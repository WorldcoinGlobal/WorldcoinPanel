#include <CXDefinitions.h>

#include "CXConnectorManager.h"
#include "GXGuiApplication.h"

CXConnectorManager::CXConnectorManager(QObject *pParent)
                  : QObject(pParent) {
  connect(BXGuiApplication::fInstance(), &BXGuiApplication::sStatusTextChanged, this, &CXConnectorManager::sStatusChanged);
}

CXConnectorManager::~CXConnectorManager() {

}

bool CXConnectorManager::fStartDaemon(const QString& lName, bool lForce) {
  if(!mConnectors.contains(lName)) {
    BXGuiApplication::fInstance()->fLogMessage(5200002);
    return false;
  }
  if((mConnectors.value(lName)->fStatus() != CXDefinitions::EServiceStopped) && (mConnectors.value(lName)->fStatus() != CXDefinitions::EServiceError)) {
    BXGuiApplication::fInstance()->fLogMessage(4200006, mConnectors.value(lName)->fName());
    return true;
  }
  if((mConnectors.value(lName)->fName() == cDefaultDaemon) && (!mConnectors.value(lName)->fStart())) {
    BXGuiApplication::fInstance()->fLogMessage(3200024, mConnectors.value(lName)->fName());
    return false;
  }
  if((mConnectors.value(lName)->fName() != cDefaultDaemon) && (mConnectors.value(lName)->fIsEnabled() || lForce) &&  (!mConnectors.value(lName)->fStart())) {
    BXGuiApplication::fInstance()->fLogMessage(3200024, mConnectors.value(lName)->fName());
    return false;
  }

  return true;
}

bool CXConnectorManager::fStopDaemon(const QString& lName) {
  if(!mConnectors.contains(lName)) {
    BXGuiApplication::fInstance()->fLogMessage(5200002);
    return false;
  }
  if((mConnectors.value(lName)->fStatus() == CXDefinitions::EServiceStopped) || (mConnectors.value(lName)->fStatus() == CXDefinitions::EServiceError)) {
    BXGuiApplication::fInstance()->fLogMessage(4200007, mConnectors.value(lName)->fName());
    return true;
  }
  if((!mConnectors.value(lName)->fStop())) {
    BXGuiApplication::fInstance()->fLogMessage(3200025, mConnectors.value(lName)->fName());
    return false;
  }
  return true;
}

bool CXConnectorManager::fStartDaemons() {
  BXGuiApplication::fInstance()->fUpdateStatusText(2200003);
  if(!mConnectors.contains(cDefaultDaemon)) {
    BXGuiApplication::fInstance()->fLogMessage(3200006);
    return false;
  }
  QMapIterator<QString, BXCryptoConnector* > i(mConnectors);
  while (i.hasNext()) {
    i.next();
    if(!fStartDaemon(i.key(), false)) return false;
  }
  return true;
}

void CXConnectorManager::fEndService() {
  QMapIterator<QString, BXCryptoConnector* > i(mConnectors);
  while (i.hasNext()) {
    i.next();
    i.value()->fEndService();
  }
}

void CXConnectorManager::fExecuteWizard() {
  BXGuiApplication::fInstance()->fExecuteWizard();
}

QStringList CXConnectorManager::fConnectors() const {
  QStringList lConnectors;
  QMapIterator<QString, BXCryptoConnector* > i(mConnectors);
  while (i.hasNext()) {
    i.next();
    lConnectors << i.key();
  }
  return lConnectors;
}

void CXConnectorManager::fPrepareStatus() {
   BXCryptoConnector* pConnector = qobject_cast<BXCryptoConnector*> (sender());
   emit sStatusChanged(pConnector->fName());
}
