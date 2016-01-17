#ifndef BXCRYPTOCONNECTOR_H
#define BXCRYPTOCONNECTOR_H

#include <QList>
#include <QMap>
#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QTimer>
#include <qjsonvalue.h>
#include <IXCryptoConnector.h>

#include "HXCore.h"

class CXRcpClient;
class QJsonRpcServiceReply;
class QJsonRpcServiceReply;
class QProcess;
class  WFCORE_EXPORT BXCryptoConnector : public QObject, public IXCryptoConnector {
  Q_INTERFACES(IXCryptoConnector)
  Q_OBJECT

  public:
    virtual ~BXCryptoConnector();

    bool fIsEnabled() { return mEnabled; }
    virtual bool fCheckParameters();
    virtual int fKey() const = 0;
    virtual void fSetup();
    virtual int fStatus() const = 0;
    virtual const QString fConfigFile() const = 0;
    virtual const QString fLabel() const = 0;
    virtual const QString fName() const = 0;
    virtual QString fParseResponse(const QJsonValue& lResult, const QString& lOutput, const QString& lRequestID, int lIndentation = 0);
    virtual QStringList fParse(const QString& lInput) const;
    virtual void fSetStatus(int lStatus);
    virtual const QString fTestConnectionCommand() const = 0;

  protected:
    bool mEnabled;
    int mStatus;
    CXRcpClient* rRpc;
    QJsonRpcServiceReply* rRpcReply;
    QJsonRpcServiceReply* rRpcTestConnectonReply;
    QProcess mDaemon;
    QString mBinaryName;
    QString mDataDirectory;
    QString mUser;
    QString mPassword;
    QString mPort;
    QString mRpcPort;
    QString mPidFileName;
    QString mLockFileName;
    QTimer mTimer;

    virtual bool fCreateDataDir(const QString& lDataDirName);
    virtual bool fCreateConfFile(const QString& lDataDirName);
    virtual bool fKillDaemon(const QString& lDataDirName);
    virtual void fLoadCommandDefinitions(const QString& lFileName);

  private:
    QMap<QString, QList<int> > mCommandDefinitions;

  public slots:
    virtual bool fEndService();
    virtual bool fExecute(int lRequestType, quint64 lRequestID, const QString& lInput, const QString& lOutput, bool lResponseStateIsAnswer = false, bool lParse = true, int lLogType = CXDefinitions::ELogAll);
    virtual bool fRestart();
    virtual bool fStart();
    virtual bool fStop();
    virtual void fLoadSettings();
    virtual void fSaveSettings() { }

  protected slots:
    virtual void fSendReply();
    virtual void fTryConnection();
    virtual void fEvaluateConnection();

  signals:
    void sLogMessageRequest(int lCode, const QStringList& lParameters, const QString& lCustomText, int lLogType);
    void sStatusChanged(const QString& lConnectorName, int lStatus);
    void sReply(bool lSuccess, quint64 lRequestID, const QString& lValue);
    void sReplyJson(bool lSuccess, quint64 lRequestID, const QJsonValue& lValue);
    void sProcessingFinished();
};

#endif // BXCRYPTOCONNECTOR_H
