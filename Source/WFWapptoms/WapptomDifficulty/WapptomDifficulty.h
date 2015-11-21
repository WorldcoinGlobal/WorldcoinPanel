#ifndef WAPPTOMDIFFICULTY_H
#define WAPPTOMDIFFICULTY_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomDifficulty : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomDifficulty/1.0.0")

  public:
    ~WapptomDifficulty();

    QString fName() const { return QString("WADifficulty"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
