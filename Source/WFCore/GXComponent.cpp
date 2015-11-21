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

QString GXComponent::fSetting(const QString& lParameter) const {
  return BXGuiApplication::fComponentSetting(fName(), lParameter);
}

QString GXComponent::fImageFile(const QString& lImageName) const {
  return BXGuiApplication::instance()->fImageFile(lImageName);
}

void GXComponent::fQuitApplication() {
  BXGuiApplication::quit();
}

void GXComponent::tSetSetting(const QString& lSetting, const QString& lValue) {
  QSettings lSettings(cComponentsConfig, QSettings::IniFormat);
  lSettings.beginGroup(fName());
  lSettings.setValue(lSetting, lValue);
  lSettings.endGroup();
}
