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

    QString fName() const { return QString("WNExchangeRate"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomNetwork; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
  //  void tSetValue(const QString& lValue);
};

#endif
