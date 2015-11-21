#ifndef BXGUIAPPLICATION_H
#define BXGUIAPPLICATION_H

#include <QGuiApplication>
#include <QNetworkAccessManager>
#include <QObject>
#include <CXDefinitions.h>

#include "HXCore.h"

class GXComponent;

class WFCORE_EXPORT BXGuiApplication : public QGuiApplication
{
  Q_OBJECT

  public:
    explicit BXGuiApplication(int& lArgc, char** pArgv);
    virtual ~BXGuiApplication();

    static BXGuiApplication* instance() { return rSelf; }
    static QString fComponentSetting(const QString& lComponent, const QString& lParameter);
    static QString fDaemonSetting(const QString& lDaemon, const QString& lParameter);
    static QString fDefaultDaemon() { return cDefaultDaemon; }
    virtual void fRegisterComponent(GXComponent* pComponent) = 0;
    QString fImageFile(const QString& lImageName) const;

  protected:
    QNetworkAccessManager* rNetworkAccess;
    CXDefinitions mDefinitions;

  private:
    static BXGuiApplication* rSelf;
};

#endif
