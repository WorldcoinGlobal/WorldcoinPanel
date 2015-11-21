#ifndef WAPPTOMENCRYPTED_H
#define WAPPTOMENCRYPTED_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomEncrypted : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomEncrypted/1.0.0")

  public:
    ~WapptomEncrypted();

    QString fName() const { return QString("WAEncrypted"); }
    QString fInput() const { return QString("%1 %2").arg(mInput).arg(mParams); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
};

#endif
