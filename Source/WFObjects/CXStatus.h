#ifndef CXSTATUS_H
#define CXSTATUS_H

#include <QObject>
#include <CXDefinitions.h>

#include "HXObjects.h"

class WFOBJECTS_EXPORT CXStatus : public QObject {
  Q_OBJECT
  Q_PROPERTY(int mConnectionsStatus READ fConnectionsStatus NOTIFY sConnectionsStatusChanged)
  Q_PROPERTY(int mDaemonStatus READ fDaemonStatus WRITE tSetDaemonStatus NOTIFY sDaemonStatusChanged)
  Q_PROPERTY(int mLockStatus READ fLockStatus NOTIFY sLockStatusChanged)
  Q_PROPERTY(int mServicesStatus READ fServicesStatus NOTIFY sServicesStatusChanged)
  Q_PROPERTY(int mSyncStatus READ fSyncStatus NOTIFY sSyncStatusChanged)
  Q_PROPERTY(int mUpdatesStatus READ fUpdatesStatus NOTIFY sUpdatesStatusChanged)
  Q_PROPERTY(QString mStatusText READ fStatusText NOTIFY sStatusTextChanged)
  public:
    explicit CXStatus(QObject* pParent = 0);
    ~CXStatus();

    int fConnectionsStatus() const { return mConnectionsStatus; }
    int fDaemonStatus() const { return mDaemonStatus; }
    int fLockStatus() const { return mLockStatus; }
    int fServicesStatus() const { return mServicesStatus; }
    int fSyncStatus() const { return mSyncStatus; }
    int fUpdatesStatus() const { return mUpdatesStatus; }
    QString fStatusText() const { return mStatusText; }

  public slots:
    void tSetConnectionsStatus(int lConnectionsStatus);
    void tSetDaemonStatus(int lDaemonStatus);
    void tSetLockStatus(int lLockStatus);
    void tSetServicesStatus(int lServicesStatus);
    void tSetSyncStatus(int lSyncStatus);
    void tSetUpdatesStatus(int lUpdatesStatus);
    void tSetStatusText(const QString& lStatusText) { mStatusText = lStatusText; emit sStatusTextChanged(lStatusText); }
    void tExecuteWizard();

  protected:
    int mConnectionsStatus;
    int mDaemonStatus;
    int mLockStatus;
    int mServicesStatus;
    int mSyncStatus;
    int mUpdatesStatus;
    QString mStatusText;

  signals:
    void sConnectionsStatusChanged();
    void sDaemonStatusChanged();
    void sLockStatusChanged();
    void sServicesStatusChanged();
    void sSyncStatusChanged();
    void sUpdatesStatusChanged();
    void sStatusTextChanged(const QString& lStatusText);    
};

#endif // CXSTATUS_H
