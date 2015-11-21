#ifndef IXCRYPTOCONNECTOR_H
#define IXCRYPTOCONNECTOR_H

#include <QString>
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

  public slots:    
    virtual bool tEndService() = 0;
    virtual bool tExecute(int lRequestType, quint64 lRequestID, const QString& lInput, const QString& lOutput, bool lResponseStateIsAnswer = false, bool lParse = true, int lLogType = CXDefinitions::ELogAll) = 0;
    virtual bool tRestart() = 0;
    virtual bool tStart() = 0;
    virtual bool tStop() = 0;
    virtual void tLoadSettings() = 0;
    virtual void tSaveSettings() = 0;
    virtual void tSendReply() = 0;
};

Q_DECLARE_INTERFACE(IXCryptoConnector, "com.arxen.Pulzar.IXCryptoConnector/1.0.0")

#endif // IXCRYPTOCONNECTOR_H
