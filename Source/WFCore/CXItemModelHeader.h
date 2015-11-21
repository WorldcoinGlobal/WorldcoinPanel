#ifndef CXITEMMODELHEADER_H
#define CXITEMMODELHEADER_H

#include <QObject>
#include <QString>
#include "HXCore.h"

class WFCORE_EXPORT CXItemModelHeader : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString mTitle READ fGetTitle WRITE fSetTitle NOTIFY sTitleChanged)
  Q_PROPERTY(int mDataType READ fGetDataType WRITE fSetDataType NOTIFY sDataTypeChanged)

 public:
    explicit CXItemModelHeader(const QString& lTitle, int lDataType, QObject* pParent = 0);
    ~CXItemModelHeader();

    QString fGetTitle() const { return mTitle; }
    int fGetDataType() const { return mDataType; }
    void fSetTitle(const QString& lTitle) { mTitle = lTitle; }
    void fSetDataType(int lDataType) { mDataType = lDataType; }

  private:
    QString mTitle;
    int mDataType;

  signals:
    void sTitleChanged();
    void sDataTypeChanged();
};

#endif // CXITEMMODELHEADER_H
