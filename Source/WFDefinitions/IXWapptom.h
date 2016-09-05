#ifndef IXWAPPTOM
#define IXWAPPTOM

#include <QString>
#include <QtPlugin>

class IXWapptom {
  public:
    virtual ~IXWapptom() { }

    virtual QString fBaseName() const = 0;
    virtual QString fName() const = 0;
    virtual QString fInput() const = 0;
    virtual QString fOutput() const = 0;
    virtual QString fSource() const = 0;
    virtual bool fActive() const = 0;
    virtual bool fSingleShot() const = 0;
    virtual bool fResponseStateIsAnswer() const = 0;
    virtual int fPollingTime() const = 0;
    virtual int fPrecision() const = 0;
    virtual int fStatus() const = 0;
    virtual int fStartingOffset() const = 0;
    virtual void fSetup() = 0;
    virtual int fType() const = 0;
    virtual QString fConnector() const = 0;
    virtual QString fValue() const = 0;
    virtual QString fParams() const = 0;
    virtual QString fDisplayValue() const = 0;

  public slots:
    virtual void tSetActive(bool lActive) = 0;
    virtual void tSetPollingTime(int lPollingTime) = 0;
    virtual void tSetConnector(const QString& lConnector) = 0;
    virtual void tSetStartingOffset(const int lStartingOffset) = 0;
    virtual void tSetValue(const QString& lValue) = 0;
    virtual void tSetParams(const QString& lParams) = 0;
    virtual void tSetDisplayValue(const QString& lValue) = 0;
    virtual void tSetPrecision(int lPrecision) = 0;
    virtual void tSetSingleShot(bool lSingleShot) = 0;
    virtual void tSetSource(const QString& lSource) = 0;

  protected slots:
    virtual void tSetStatus(int lStatus) = 0;
};

Q_DECLARE_INTERFACE(IXWapptom, "com.arxen.Pulzar.IXWapptom/1.0.0")

#endif // IXWAPPTOM

