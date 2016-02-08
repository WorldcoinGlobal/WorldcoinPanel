#ifndef CXPULZARCONNECTOR_H
#define CXPULZARCONNECTOR_H

#include <QObject>
#include <QTimer>
#include <QVariantMap>
#include <QVariantList>
#include <QWebSocket>
#include <CXDefinitions.h>

#include "HXCore.h"

class WFCORE_EXPORT CXPulzarConnector : public QObject {
  Q_OBJECT
  Q_PROPERTY(int mConnectionStatus READ fConnectionStatus WRITE tSetConnectionStatus NOTIFY sConnectionStatusChanged)
  Q_PROPERTY(QString mConnectionID READ fConnectionID WRITE tSetConnectionID NOTIFY sConnectionIDChanged)
  Q_PROPERTY(QString mUpdatePriority READ fUpdatePriority WRITE tSetUpdatePriority NOTIFY sUpdatePriorityChanged)
//  Q_PROPERTY(QString mUpdateChannel READ fUpdateChannel WRITE tSetUpdateChannel NOTIFY sUpdateChannelChanged)

  public:
    explicit CXPulzarConnector(QObject* pParent = 0);
    ~CXPulzarConnector();

    Q_INVOKABLE QVariantMap fVersionName() { return mVersionName; }
    Q_INVOKABLE QVariantMap fVersionLog() { return mVersionLog; }
    Q_INVOKABLE QString fConnectionID() const { return mConnectionID; }
    Q_INVOKABLE QString fUpdatePriority() const { return mUpdatePriority; }
//    Q_INVOKABLE QString fUpdateChannel() const { return mUpdateChannel; }
    Q_INVOKABLE QString fLastVersion() const;

    int fConnectionStatus() const { return mConnectionStatus; }
    void fSetPort(int lPort) { mPort = lPort; }
    void fSetServer(const QString& lServer) { mServer = lServer; }
    void fSetRetryPeriod(int lRetryPeriod = 0);

  public slots:
    void tSetConnectionStatus(int lConnectionStatus);
    void tSetConnectionID(const QString& lConnectionID);
    void tSetUpdatePriority(const QString& lUpdatePriority);
  //  void tSetUpdateChannel(const QString& lUpdateChannel);
    void tConnect();
    void tCheckUpdates(const QString& lCurrentVersion, const QString& lRegion, const QString& lChannel);

  protected slots:
    void tOnConnected();
    void tOnDisconnected();
    void tOnMessageReceived(QString lMessage);
    void tOnSocketError(QAbstractSocket::SocketError lError);
    void tOnSslErrors(const QList<QSslError> &lErrors);

  protected:
    int mConnectionStatus;
    QString mConnectionID;
    QString mUpdatePriority;
   // QString mUpdateChannel;

  private:
    QWebSocket mWebSocket;
    QString mServer;
    QTimer mRetryTimer;
    QVariantMap mUpdateFiles; // Object Name - Size, Hash, Relative Direcotry, File Name
    QVariantMap mVersionLog; // Version - Log Entry
    QVariantMap mVersionName; // Version - Name

    int mPort;
    int mRetryPeriod;

  signals:
    void sConnectionStatusChanged();
    void sConnectionIDChanged();
    void sUpdatePriorityChanged();
  //  void sUpdateChannelChanged();
    void sLogMessageRequest(int lCode, const QString& lParameter = QString(), const QString& lCustomText = QString());
    void sVersionLogChanged();
};

#endif
