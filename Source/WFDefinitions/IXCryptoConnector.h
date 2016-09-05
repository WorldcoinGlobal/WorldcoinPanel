#ifndef IXCRYPTOCONNECTOR_H
#define IXCRYPTOCONNECTOR_H

#include <QString>
#include <QStringList>
#include <QtPlugin>

#include "CXDefinitions.h"

class IXCryptoConnector
{
  public:
    virtual ~IXCryptoConnector() {}

    virtual bool fCheckParameters() = 0;
    virtual int fKey() const = 0;
    virtual void fSetup() = 0;
    virtual int fStatus() const = 0;
    virtual const QString fConfigFile() const = 0;
    virtual const QString fLabel() const = 0;
    virtual const QString fName() const = 0;
    virtual const QString fTestConnectionCommand() const = 0;
    virtual QStringList fStartupParameters() const = 0;
    virtual QString fDefaultBalanceMinConfirmations() const = 0;
    virtual QString fDefaultBinaryName() const = 0;
    virtual QString fDefaultClientName() const = 0;
    virtual QString fDefaultDataDirectory() const = 0;
    virtual QString fDefaultEnabled() const = 0;
    virtual QString fDefaultLockFile() const = 0;
    virtual QString fDefaultPassword() const = 0;
    virtual QString fDefaultPidFile() const = 0;
    virtual QString fDefaultPort() const = 0;
    virtual QString fDefaultRpcPort() const = 0;
    virtual QString fDefaultUser() const = 0;

  public slots:    
    virtual bool fEndService() = 0;
    virtual bool fExecute(int lRequestType, quint64 lRequestID, const QString& lInput, const QString& lOutput, bool lResponseStateIsAnswer = false, bool lParse = true, int lLogType = CXDefinitions::ELogAll) = 0;
    virtual bool fRestart() = 0;
    virtual bool fStart() = 0;
    virtual bool fStop() = 0;
    virtual void fLoadSettings() = 0;
    virtual void fSaveSettings() = 0;
    virtual void fSendReply() = 0;
};

Q_DECLARE_INTERFACE(IXCryptoConnector, "com.arxen.Pulzar.IXCryptoConnector/1.0.0")

#endif // IXCRYPTOCONNECTOR_H
