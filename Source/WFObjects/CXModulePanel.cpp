#include <QSettings>
#include <QStandardItem>
#include <CXItemModel.h>

#include "CXModulePanel.h"

CXModulePanel::CXModulePanel(QObject* pParent)
             : CXModuleProxy(pParent) {
  rComponentModel = new CXItemModel(0, 1, this);
  setSourceModel(rComponentModel);
}

CXModulePanel::~CXModulePanel() {

}

QStringList CXModulePanel::fComponentDependencies(const QString& lComponent) {
  if(mComponents.contains(lComponent)) {
    QStandardItem* pItem = mComponents.value(lComponent);
    QStringList lDependencies(pItem->data(CXDefinitions::EComponentDependenciesRole).toString().split(","));
    if(lDependencies.size() && !lDependencies[0].isEmpty())
      return lDependencies;
  }
  return QStringList();
}

QString CXModulePanel::fComponentCategory(const QString& lComponent) {
  if(mComponents.contains(lComponent)) {
    QStandardItem* pItem = mComponents.value(lComponent);
    QString lCategory(QString::number(pItem->data(CXDefinitions::EComponentCategoryRole).toInt()));
    return lCategory;
  }
  return QString();
}

QString CXModulePanel::fComponentLabel(const QString& lComponent) {
  if(mComponents.contains(lComponent)) {
    QStandardItem* pItem = mComponents.value(lComponent);
    QString lLabel(pItem->data(CXDefinitions::EDisplayRole).toString());
    return lLabel;
  }
  return QString();
}

QString CXModulePanel::fComponentType(const QString& lComponent) {
  if(mComponents.contains(lComponent)) {
    QStandardItem* pItem = mComponents.value(lComponent);
    QString lType(QString::number(pItem->data(CXDefinitions::EComponentTypeRole).toInt()));
    return lType;
  }
  return QString();
}

void CXModulePanel::tLoadData() {
  QSettings lMainComponents(cMainComponents, QSettings::IniFormat);
  QSettings lExtraComponents(cExtraComponents, QSettings::IniFormat);
  QSettings lCustomComponents(cCustomComponents, QSettings::IniFormat);
  lMainComponents.setObjectName(cMainComponents);
  lExtraComponents.setObjectName(cExtraComponents);
  lCustomComponents.setObjectName(cCustomComponents);
  QList<QSettings*> lSettings;
  lSettings << &lMainComponents << &lExtraComponents << &lCustomComponents;

  mComponents.clear();
  mModules.clear();
  QStringList lAreas;
  for(QSettings* lComponentSettings : lSettings) {
    QStringList lKeys(lComponentSettings->allKeys());
    for(const QString& lKey : lKeys)
    {
      QString lComponent(lKey.section("/",0,0));
      QStandardItem* pComponentItem;
      if(mComponents.contains(lComponent)) pComponentItem = mComponents[lComponent];
      else {
        pComponentItem = new QStandardItem();
        mComponents[lComponent] = pComponentItem;
      }
      if(lComponentSettings->objectName() == cMainComponents) pComponentItem->setData(CXDefinitions::EMainComponent, CXDefinitions::EComponentCategoryRole);
      if(lComponentSettings->objectName() == cExtraComponents) pComponentItem->setData(CXDefinitions::EExtraComponent, CXDefinitions::EComponentCategoryRole);
      if(lComponentSettings->objectName() == cCustomComponents) pComponentItem->setData(CXDefinitions::ECustomComponent, CXDefinitions::EComponentCategoryRole);
      pComponentItem->setData(lComponent, CXDefinitions::EEditRole);
      QString lComponentKey(lKey.section("/",1,1));
      lComponentSettings->beginGroup(lComponent);
      if(lComponentKey == "Label") {
        QString lName(lComponentSettings->value("Label").toString());
        pComponentItem->setData(lName, CXDefinitions::EDisplayRole);
      }
      if(lComponentKey == "Area") {
        QString lArea(lComponentSettings->value("Area").toString());
        pComponentItem->setData(lArea, CXDefinitions::EAreaRole);
        lAreas << lArea;
      }
      if(lComponentKey == "Module") {
        QString lModule(lComponentSettings->value("Module").toString());
        pComponentItem->setData(lModule, CXDefinitions::EModuleRole);
        mModules[lModule] = lAreas.last();
      }
      if(lComponentKey == "Type") {
        QString lTypeString(lComponentSettings->value("Type").toString());
        quint32 lType = 0;
        if(lTypeString == "Config") lType = CXDefinitions::EConfig;
        if(lTypeString == "Custom") lType = CXDefinitions::ECustom;
        if(lTypeString == "Parameter") lType = CXDefinitions::EParameter;
        if(lTypeString == "Register") lType = CXDefinitions::ERegister;
        if(lTypeString == "Transaction") lType = CXDefinitions::ETransaction;
        if(lTypeString == "Process") lType = CXDefinitions::EProcess;
        if(lTypeString == "Report") lType = CXDefinitions::EReport;
        pComponentItem->setData(lType, CXDefinitions::EComponentTypeRole);
      }
      if(lComponentKey == "Dependencies") {
        QStringList lDependencies(lComponentSettings->value("Dependencies").toString().split(","));
        for(int i = 0; i < lDependencies.size(); i++) {
          lDependencies[i] = lDependencies[i].simplified();
          if(lDependencies[i].isEmpty()) {
            lDependencies.removeAt(i);
            i--;
          }
        }
        pComponentItem->setData(lDependencies.join(","), CXDefinitions::EComponentDependenciesRole);
      }
      lComponentSettings->endGroup();
    }
  }
  lAreas.removeDuplicates();
  for(const QString& lArea : lAreas) {
    QStandardItem* pComponentItem;
    pComponentItem = new QStandardItem();
    pComponentItem->setData(lArea, CXDefinitions::EDisplayRole);
    pComponentItem->setData(lArea, CXDefinitions::EAreaRole);
    pComponentItem->setData(0, CXDefinitions::EModuleRole);
    pComponentItem->setData(CXDefinitions::EArea, CXDefinitions::EComponentTypeRole);
    rComponentModel->appendRow(pComponentItem);
  }
  QMapIterator<QString, QString > it2(mModules);
  while(it2.hasNext()) {
    it2.next();
    QStandardItem* pComponentItem;
    pComponentItem = new QStandardItem();
    pComponentItem->setData(it2.key(), CXDefinitions::EDisplayRole);
    pComponentItem->setData(it2.value(), CXDefinitions::EAreaRole);
    pComponentItem->setData(it2.key(), CXDefinitions::EModuleRole);
    pComponentItem->setData(CXDefinitions::EModule, CXDefinitions::EComponentTypeRole);
    rComponentModel->appendRow(pComponentItem);
  }

  QMapIterator<QString, QStandardItem* > lIterator(mComponents);
  while(lIterator.hasNext()) {
    lIterator.next();
    rComponentModel->appendRow(lIterator.value());
  }

  sort(0);
}
