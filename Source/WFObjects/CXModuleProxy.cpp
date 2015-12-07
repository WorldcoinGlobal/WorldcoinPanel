#include "CXModuleProxy.h"

#include <QModelIndexList>
#include <QObject>
#include <QVariant>
#include <CXDefinitions.h>

CXModuleProxy::CXModuleProxy(QObject* pParent)
             : QSortFilterProxyModel(pParent) {

}

CXModuleProxy::~CXModuleProxy() {

}

bool CXModuleProxy::lessThan(const QModelIndex& lLeft, const QModelIndex& lRight) const {
  QString leftName = sourceModel()->data(lLeft, CXDefinitions::EDisplayRole).toString();
  QString rightName = sourceModel()->data(lRight, CXDefinitions::EDisplayRole).toString();
  QString leftArea = sourceModel()->data(lLeft, CXDefinitions::EAreaRole).toString();
  QString rightArea = sourceModel()->data(lRight, CXDefinitions::EAreaRole).toString();
  QString leftModule = sourceModel()->data(lLeft, CXDefinitions::EModuleRole).toString();
  QString rightModule = sourceModel()->data(lRight, CXDefinitions::EModuleRole).toString();
  quint32 leftType = sourceModel()->data(lLeft, CXDefinitions::EComponentTypeRole).toUInt();
  quint32 rightType = sourceModel()->data(lRight, CXDefinitions::EComponentTypeRole).toUInt();

  if(leftArea < rightArea) {
    return true;
  }
  else {
    if(leftArea == rightArea) {
      if(leftModule < rightModule) {
          return true;
      }
      else {
        if(leftModule == rightModule) {
          if(leftType < rightType) {
            return true;
          }
          else {
            if(leftType == rightType) {
              if(leftName < rightName) {
                return true;
              }
              else
                return false;
            }
            else
              return false;
          }
        }
        else
          return false;
      }

    }
    else
      return false;
  }
  return false;
}

int CXModuleProxy::fComponentRow(const QString& lComponent) {
  QModelIndexList lList(match(index(0,0), CXDefinitions::EEditRole, lComponent));
  if(lList.size()) return lList.at(0).row();
  return -1;
}

