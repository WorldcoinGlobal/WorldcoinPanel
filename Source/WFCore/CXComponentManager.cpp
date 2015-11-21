#include <QCoreApplication>
#include <QFile>
#include <QJsonValue>
#include <QTextStream>
#include <QVariantList>

#include "BXGuiApplication.h"
#include "CXComponentManager.h"
#include "CXMessage.h"
#include "CXMessagePool.h"

CXComponentManager::CXComponentManager(QObject *pParent)
        : QObject(pParent) {

}

CXComponentManager::~CXComponentManager() {

}

GXComponent* CXComponentManager::fComponentContent(const QString& lComponentName) {
  if(mComponentContent.contains(lComponentName)) return mComponentContent.value(lComponentName);
  return nullptr;
}

GXSubWindow* CXComponentManager::fComponent(const QString& lComponentName) {
  if(mComponents.contains(lComponentName)) return mComponents.value(lComponentName);
  return nullptr;
}

QString CXComponentManager::fComponentDirectory(int lComponentCategory) {
 // QString lDirectory(qApp->applicationDirPath() + "/");
  QString lDirectory("../../");
  if(lComponentCategory == CXDefinitions::EMainComponent) lDirectory += cMainComponentsDir;
  if(lComponentCategory == CXDefinitions::EExtraComponent) lDirectory += cExtraComponentsDir;
  if(lComponentCategory == CXDefinitions::ECustomComponent) lDirectory += cCustomComponentsDir;
  lDirectory += "/";
  return lDirectory;
}

void CXComponentManager::fProcessMessage(int lMessageType, int lRequestID, const QString& lInput, const QString& lComponentName, QString lMessage) {
  if(!mComponentContent.contains(lComponentName)) {
    emit sLogMessageRequest(5200006, QStringList() << lComponentName, QString());
    return;
  }
  QString lMessageIDString(QString::number(lRequestID));
  if(cMessageIDMaxLenght > lMessageIDString.length()) lMessageIDString.prepend(QString().fill('0', cMessageIDMaxLenght - lMessageIDString.length()));

  mComponentContent.value(lComponentName)->sMessageArrived(lMessageType, lMessageIDString, lInput,  lMessage);
}

void CXComponentManager::fProcessMessage(int lMessageType, int lRequestID, const QString& lInput, const QString& lComponentName, const QJsonValue& lValue) {
  if(!mComponentContent.contains(lComponentName)) {
    emit sLogMessageRequest(5200006, QStringList() << lComponentName, QString());
    return;
  }
  QString lMessageIDString(QString::number(lRequestID));
  if(cMessageIDMaxLenght > lMessageIDString.length()) lMessageIDString.prepend(QString().fill('0', cMessageIDMaxLenght - lMessageIDString.length()));
  QVariantList lList(mComponentContent.value(lComponentName)->fJsonToList(lValue));
  mComponentContent.value(lComponentName)->sMessageArrivedJson(lMessageType, lMessageIDString, lInput, lList);
}

void CXComponentManager::fScaleComponents() {
  QMapIterator<QString, GXSubWindow*> i(mComponents);
  while(i.hasNext()) {
    i.next();
    i.value()->tScale();
  }
}
/*
void CXComponentManager::fMoveBottomBorder() {
  QMapIterator<QString, GXSubWindow*> i(mComponents);
  while(i.hasNext()) {
    i.next();
    i.value()->tMoveBottomBorder();
  }
}

void CXComponentManager::fMoveRightBorder() {
  QMapIterator<QString, GXSubWindow*> i(mComponents);
  while(i.hasNext()) {
    i.next();
    i.value()->tMoveRightBorder();
  }
}*/

void CXComponentManager::fRegisterComponent(const QString& lComponentName, QObject* lComponent, QObject* lComponentContent) {
  GXSubWindow* pComponent = qobject_cast<GXSubWindow*> (lComponent);
  GXComponent* pComponentContent = qobject_cast<GXComponent*> (lComponentContent);
  if(!pComponent || !pComponentContent) emit sLogMessageRequest(3200017, QStringList() << lComponentName, QString());
  else {
    mComponents.insert(lComponentName, pComponent);
    mComponentContent.insert(lComponentName, pComponentContent);
    BXGuiApplication::instance()->fRegisterComponent(pComponentContent);
    connect(pComponentContent, &GXComponent::sRawCallRequested, this, &CXComponentManager::sRawCallRequested);
  }
}

void CXComponentManager::fSetActiveComponent(const QString& lComponentName) {
  QMapIterator<QString, GXSubWindow* > i(mComponents);
  while(i.hasNext()) {
    i.next();
    if(i.key() == lComponentName)
      i.value()->tSetActive(true);
    else
      i.value()->tSetActive(false);
  }
}

