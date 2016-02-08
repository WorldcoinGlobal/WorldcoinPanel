#include <QFile>
#include <QSettings>

#include "BXGuiApplication.h"

BXGuiApplication* BXGuiApplication::rSelf = 0;

BXGuiApplication::BXGuiApplication(int& lArgc, char** pArgv)
                : QApplication(lArgc, pArgv) {
  rNetworkAccess = new QNetworkAccessManager(this);
  rSelf = this;
}

BXGuiApplication::~BXGuiApplication() {
  rSelf = 0;
}

QString BXGuiApplication::fComponentSetting(const QString& lComponent, const QString &lParameter) {
  QSettings lSettings(cComponentsConfig, QSettings::IniFormat);
  lSettings.beginGroup(lComponent);
  QString lValue(lSettings.value(lParameter).toString());
  lSettings.endGroup();
  return lValue;
}

QString BXGuiApplication::fDaemonSetting(const QString& lDaemon, const QString &lParameter) {
  QSettings lSettings(cDaemonsConf, QSettings::IniFormat);
  lSettings.beginGroup(lDaemon);
  QString lValue(lSettings.value(lParameter).toString());
  lSettings.endGroup();
  return lValue;
}

QString BXGuiApplication::fImageFile(const QString& lImageName) const {
  QFile lFile(QString("%1/WFUserInterface/%2/Images/%3").arg(qApp->applicationDirPath()).arg(mDefinitions.fTheme()).arg(lImageName));
  if(lFile.exists()) return lFile.fileName();
  return QString();
}
