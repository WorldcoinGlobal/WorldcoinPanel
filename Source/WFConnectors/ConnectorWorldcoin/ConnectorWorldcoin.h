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
  //  int fStatus() const { return mStatus; }
    const QString fConfigFile() const { return "worldcoin.conf"; }
    const QString fLabel() const { return "Worldcoin";}
    const QString fName() const { return "WDC";}
    const QString fTestConnectionCommand() const { return "getbalance";}
    QStringList fStartupParameters() const { return QStringList() << QString("-conf=%1/%2").arg(mDataDirectory).arg(fConfigFile()) << QString("-datadir=%1").arg(mDataDirectory) << QString("-rpcwait"); }
    QString fDefaultBalanceMinConfirmations() const { return "1"; }
    QString fDefaultBinaryName() const { return "WorldcoinDaemon"; }
    QString fDefaultClientName() const { return "WorldcoinDaemon"; }
    QString fDefaultDataDirectory() const {
      if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) return "C:/Blockchain/WorldcoinChain";
      else return QString("%1/Blockchain/WorldcoinChain").arg(QDir::homePath());
    }
    QString fDefaultEnabled() const { return "1"; }
    QString fDefaultLockFile() const { return ".lock"; }
    QString fDefaultPassword() const { return "07Fvbtb$234vvrD56e"; }
    QString fDefaultPidFile() const { return "worldcoind.pid"; }
    QString fDefaultPort() const { return "11081"; }
    QString fDefaultRpcPort() const { return "11082"; }
    QString fDefaultUser() const { return "Worldcoiner"; }
};

#endif // CONNECTORWORLDCOIN_H
