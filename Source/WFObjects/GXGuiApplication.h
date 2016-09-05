#ifndef GXGUIAPPLICATION_H
#define GXGUIAPPLICATION_H

#include <QFile>
#include <QGuiApplication>
#include <QMap>
#include <QNetworkReply>
#include <QObject>
#include <QQmlEngine>
#include <QSharedPointer>
#include <QStringList>
#include <QSystemTrayIcon>
#include <QTimer>
#include <CXDefinitions.h>
#include <CXMessage.h>
#include <BXCryptoConnector.h>
#include <BXWapptom.h>
#include <HXStructs.h>
#include <GXSubWindow.h>
#include <BXGuiApplication.h>
#include <CXComponentManager.h>
#include <CXPulzarConnector.h>

#include "CXStatus.h"
#include "CXConnectorManager.h"
#include "HXObjects.h"

class GXComponent;
class QEvent;
class GXWindow;
class CXItemModel;
class CXItemModelProxy;

class WFOBJECTS_EXPORT GXGuiApplication : public BXGuiApplication
{
  Q_OBJECT

  public:
    explicit GXGuiApplication(int& lArgc, char** pArgv);
     ~GXGuiApplication();

    bool fPendingRequests(bool lLocalOnly = false);
    void fUpdateStatusText(int lCode, const QStringList& lParameters = QStringList());

  public slots:
    void fInit();
    void fLogMessage(int lCode, const QStringList& lParameters, const QString& lCustomText, int lLogType = CXDefinitions::ELogAll);
    void fLogMessage(int lCode, const QString& lParameter = QString(), const QString& lCustomText = QString());
    void fExecuteWizard();

  protected:
    void fInitModels();
    void fCheckMaxLines();
    void fRegisterComponent(GXComponent* pComponent);
    void fRegisterObjects();
    void fSaveMessage(const CXMessage& lMessage);    

    bool eventFilter(QObject* pObj, QEvent* pEvent); // Otherwise components created accept key events

  protected slots:
    bool fLoadConnectors(const QString& lDirName);
    bool fLoadWapptoms(const QString& lDirName);
    void fCheckUpdates();
    void fOnClose();    
    void fProcessNetworkRequest();
    void fRaisePanel(QSystemTrayIcon::ActivationReason eReason);
    void fRequestRawCall(const QString& lConnector, const QString& lRawRequest, const QString& lComponentName, bool lParse = true, int lLogType = CXDefinitions::ELogAll);
    void fRequestUpdateWapptomValue(const QString& lWapptomName);
    void fUpdateTrayIconStatus();
    void fUpdateValue(bool lSuccess, quint64 lRequestID, const QString& lValue);
    void fUpdateValueJson(bool lSuccess, quint64 lRequestID, const QJsonValue& lValue);    

  private:
    quint64 mRequestID;
    QString mDefaultDaemonStatusText;
   // CXStatus mStatus;
    CXComponentManager mComponentManager;
    CXPulzarConnector mPulzarConnector;
    CXConnectorManager mConnectorManager;
    QFile mLogFile;
    QQmlEngine mEngine;
    GXWindow* rSplashWindow;
    GXWindow* rMainWindow ;    
    CXItemModel* rLogModel;
    CXItemModelProxy* rLogProxyModel;
  //  QMap<QString, QSharedPointer<BXCryptoConnector> > mConnectors;
    QMap<QString, QSharedPointer<BXWapptom> > mWapptoms;
    QMap<quint64, SXRequest> mPendingRequests;
    QTimer mCheckUpdates;
    QSystemTrayIcon* rTrayIcon;

};

#endif // GXGUIAPPLICATION_H
