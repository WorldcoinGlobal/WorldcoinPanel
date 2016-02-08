#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkInterface>
#include <QUrl>

#include "CXPulzarConnector.h"

CXPulzarConnector::CXPulzarConnector(QObject* pParent)
                 : QObject(pParent), mConnectionStatus(CXDefinitions::EServiceStopped), mPort(0) {
  fSetRetryPeriod(cDefaultServicesRetryPeriod);
  connect(&mWebSocket, &QWebSocket::connected, this, &CXPulzarConnector::tOnConnected);
  connect(&mWebSocket, &QWebSocket::disconnected, this, &CXPulzarConnector::tOnDisconnected);
  connect(&mWebSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(tOnSocketError(QAbstractSocket::SocketError)));
  connect(&mWebSocket, &QWebSocket::textMessageReceived,this, &CXPulzarConnector::tOnMessageReceived);
  connect(&mWebSocket, SIGNAL(sslErrors(QList<QSslError>)), this, SLOT(tOnSslErrors(QList<QSslError>)));
  connect(&mRetryTimer, &QTimer::timeout, this, &CXPulzarConnector::tConnect);
}

CXPulzarConnector::~CXPulzarConnector() {

}

QString CXPulzarConnector::fLastVersion() const {
  if(mVersionLog.count())
    return mVersionLog.lastKey();
  return QString("00.00.00");
}

void CXPulzarConnector::tSetConnectionStatus(int lConnectionStatus) {
  mConnectionStatus = lConnectionStatus;
  emit sConnectionStatusChanged();
}

void CXPulzarConnector::tSetConnectionID(const QString& lConnectionID) {
  mConnectionID = lConnectionID;
  emit sConnectionIDChanged();
}

/*void CXPulzarConnector::tSetUpdateChannel(const QString& lUpdateChannel) {
  mUpdateChannel = lUpdateChannel;
  emit sUpdateChannelChanged();
}*/

void CXPulzarConnector::tSetUpdatePriority(const QString& lUpdatePriority) {
  mUpdatePriority = lUpdatePriority;
  emit sUpdatePriorityChanged();
}

void CXPulzarConnector::tCheckUpdates(const QString &lCurrentVersion, const QString &lRegion, const QString &lChannel) {
  QJsonObject lJsonData;
  lJsonData["CurrentVersion"] = lCurrentVersion;
  lJsonData["Action"] = "GetLastVersionFileDetail";
  lJsonData["Region"] = lRegion;
  lJsonData["Platform"] = QString::number(CXDefinitions::fCurrentOS());
  lJsonData["Channel"] = lChannel;

  QJsonObject lJsonUpdates;
  lJsonUpdates["Updater"] = lJsonData;

  QJsonDocument lJsonDoc(lJsonUpdates);
  mWebSocket.sendTextMessage(QString(lJsonDoc.toJson()));
}

void CXPulzarConnector::tConnect() {
  if(mPort == 0 || mServer.isEmpty()) {
    tSetConnectionStatus(CXDefinitions::EServiceError);
    emit sLogMessageRequest(5200011, tr("Pulzar Services. Server: '%1'. Port: '%2'").arg(mServer).arg(QString::number(mPort)));
    return;
  }
  if((mConnectionStatus == CXDefinitions::EServiceStopped) || (mConnectionStatus == CXDefinitions::EServiceError)) {
    QUrl lPulzar(QString("wss://%1:%2").arg(mServer).arg(QString::number(mPort)));
    mWebSocket.open(lPulzar);
    tSetConnectionStatus(CXDefinitions::EServiceProcessing);
  }
}

void CXPulzarConnector::fSetRetryPeriod(int lRetryPeriod) {
  mRetryPeriod = lRetryPeriod;
  if(!lRetryPeriod) mRetryTimer.stop();
  else mRetryTimer.start(mRetryPeriod * 1000);
}

