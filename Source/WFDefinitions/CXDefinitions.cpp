#include <QSettings>

#include "CXDefinitions.h"

CXDefinitions::CXDefinitions(QObject* pParent) : QObject(pParent) {
  QSettings lSettings(cDefaultConfig, QSettings::IniFormat);
  lSettings.beginGroup("UI");
  mTheme = lSettings.value("Theme", cDefaultTheme).toString();
  mZoomFactor = lSettings.value("ZoomFactor", cDefaultZoomFactor).toString();
  mWidth = lSettings.value("MainWindowWidth", -1).toDouble();
  mHeight = lSettings.value("MainWindowHeight", -1).toDouble();
  mX = lSettings.value("MainWindowX", -1).toInt();
  mY = lSettings.value("MainWindowY", -1).toInt();
  mAnimationDuration = lSettings.value("AnimationDuration", cAnimationDuration).toString();
  mMinimizeOnClose = lSettings.value("MinimizeOnClose", "").toString();
  lSettings.endGroup();
  lSettings.beginGroup("Version");
  mCurrentVersion = WORLDCOINPANEL_VERSION; //lSettings.value("CurrentVersion").toString();
  mCurrentVersionName = lSettings.value("CurrentVersionName").toString();
  lSettings.endGroup();
  lSettings.beginGroup("Log");
  mSaveLog = lSettings.value("SaveLog", cDefaultSaveLog).toBool();
  mPanelMaxLines = lSettings.value("PanelMaxLines", cDefaultPanelMaxLines).toInt();
  lSettings.endGroup();
  lSettings.beginGroup("Servers");
  mPulzarHost = lSettings.value("PulzarHost").toString();
  mPulzarPort = lSettings.value("PulzarPort", "0").toInt();
  lSettings.endGroup();
  lSettings.beginGroup("Update");
  mUpdateCheckPeriod = lSettings.value("Period", cDefaultUpdatesCheckPeriod).toString();
  mUpdateChannel = lSettings.value("Channel", cDefaultChannel).toString();
  mRegion = lSettings.value("Region", cDefaultRegion).toString();
  lSettings.endGroup();

}

CXDefinitions::~CXDefinitions() {

}

QString CXDefinitions::fCanonicalPath(const QString& lDir, bool lReturnStandard) {
  QString lNormalizedDir(lDir);
  QString lPref;
  if(fCurrentOS() == CXDefinitions::ELinuxOS) lPref = ("file://");
  if(fCurrentOS() == CXDefinitions::EWindowsOS) lPref = ("file:///");
  lNormalizedDir.remove(lPref);
  QDir lPath(lNormalizedDir);
  if(lReturnStandard) return QString("%1").arg(lPath.canonicalPath());
  return QString("%1%2").arg(lPref).arg(lPath.canonicalPath());
}

int CXDefinitions::fCurrentOS() {
  #if defined(Q_OS_WIN32)
    return EWindowsOS;
  #endif
  #if defined(Q_OS_LINUX)
    return ELinuxOS;
  #endif
}

QString CXDefinitions::fCompressVersion(const QString& lVersion) {
  QStringList lValues = lVersion.split(".");
  Q_ASSERT(lValues.size() == 3);
  int lMayor = lValues.at(0).toInt();
  int lMinor = lValues.at(1).toInt();
  int lBugs = lValues.at(2).toInt();
  lValues[0] = QString::number(lMayor);
  lValues[1] = QString::number(lMinor);
  lValues[2] = QString::number(lBugs);
  return lValues.join(".");
}

QString CXDefinitions::fExtendVersion(const QString& lVersion)
{
  QStringList lValues = lVersion.split(".");
  Q_ASSERT(lValues.size() == 3);
  if(lValues.at(0).size() == 1) lValues[0].prepend("0");
  if(lValues.at(1).size() == 1) lValues[1].prepend("0");
  if(lValues.at(2).size() == 1) lValues[2].prepend("0");
  return lValues.join(".");
}

void CXDefinitions::fSaveSettings(){
  QSettings lSettings(cDefaultConfig, QSettings::IniFormat);
  lSettings.beginGroup("UI");
  lSettings.setValue("AnimationDuration", mAnimationDuration);
  lSettings.setValue("Theme", mTheme);
  lSettings.setValue("ZoomFactor", mZoomFactor);
  lSettings.setValue("MainWindowWidth", mWidth);
  lSettings.setValue("MainWindowHeight", mHeight);
  lSettings.setValue("MainWindowX", mX);
  lSettings.setValue("MainWindowY", mY);
  lSettings.setValue("MinimizeOnClose", mMinimizeOnClose);
  lSettings.endGroup();
  lSettings.beginGroup("Version");
  lSettings.setValue("CurrentVersion", mCurrentVersion);
  lSettings.setValue("CurrentVersionName", mCurrentVersionName);
  lSettings.endGroup();
  lSettings.beginGroup("Log");
  lSettings.setValue("SaveLog", mSaveLog);
  lSettings.setValue("PanelMaxLines", mPanelMaxLines);
  lSettings.endGroup();
  lSettings.beginGroup("Update");
  lSettings.setValue("Period", mUpdateCheckPeriod);
  lSettings.setValue("Channel", mUpdateChannel);
  lSettings.setValue("Region", mRegion);
  lSettings.endGroup();

}
