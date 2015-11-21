#ifndef CXRCPCLIENT_H
#define CXRCPCLIENT_H

#include <qjsonrpchttpclient.h>

class QNetworkReply;
class QAuthenticator;
class CXRcpClient : public QJsonRpcHttpClient
{
  Q_OBJECT

  public:
    CXRcpClient(const QString& lEndpoint, const QString& lUser, const QString& lPassword, QObject* pParent = 0);


  private Q_SLOTS:
    virtual void handleAuthenticationRequired(QNetworkReply* pReply, QAuthenticator* pAuthenticator);

  private:
    QString mUsername;
    QString mPassword;

};
#endif // CXRCPCLIENT_H