void CXPulzarConnector::tOnConnected() {
  /*      QFile file(":Resources/Keys/Cacert.pem");
      if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
      {
        txtMessages->append(tr("Unable to stream key !"));
        m_webSocket.close();
        return;
      }*/

   QNetworkInterface lIntfc;
   QList<QNetworkInterface> lIntfclist = QNetworkInterface::allInterfaces();
   QString lCurrentMAC, lCurrentIP;

   for(int i = 0; i < lIntfclist.size(); i++)
   {
     lIntfc = lIntfclist.at(i);
     if(!lIntfc.flags().testFlag(QNetworkInterface::IsLoopBack) && lIntfc.flags().testFlag(QNetworkInterface::IsRunning) && lIntfc.flags().testFlag(QNetworkInterface::IsUp)) {
       lCurrentMAC = lIntfc.hardwareAddress();
       break;
     }
   }
   for(int i = 0; i < lIntfc.addressEntries().size(); i++) {
     QNetworkAddressEntry lAddr = lIntfc.addressEntries().at(i);
     if((lAddr.ip() != QHostAddress::Null) && (lAddr.ip() != QHostAddress::LocalHost) && (lAddr.ip() != QHostAddress::LocalHostIPv6) &&
       (lAddr.ip() != QHostAddress::Broadcast) && (lAddr.ip() != QHostAddress::Any) && (lAddr.ip() != QHostAddress::AnyIPv6)) {
       if(lAddr.ip().protocol() == QAbstractSocket::IPv4Protocol) {
         lCurrentIP = lAddr.ip().toString();
         break;
       }
     }
   }

    // QByteArray cert = file.readAll();
   QByteArray lCertBase64("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUQ1VENDQXMyZ0F3SUJBZ0lKQUxCdXgrcXRJanFxTUEwR0NTcUdTSWIzRFFFQkJRVUFNSUdJTVFzd0NRWUQKVlFRR0V3SkNUekVQTUEwR0ExVUVDQXdHVEdFZ1VHRjZNUTh3RFFZRFZRUUhEQVpNWVNCUVlYb3hHREFXQmdOVgpCQW9NRDFkdmNteGtZMjlwYmtkc2IySmhiREVPTUF3R0ExVUVBd3dGVUhWNllYSXhMVEFyQmdrcWhraUc5dzBCCkNRRVdIbTFoY21sdkxtSnNZV04xZEhSQWQyOXliR1JqYjJsdUxtZHNiMkpoYkRBZUZ3MHhOREV3TURRd05qVTIKTURaYUZ3MHhOekV3TURNd05qVTJNRFphTUlHSU1Rc3dDUVlEVlFRR0V3SkNUekVQTUEwR0ExVUVDQXdHVEdFZwpVR0Y2TVE4d0RRWURWUVFIREFaTVlTQlFZWG94R0RBV0JnTlZCQW9NRDFkdmNteGtZMjlwYmtkc2IySmhiREVPCk1Bd0dBMVVFQXd3RlVIVjZZWEl4TFRBckJna3Foa2lHOXcwQkNRRVdIbTFoY21sdkxtSnNZV04xZEhSQWQyOXkKYkdSamIybHVMbWRzYjJKaGJEQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU1qMApJbjlVVzZLMjFIM3FVeE1ONUJ0SUlhWDFqN0tZZlptTEYzbWN0RWh2OTJ5amhiQW44QVFkTUFYZ2lGeWljTUIrClhtM2tlTTVvM0c2ZlBMYnpTNU1WM3J1djJXWllmMnZDeVcxSXhRQS94cnk3VzRSeGhSWWN5SStsWlhES3Jqc2sKL3NpSWZ4VUJGMVNLSXQxY1E1Qmt3L3RyTHFsd3FsYTFSa0xLYkNJWkI5Z2J3SHNPR0VYNmhlRzZobXB5Q2k3UwpPQmRMZXBXVENNamZ4RHloVnFrdFVXcGtoQVVnazFadnpodVJ6T0NpN1VDOUtsbC9CdFZURkRmL3h5L0E2aVJPClR3U2RnZmVzMGhCL2E5SjBIZlA4Rk5OVGYzQzVKU2FwWDkrNTlKaVdaSVFaWmZ1MTRIM2g2QnhwU2J1RnlZb0QKZHpNMElwcE5MT2w5VEZZNU1PTUNBd0VBQWFOUU1FNHdIUVlEVlIwT0JCWUVGTkROME9ZY3RUa2c1ODVPazQ3VQpsZW0va3MrSk1COEdBMVVkSXdRWU1CYUFGTkROME9ZY3RUa2c1ODVPazQ3VWxlbS9rcytKTUF3R0ExVWRFd1FGCk1BTUJBZjh3RFFZSktvWklodmNOQVFFRkJRQURnZ0VCQUVKM29HclVuUzNHc3U0SGdwU1h4dnFtNTB6K0RHV2sKcTdlZjZNbWs1Q0ZPVUU3QW9neGU5MHAvTTZjZmxvbXN3QXVDWmowdEdrbC83YlFITzJxV3lSUXRQOTFoZ1JJWQpQL2RJakpmZFJVbjQ1TjBYY2JYMWgzUC9pQVpYTkVQZ3BSK0JkYWhTZFhJUWlxYVhESzgzVDNZdU9SV09qczN2CkU5aFlCYi9TWTBtN21KQkpxNVhjb1A5R3lEbVBmQXRoQ0g5Nm5zSmJoSEJsKzJNNTljQTNnWU5hTzVuelBFczAKZ05WaUMwU1ZUWVZIaVNuZGtZblAxeC9yUGVTaFhXVDIxYXorKzUwUmE4TGVIR1ZjcDhTajBxSWgwMDVDNU5Ecgo1R3FZbUUwL0pVZzltRWdlWlJTTGpvV2dWZEw0cmFURDBLVTYrRnp2ZWZyQkZzMk1mNXpNVFJNPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="); /*= cert.toBase64()*/;
   QJsonObject lJsonData;
   lJsonData["Certificate"] = QString(lCertBase64);
   lJsonData["IP"] = QString(lCurrentIP);
   lJsonData["MAC"] = QString(); //QString(lCurrentMAC);

   QJsonObject lJsonHandshake;
   lJsonHandshake["Handshake"] = lJsonData;

   QJsonDocument lJsonDoc(lJsonHandshake);
   mWebSocket.sendTextMessage(QString(lJsonDoc.toJson()));
}

