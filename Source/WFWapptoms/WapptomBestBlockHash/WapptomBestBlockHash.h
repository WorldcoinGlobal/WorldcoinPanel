#ifndef WAPPTOMBESTBLOCKHASH_H
#define WAPPTOMBESTBLOCKHASH_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomBestBlockHash : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomBestBlockHash/1.0.0")

  public:
    ~WapptomBestBlockHash();

    QString fName() const { return QString("WABestBlockHash"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomWallet; }
};

#endif
