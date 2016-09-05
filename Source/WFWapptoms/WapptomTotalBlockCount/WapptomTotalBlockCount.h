#ifndef WAPPTOMTOTALBLOCKCOUNT_H
#define WAPPTOMTOTALBLOCKCOUNT_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomTotalBlockCount : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomTotalBlockCount/1.0.0")

  public:
    ~WapptomTotalBlockCount();

    BXWapptom* fCreate() { return new WapptomTotalBlockCount(); }
    QString fBaseName() const { return QString("WNTotalBlockCount"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomNetwork; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
    void tSetValue(const QString& lValue);
};

#endif
