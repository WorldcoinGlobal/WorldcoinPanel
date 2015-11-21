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

  public slots:
    void tInit();

  protected:
    bool fStartDaemons();
    void fInitModels();
    void fCheckMaxLines();
    void fRegisterComponent(GXComponent* pComponent);
    void fRegisterObjects();
    void fSaveMessage(const CXMessage& lMessage);
    bool eventFilter(QObject* pObj, QEvent* pEvent);

  protected slots:
    bool tLoadConnectors(const QString& lDirName);
    bool tLoadWapptoms(const QString& lDirName);
    void tCheckUpdates();
    void tOnClose();    
    void tLogMessage(int lCode, const QStringList& lParameters, const QString& lCustomText, int lLogType = CXDefinitions::ELogAll);
    void tLogMessage(int lCode, const QString& lParameter = QString(), const QString& lCustomText = QString());
    void tUpdateStatusText(int lCode, const QStringList& lParameters = QStringList());
    void tUpdateDaemonStatus(const QString& lConnectorName, int lDaemonStatus);
    void tRequesUpdateWapptomValue(const QString& lWapptomName);
    void tUpdateValue(bool lSuccess, quint64 lRequestID, const QString& lValue);
    void tUpdateValueJson(bool lSuccess, quint64 lRequestID, const QJsonValue& lValue);
    void tRequestRawCall(const QString& lConnector, const QString& lRawRequest, const QString& lComponentName, bool lParse = true, int lLogType = CXDefinitions::ELogAll);
    void tProcessNetworkRequest();

  private:
    quint64 mRequestID;
    CXStatus mStatus;
    CXComponentManager mComponentManager;
    CXPulzarConnector mPulzarConnector;
    QFile mLogFile;
    QQmlEngine mEngine;
    GXWindow* rSplashWindow;
    GXWindow* rMainWindow ;
    CXItemModel* rLogModel;
    CXItemModelProxy* rLogProxyModel;
    QMap<QString, QSharedPointer<BXCryptoConnector> > mConnectors;
    QMap<QString, QSharedPointer<BXWapptom> > mWapptoms;
    QMap<quint64, SXRequest> mPendingRequests;
    QTimer mCheckUpdates;
};

#endif // GXGUIAPPLICATION_H
