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
  //  int fStatus() const { return mStatus; }
    const QString fConfigFile() const { return "bitcoin.conf"; }
    const QString fLabel() const { return "Bitcoin";}
    const QString fName() const { return "BTC";}
    const QString fTestConnectionCommand() const { return "getbalance";}
    QStringList fStartupParameters() const { return QStringList() << QString("-conf=%1/%2").arg(mDataDirectory).arg(fConfigFile()) << QString("-datadir=%1").arg(mDataDirectory) << QString("-rpcwait") << QString("-prune=550"); }
    QString fDefaultBalanceMinConfirmations() const { return "1"; }
    QString fDefaultBinaryName() const { return "bitcoind"; }
    QString fDefaultClientName() const { return "bitcoin-cli"; }
    QString fDefaultDataDirectory() const {
      if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) return "C:/Blockchain/BitcoinChain";
      else return "~/Blockchain/BitcoinChain";
    }
    QString fDefaultEnabled() const { return "0"; }
    QString fDefaultLockFile() const { return ".lock"; }
    QString fDefaultPassword() const { return "0rhnv3fFSFD44gt"; }
    QString fDefaultPidFile() const { return "bitcoind.pid"; }
    QString fDefaultPort() const { return "8883"; }
    QString fDefaultRpcPort() const { return "8882"; }
    QString fDefaultUser() const { return "Worldcoiner"; }
};

#endif // CONNECTORBITCOIN_H
