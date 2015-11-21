#ifndef CONNECTORWORLDCOIN_H
#define CONNECTORWORLDCOIN_H

#include <QObject>
#include <QString>
#include <BXCryptoConnector.h>

class QProcess;
class ConnectorWorldcoin : public BXCryptoConnector {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.ConnectorWorldcoin/1.0.0")

  public:
    ~ConnectorWorldcoin();

    int fKey() const { return 1; }
    void fSetup();
    int fStatus() const { return mStatus; }
    const QString fConfigFile() const { return "worldcoin.conf"; }
    const QString fLabel() const { return "Worldcoin";}
    const QString fName() const { return "WDC";}
    const QString fTestConnectionCommand() const { return "getbalance";}
};

#endif // CONNECTORWORLDCOIN_H
