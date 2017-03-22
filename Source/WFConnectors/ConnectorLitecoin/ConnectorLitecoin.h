#ifndef CONNECTORLITECOIN_H
#define CONNECTORLITECOIN_H

#include <QObject>
#include <QString>
#include <BXCryptoConnector.h>

class QProcess;
class ConnectorLitecoin : public BXCryptoConnector {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.ConnectorLitecoin/1.0.0")

  public:
    ~ConnectorLitecoin();

    int fKey() const { return 1; }
    void fSetup();
  //  int fStatus() const { return mStatus; }
    const QString fConfigFile() const { return "litecoin.conf"; }
    const QString fLabel() const { return "Litecoin";}
    const QString fName() const { return "LTC";}
    const QString fTestConnectionCommand() const { return "getbalance";}
    QStringList fStartupParameters() const { return QStringList() << QString("-conf=%1/%2").arg(mDataDirectory).arg(fConfigFile()) << QString("-datadir=%1").arg(mDataDirectory) << QString("-rpcwait") << QString("-prune=550"); }
    QString fDefaultBalanceMinConfirmations() const { return "1"; }
    QString fDefaultBinaryName() const { return "litecoind"; }
    QString fDefaultClientName() const { return "litecoin-cli"; }
    QString fDefaultDataDirectory() const {
      if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) return "C:/Blockchain/LitecoinChain";
      else return QString("%1/Blockchain/LitecoinChain").arg(QDir::homePath());
    }
    QString fDefaultEnabled() const { return "0"; }
    QString fDefaultLockFile() const { return ".lock"; }
    QString fDefaultPassword() const { return "jkh789hph8GHU898ll0"; }
    QString fDefaultPidFile() const { return "litecoind.pid"; }
    QString fDefaultPort() const { return "9333"; }
    QString fDefaultRpcPort() const { return "9332"; }
    QString fDefaultUser() const { return "Worldcoiner"; }
};

#endif // CONNECTORLITECOIN_H
