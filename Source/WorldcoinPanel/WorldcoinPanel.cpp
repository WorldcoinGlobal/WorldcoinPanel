#include <QGuiApplication>
#include <QObject>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>
#include <QQuickWindow>
#include <QSettings>
#include <QSize>
#include <QTimer>
#include <CXDefinitions.h>
#include <GXGuiApplication.h>
#include <CXModulePanel.h>
#include <BXRunGuard.h>

int main(int lArgc, char** pArgv) {
  BXRunGuard lGuard("_SuperKey");
  if(!lGuard.fTryToRun() )
    return 0;

  GXGuiApplication lApp(lArgc, pArgv);
  lApp.tInit();
  int lRetCode = lApp.exec();
  return lRetCode;
}

