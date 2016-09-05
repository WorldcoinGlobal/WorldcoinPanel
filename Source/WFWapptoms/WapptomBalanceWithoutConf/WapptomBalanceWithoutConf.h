#ifndef WAPPTOMBALANCEWITHOUTCONF_H
#define WAPPTOMBALANCEWITHOUTCONF_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomBalanceWithoutConf : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomBalanceWithoutConf/1.0.0")

  public:
    ~WapptomBalanceWithoutConf();

    BXWapptom* fCreate() { return new WapptomBalanceWithoutConf(); }
    QString fBaseName() const { return QString("WABalanceWithoutConf"); }
//    QString fInput() const { return QString("%1 %2 0").arg(mInput).arg(mParams); }
    QString fInput() const { return QString("%1 %2").arg(mInput).arg(mParams); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
