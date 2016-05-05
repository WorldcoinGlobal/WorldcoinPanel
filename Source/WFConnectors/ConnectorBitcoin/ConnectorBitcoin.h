#ifndef CONNECTORBITCOIN_H
#define CONNECTORBITCOIN_H

#include <QObject>
#include <QString>
#include <BXCryptoConnector.h>

class QProcess;
class ConnectorBitcoin : public BXCryptoConnector {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.ConnectorBitcoin/1.0.0")

  public:
    ~ConnectorBitcoin();

    int fKey() const { return 1; }
    void fSetup();
    int fStatus() const { return mStatus; }
    const QString fConfigFile() const { return "bitcoin.conf"; }
    const QString fLabel() const { return "Bitcoin";}
    const QString fName() const { return "BTC";}
    const QString fTestConnectionCommand() const { return "getbalance";}
};

#endif // CONNECTORBITCOIN_H
