#ifndef WAPPTOMBLOCKCOUNT_H
#define WAPPTOMBLOCKCOUNT_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomBlockCount : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomBlockCount/1.0.0")

  public:
    ~WapptomBlockCount();

    BXWapptom* fCreate() { return new WapptomBlockCount(); }
    QString fBaseName() const { return QString("WABlockCount"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
