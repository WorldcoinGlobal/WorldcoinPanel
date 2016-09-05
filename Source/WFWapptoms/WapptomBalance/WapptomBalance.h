#ifndef WAPPTOMBALANCE_H
#define WAPPTOMBALANCE_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomBalance : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomBalance/1.0.0")

  public:
    ~WapptomBalance();

    BXWapptom* fCreate() { return new WapptomBalance(); }
    QString fBaseName() const { return QString("WABalance"); }
    QString fInput() const { return QString("%1 %2").arg(mInput).arg(mParams); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