void CXPulzarConnector::tOnDisconnected() {
  tSetConnectionStatus(CXDefinitions::EServiceStopped);
  emit sLogMessageRequest(4200005);
}

void CXPulzarConnector::tOnMessageReceived(QString lMessage) {
 //qDebug(lMessage.toLatin1());
  bool lUpdateChanged(false);
  QJsonDocument lDoc(QJsonDocument::fromJson(QByteArray(lMessage.toLatin1())));
  QJsonObject lObject(lDoc.object());
  QVariantMap lActions = lObject.toVariantMap();
  if(lActions.size() == 0) {
    emit sLogMessageRequest(5200012);
    tSetConnectionStatus(CXDefinitions::EServiceError);
    return;
  }

  QMapIterator<QString, QVariant> i(lActions);
  while (i.hasNext()) {
    i.next();
    if(i.key() == QString("ID")) {
      tSetConnectionStatus(CXDefinitions::EServiceReady);
      emit sLogMessageRequest(1200004, QString(), QString("ID: '%1'").arg(i.value().toString()));
      return;
    }
    if(i.key() == QString("UpdaterFile")) {
      lUpdateChanged = true;
      mUpdateFiles.clear();
      QVariantMap lFiles = i.value().toMap();
      QMapIterator<QString, QVariant> i1(lFiles);
      while(i1.hasNext()) {
        i1.next();
        QStringList lStringList = i1.value().toString().split("|");
        QVariantList lVariantList;
        if(!i1.hasNext()) {
        //  tSetUpdateChannel(lStringList.at(2));
          tSetUpdatePriority(lStringList.at(3));
        }
        lVariantList.append(lStringList.at(4));
        lVariantList.append(lStringList.at(5));
        lVariantList.append(lStringList.at(6));
        lVariantList.append(lStringList.at(7));
        mUpdateFiles[i1.key()] = lVariantList;
      }
    }
    if(i.key() == QString("VersionLog")) {
      lUpdateChanged = true;
      mVersionLog.clear();
      QVariantMap lLog = i.value().toMap();
      QMapIterator<QString, QVariant> i1(lLog);
      while(i1.hasNext()) {
        i1.next();
        //QStringList lStringList = i1.value().toString().split("|");
        QString lLog = i1.value().toString().replace("|", "\n");
        mVersionLog[i1.key()] = lLog;
      }
    }
    if(i.key() == QString("VersionName")) {
      lUpdateChanged = true;
      mVersionName.clear();
      QVariantMap lName = i.value().toMap();
      QMapIterator<QString, QVariant> i1(lName);
      while(i1.hasNext()) {
        i1.next();
        QString lName = i1.value().toString();
        mVersionName[i1.key()] = lName;
      }
    }
  }
  if(lUpdateChanged) emit sVersionLogChanged();
}

void CXPulzarConnector::tOnSocketError(QAbstractSocket::SocketError /*lError*/) {
  emit sLogMessageRequest(3200023, mWebSocket.errorString());
  tSetConnectionStatus(CXDefinitions::EServiceError);
}

void CXPulzarConnector::tOnSslErrors(const QList<QSslError>& /*lErrors*/) {
  mWebSocket.ignoreSslErrors();
}
