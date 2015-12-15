#include <QCoreApplication>
#include <QCursor>
#include <QJsonArray>
#include <QJsonValue>
#include <QSettings>
#include <CXDefinitions.h>

#include "GXComponent.h"
#include "BXGuiApplication.h"

GXComponent::GXComponent(QQuickItem* lParent )
           : QQuickItem(lParent)  {
  setClip(true);
  mStatus = true;
}

QVariantList GXComponent::fJsonToList(const QJsonValue& lJsonValue) const {
  QJsonArray lJsonArray(lJsonValue.toArray());
  QVariantList lList(lJsonArray.toVariantList());
  return lList;
}

void GXComponent::fRawCallRequested(const QString& lConnector, const QString& lRawRequest, bool lParse, int lLogType) {
  if(!lRawRequest.simplified().isEmpty())
    emit sRawCallRequested(lConnector, lRawRequest, mName, lParse, lLogType);
}

QString GXComponent::fSetting(const QString& lSetting, bool lUseDaemonConf, const QString& lConnector) const {
  QString lConnectorName = lConnector;
  if(lUseDaemonConf) {
    if(lConnector.simplified().isEmpty()) lConnectorName = cDefaultDaemon;
    QSettings lSettings(qApp->applicationDirPath() + "/" + cDaemonsConf, QSettings::IniFormat);
    lSettings.beginGroup(lConnectorName);
    QString lValue = lSettings.value(lSetting).toString();
    return lValue;
  }
  return BXGuiApplication::fComponentSetting(fName(), lSetting);
}

QString GXComponent::fImageFile(const QString& lImageName) const {
  return BXGuiApplication::fInstance()->fImageFile(lImageName);
}

void GXComponent::fQuitApplication() {
  BXGuiApplication::quit();
}

void GXComponent::fSetSetting(const QString& lSetting, const QString& lValue, bool lUseDaemonConf, const QString& lConnector) {
  QString lConnectorName = lConnector;
  if(lUseDaemonConf) {
    if(lConnector.simplified().isEmpty()) lConnectorName = cDefaultDaemon;
    QSettings lSettings(qApp->applicationDirPath() + "/" + cDaemonsConf, QSettings::IniFormat);
    lSettings.beginGroup(lConnectorName);
    lSettings.setValue(lSetting, lValue);
    lSettings.endGroup();
  }
  else {
    QSettings lSettings(qApp->applicationDirPath() + "/" + cComponentsConfig, QSettings::IniFormat);
    lSettings.beginGroup(fName());
    lSettings.setValue(lSetting, lValue);
    lSettings.endGroup();
  }
}
