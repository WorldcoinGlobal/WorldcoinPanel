#ifndef WAPPTOMPOPULARITY_H
#define WAPPTOMPOPULARITY_H

#include <QObject>
#include <QString>
#include <BXWapptom.h>
#include <CXDefinitions.h>

class WapptomPopularity : public BXWapptom {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "com.arxen.Pulzar.WapptomPopularity/1.0.0")

  public:
    ~WapptomPopularity();

    QString fName() const { return QString("WNPopularity"); }
    void fSetup();
    int fType() const { return CXDefinitions::EWapptomNetwork; }

  public slots:
    void tSetDisplayValue(const QString& lValue);
    void tSetValue(const QString& lValue);

  private:
    bool mFirstTime;
};

#endif
