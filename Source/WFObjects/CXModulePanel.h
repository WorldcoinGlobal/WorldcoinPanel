#ifndef CXMODULEPANEL_H
#define CXMODULEPANEL_H

#include <QMap>
#include <QPair>
#include <QStringList>
#include <CXDefinitions.h>

#include "CXModuleProxy.h"
#include "HXObjects.h"

class CXItemModel;
class QStandardItem;
class WFOBJECTS_EXPORT CXModulePanel : public CXModuleProxy
{
  Q_OBJECT

  public:
    explicit CXModulePanel(QObject* pParent = 0);
    ~CXModulePanel();

    Q_INVOKABLE QStringList fComponentDependencies(const QString& lComponent);
    Q_INVOKABLE QString fComponentCategory(const QString& lComponent);
    Q_INVOKABLE QString fComponentLabel(const QString& lComponent);
    Q_INVOKABLE QString fComponentType(const QString& lComponent);    

  public slots:
    void tLoadData();

  private:
    CXItemModel* rComponentModel;
    QMap<QString, QStandardItem* > mComponents; // Name, Item in panel
    QMap<QString, QString> mModules; // Module, Area
};

#endif // CXMODULEPANEL_H
