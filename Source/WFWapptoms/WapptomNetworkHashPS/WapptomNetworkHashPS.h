#ifndef WAPPTOMNETWORKHASHPS_H
#define WAPPTOMNETWORKHASHPS_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomNetworkHashPS : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomNetworkHashPS/1.0.0")

  public:
    ~WapptomNetworkHashPS();

    QString fName() const { return QString("WANetworkHashPS"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
