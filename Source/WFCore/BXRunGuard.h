#ifndef BXRUNGUARD_H
#define BXRUNGUARD_H

#include <QObject>
#include <QSharedMemory>
#include <QSystemSemaphore>

#include "HXCore.h"

class WFCORE_EXPORT BXRunGuard
{
  public:
    BXRunGuard(const QString& lKey);
    ~BXRunGuard();

    bool fIsAnotherRunning();
    bool fTryToRun();
    QString fGenerateKeyHash(const QString& lKey, const QString& lSalt);
    void fRelease();

  private:
    const QString mKey;
    const QString mMemLockKey;
    const QString mSharedmemKey;

    QSharedMemory mSharedMem;
    QSystemSemaphore mMemLock;
};

#endif // RUNGUARD_H
