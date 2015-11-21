#ifndef CXMODULEPROXY_H
#define CXMODULEPROXY_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "HXObjects.h"

class WFOBJECTS_EXPORT CXModuleProxy : public QSortFilterProxyModel
{
  Q_OBJECT

  public:
    CXModuleProxy(QObject* pParent = 0);
    ~CXModuleProxy();

  protected:
    bool lessThan(const QModelIndex& lLeft, const QModelIndex& lRight) const Q_DECL_OVERRIDE;
};

#endif // CXMODULEPROXY_H
