#include <QCoreApplication>
#include <QCursor>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QSettings>
#include <QVariantMap>
#include <CXDefinitions.h>

#include "GXComponent.h"
#include "BXGuiApplication.h"

GXComponent::GXComponent(QQuickItem* lParent )
           : QQuickItem(lParent)  {
  setClip(true);
  mStatus = true;
}

QVariantList GXComponent::fJsonToList(const QJsonValue& lJsonValue) const {
  QVariantList lList;
  if(lJsonValue.isArray()) {
    QJsonArray lJsonArray(lJsonValue.toArray());
    lList = lJsonArray.toVariantList();
  }
  if(lJsonValue.isObject()) {
    QJsonObject lJsonObject(lJsonValue.toObject());
    QVariantMap lMap(lJsonObject.toVariantMap());
    QMapIterator<QString, QVariant> i(lMap);
    while (i.hasNext()) {
      i.next();
      lList.append(QString("%1|%2").arg(i.key()).arg(i.value().toString()));
    }
  }
  if(lJsonValue.isString()) {
    QString lString(lJsonValue.toString());
    lList.append(lString);
  }
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
