#ifndef CXCONNECTORMANAGER_H
#define CXCONNECTORMANAGER_H

#include <QObject>
#include <QMap>
#include <QStringList>
#include <BXCryptoConnector.h>

#include "HXObjects.h"

class WFOBJECTS_EXPORT CXConnectorManager : public QObject {
  Q_OBJECT

  public:
    explicit CXConnectorManager(QObject* pParent = 0);
    ~CXConnectorManager();

    Q_INVOKABLE int fConnectorCount() const { return mConnectors.size(); }
    Q_INVOKABLE BXCryptoConnector* fConnector(const QString& lName) {
      if(mConnectors.contains(lName))
        return mConnectors.value(lName);
      return 0;
    }

    void insert(BXCryptoConnector* lConnector) {
       mConnectors[lConnector->fName()] = lConnector;
       connect(lConnector, &BXCryptoConnector::sStatusChanged, this, &CXConnectorManager::fPrepareStatus);
    }
    bool contains(const QString& lName) {
      if(mConnectors.contains(lName))
        return true;
      return false;
    }
    Q_INVOKABLE bool fStartDaemon(const QString& lName, bool lForce = true);
    Q_INVOKABLE bool fStopDaemon(const QString& lName);
    bool fStartDaemons();
    void fEndService();
    Q_INVOKABLE int fStatus(const QString& lName) {
      if(mConnectors.contains(lName)) return mConnectors.value(lName)->fStatus();
      return 0;
    }
    QStringList fConnectors() const;

  private:
    QMap<QString, BXCryptoConnector* > mConnectors;

  public slots:
    void fExecuteWizard();
    void fSetStatus(const QString& lName, int lStatus) {
      if(mConnectors.contains(lName)) {
        mConnectors.value(lName)->fSetStatus(lStatus);
        emit sStatusChanged(lName);
      }
    }
    void fPrepareStatus();

  signals:
    void sStatusChanged(const QString& lName);
    void sStatusTextChanged(const QString& lStatusText);
};

#endif // CXCONNECTORMANAGER_H

