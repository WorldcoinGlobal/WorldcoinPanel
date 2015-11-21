#ifndef WAPPTOMCONNECTIONCOUNT_H
#define WAPPTOMCONNECTIONCOUNT_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomConnectionCount : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomConnectionCount/1.0.0")

  public:
    ~WapptomConnectionCount();

    QString fName() const { return QString("WAConnectionCount"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
