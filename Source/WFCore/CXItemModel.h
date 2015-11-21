#ifndef CXITEMMODEL_H
#define CXITEMMODEL_H

#include <QByteArray>
#include <QHash>
#include <QList>
#include <QObject>
#include <QStandardItemModel>
#include <QStringList>
#include <QVariantList>

#include "CXItemModelHeader.h"
#include "HXCore.h"

class WFCORE_EXPORT CXItemModel : public QStandardItemModel {
  Q_OBJECT

  public:
    explicit CXItemModel(QObject* pParent = 0);
    explicit CXItemModel(int pRows, int pColumns, QObject* pParent = 0 );
    virtual ~CXItemModel();

    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE QList<CXItemModelHeader*> fHorizontalHeaders() const { return mHorizontalHeaders; }
    Q_INVOKABLE QVariant fHorizontalHeaderDataType(int lColumn) const;
    Q_INVOKABLE QVariantList fHorizontalHeaderDataTypes() const;
    Q_INVOKABLE QVariantList fHorizontalHeaderTitles() const;
    void fSetHorizontalHeaders(const QList<CXItemModelHeader*>& lHorizontalHeaders) { mHorizontalHeaders = lHorizontalHeaders; emit sHorizontalHeadersChanged(); }

  public slots:
    virtual void tLoadData() { }

  private:
    QList<CXItemModelHeader*> mHorizontalHeaders;

  signals:
    void sHorizontalHeadersChanged();
};

#endif // CXITEMMODEL_H
