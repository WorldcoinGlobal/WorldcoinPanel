#ifndef CONNECTORDOGECOIN_H
#define CONNECTORDOGECOIN_H

#include <QObject>
#include <QString>
#include <BXCryptoConnector.h>

class QProcess;
class ConnectorDogecoin : public BXCryptoConnector {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.ConnectorDogecoin/1.0.0")

  public:
    ~ConnectorDogecoin();

    int fKey() const { return 1; }
    void fSetup();
  //  int fStatus() const { return mStatus; }
    const QString fConfigFile() const { return "dogecoin.conf"; }
    const QString fLabel() const { return "Dogecoin";}
    const QString fName() const { return "DOGE";}
    const QString fTestConnectionCommand() const { return "getbalance";}
    QStringList fStartupParameters() const { return QStringList() << QString("-conf=%1/%2").arg(mDataDirectory).arg(fConfigFile()) << QString("-datadir=%1").arg(mDataDirectory) << QString("-rpcwait"); } // << QString("-prune=2200"); }
    QString fDefaultBalanceMinConfirmations() const { return "1"; }
    QString fDefaultBinaryName() const { return "dogecoind"; }
    QString fDefaultClientName() const { return "dogecoin-cli"; }
    QString fDefaultDataDirectory() const {
      if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) return "C:/Blockchain/DogecoinChain";
      else return QString("%1/Blockchain/DogecoinChain").arg(QDir::homePath());
    }
    QString fDefaultEnabled() const { return "0"; }
    QString fDefaultLockFile() const { return ".lock"; }
    QString fDefaultPassword() const { return "df554F5t5gGg5g46df"; }
    QString fDefaultPidFile() const { return "dogecoind.pid"; }
    QString fDefaultPort() const { return "22556"; }
    QString fDefaultRpcPort() const { return "22555"; }
    QString fDefaultUser() const { return "Worldcoiner"; }
};

#endif // CONNECTORDOGECOIN_H
