#ifndef BXGUIAPPLICATION_H
#define BXGUIAPPLICATION_H

#include <QApplication>
#include <QNetworkAccessManager>
#include <QObject>
#include <CXDefinitions.h>

#include "HXCore.h"

class GXComponent;

class WFCORE_EXPORT BXGuiApplication : public QApplication
{
  Q_OBJECT

  public:
    explicit BXGuiApplication(int& lArgc, char** pArgv);
    virtual ~BXGuiApplication();

    static BXGuiApplication* fInstance() { return rSelf; }
    static QString fComponentSetting(const QString& lComponent, const QString& lParameter);
    static QString fDaemonSetting(const QString& lDaemon, const QString& lParameter);
    virtual void fRegisterComponent(GXComponent* pComponent) = 0;
    virtual void fUpdateStatusText(int lCode, const QStringList& lParameters = QStringList()) = 0;
    QString fImageFile(const QString& lImageName) const;

  protected:
    QNetworkAccessManager* rNetworkAccess;
    CXDefinitions mDefinitions;

  private:
    static BXGuiApplication* rSelf;

  public slots:
    virtual void fOnClose() = 0;
    virtual void fLogMessage(int lCode, const QStringList& lParameters, const QString& lCustomText, int lLogType = CXDefinitions::ELogAll) = 0;
    virtual void fLogMessage(int lCode, const QString& lParameter = QString(), const QString& lCustomText = QString()) = 0;
    virtual void fExecuteWizard() = 0;

  signals:
    void sStatusTextChanged(const QString& lStatusText);
};

#endif
