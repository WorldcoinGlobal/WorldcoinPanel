#ifndef CXITEMMODELPROXY_H
#define CXITEMMODELPROXY_H

#include <QObject>
#include <QSortFilterProxyModel>
#include <QVariant>

#include "HXCore.h"

class WFCORE_EXPORT CXItemModelProxy : public QSortFilterProxyModel
{
  Q_OBJECT

  public:
    CXItemModelProxy(QObject* pParent = 0);
    virtual ~CXItemModelProxy();

    QVariant data(const QModelIndex& lIndex, int lRole = Qt::DisplayRole) const Q_DECL_OVERRIDE;
    Q_INVOKABLE QVariant fHorizontalHeaderDataType(int lColumn) const;
    Q_INVOKABLE QVariantList fHorizontalHeaderDataTypes() const;
    Q_INVOKABLE QVariantList fHorizontalHeaderTitles() const;
 // protected:
   // bool lessThan(const QModelIndex& lLeft, const QModelIndex& lRight) const Q_DECL_OVERRIDE;
};

#endif // CXItemModelProxy_H
