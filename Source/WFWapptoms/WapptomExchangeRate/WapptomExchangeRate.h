#ifndef WAPPTOMEXCHANGERATE_H
#define WAPPTOMEXCHANGERATE_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomExchangeRate : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomExchangeRate/1.0.0")

  public:
    ~WapptomExchangeRate();

    BXWapptom* fCreate() { return new WapptomExchangeRate(); }
    QString fBaseName() const { return QString("WNExchangeRate"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomNetwork; }
    QString fPreProcess(const QString& lOriginalAnswer);

  public slots:
    void tSetDisplayValue(const QString& lValue);
  //  void tSetValue(const QString& lValue);
};

#endif
