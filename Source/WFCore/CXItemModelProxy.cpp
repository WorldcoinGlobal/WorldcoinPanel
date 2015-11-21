#include <QObject>
#include <QVariant>
#include <CXDefinitions.h>

#include "CXItemModel.h"
#include "CXItemModelProxy.h"

CXItemModelProxy::CXItemModelProxy(QObject* pParent)
                : QSortFilterProxyModel(pParent) {

}

CXItemModelProxy::~CXItemModelProxy() {

}

QVariant CXItemModelProxy::data(const QModelIndex& lIndex, int lRole) const {
  if(lRole >= 10001) {
    int lColumn = lRole - 10001;
    QModelIndex lSourceIndex(index(lIndex.row(), lColumn));
    return QSortFilterProxyModel::data(lSourceIndex, CXDefinitions::EDisplayRole);
  }
  if(lIndex.column() == 0)
    return QSortFilterProxyModel::data(lIndex, lRole);
  return QVariant();
}

QVariant CXItemModelProxy::fHorizontalHeaderDataType(int lColumn) const {
  CXItemModel* pSourceModel = qobject_cast<CXItemModel*> (sourceModel());
  return pSourceModel->fHorizontalHeaderDataType(lColumn);
}

QVariantList CXItemModelProxy::fHorizontalHeaderDataTypes() const {
  CXItemModel* pSourceModel = qobject_cast<CXItemModel*> (sourceModel());
  return pSourceModel->fHorizontalHeaderDataTypes();
}

QVariantList CXItemModelProxy::fHorizontalHeaderTitles() const {
  CXItemModel* pSourceModel = qobject_cast<CXItemModel*> (sourceModel());
  return pSourceModel->fHorizontalHeaderTitles();
}
