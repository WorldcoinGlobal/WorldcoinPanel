#include <CXDefinitions.h>

#include "CXItemModel.h"

CXItemModel::CXItemModel(QObject* pParent)
           : QStandardItemModel(pParent) {

}

CXItemModel::CXItemModel(int pRows, int pColumns, QObject* pParent)
           : QStandardItemModel(pRows, pColumns, pParent) {

}

CXItemModel::~CXItemModel() {
  qDeleteAll(mHorizontalHeaders);
  mHorizontalHeaders.clear();
}

QVariant CXItemModel::fHorizontalHeaderDataType(int lColumn) const {
  if((lColumn < 0) || (lColumn >= mHorizontalHeaders.size()) )
    return 0;
  return mHorizontalHeaders[lColumn]->fGetDataType();
}

QVariantList CXItemModel::fHorizontalHeaderDataTypes() const {
  QVariantList lHeaders;
  for(const CXItemModelHeader* lHeader : mHorizontalHeaders) {
    lHeaders << lHeader->fGetDataType();
  }
  return lHeaders;
}

QVariantList CXItemModel::fHorizontalHeaderTitles() const {
  QVariantList lHeaders;
  for(const CXItemModelHeader* lHeader : mHorizontalHeaders) {
    lHeaders << lHeader->fGetTitle();
  }
  return lHeaders;
}

QHash<int, QByteArray> CXItemModel::roleNames() const {
  QHash<int, QByteArray> lRoles;
  lRoles[CXDefinitions::EDisplayRole] = "EDisplayRole";
  lRoles[CXDefinitions::EEditRole] = "EEditRole";
  lRoles[CXDefinitions::EComponentTypeRole] = "EComponentTypeRole";
  lRoles[CXDefinitions::EAreaRole] = "EAreaRole";
  lRoles[CXDefinitions::EModuleRole] = "EModuleRole";
  lRoles[CXDefinitions::EConnectionTypeRole] = "EConnectionTypeRole";
  lRoles[CXDefinitions::EDataTypeRole] = "EDataTypeRole";
  lRoles[CXDefinitions::EMessageTypeRole] = "EMessageTypeRole";
  lRoles[CXDefinitions::EComponentCategoryRole] = "EComponentCategoryRole";
  for(int i = 10001; i <= 10100; i++)
    lRoles[i] = QString("E%1").arg(QString::number(i)).toLatin1();
  return lRoles;
}

