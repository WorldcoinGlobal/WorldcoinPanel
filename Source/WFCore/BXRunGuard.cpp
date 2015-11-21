#include <QCryptographicHash>

#include "BXRunGuard.h"

QString BXRunGuard::fGenerateKeyHash(const QString& lKey, const QString& lSalt) {
  QByteArray lData;
  lData.append(lKey.toUtf8());
  lData.append(lSalt.toUtf8());
  lData = QCryptographicHash::hash(lData, QCryptographicHash::Sha1).toHex();
  return lData;
}

BXRunGuard::BXRunGuard(const QString& lKey)
          : mKey(lKey), mMemLockKey(fGenerateKeyHash(lKey, "_memLockKey" )), mSharedmemKey(fGenerateKeyHash(lKey, "_sharedmemKey")), mSharedMem(mSharedmemKey), mMemLock(mMemLockKey, 1) {
  QSharedMemory lFix(mSharedmemKey);
  lFix.attach();
}

BXRunGuard::~BXRunGuard() {
  fRelease();
}

bool BXRunGuard::fIsAnotherRunning() {
  if(mSharedMem.isAttached())
    return false;
  mMemLock.acquire();
  const bool lIsRunning = mSharedMem.attach();
  if(lIsRunning)
    mSharedMem.detach();
  mMemLock.release();
  return lIsRunning;
}

bool BXRunGuard::fTryToRun() {
  if(fIsAnotherRunning())
    return false;
  mMemLock.acquire();
  const bool lResult = mSharedMem.create(sizeof(quint64));
  mMemLock.release();
  if(!lResult ) {
    fRelease();
    return false;
  }
  return true;
}

void BXRunGuard::fRelease() {
  mMemLock.acquire();
  if(mSharedMem.isAttached())
    mSharedMem.detach();
  mMemLock.release();
}
