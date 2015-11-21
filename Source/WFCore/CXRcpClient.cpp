#include <HXDefinitions.h>
#include <QAuthenticator>
#include <QNetworkReply>

#include "CXRcpClient.h"

CXRcpClient::CXRcpClient(const QString& lEndpoint, const QString& lUser, const QString& lPassword, QObject* pParent) :
             QJsonRpcHttpClient(lEndpoint, pParent), mUsername(lUser), mPassword(lPassword) {

}

void CXRcpClient::handleAuthenticationRequired(QNetworkReply* /*pReply*/, QAuthenticator* pAuthenticator) {
  pAuthenticator->setUser(mUsername);
  pAuthenticator->setPassword(mPassword);
}
