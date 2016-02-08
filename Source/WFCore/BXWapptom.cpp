#include <QSslSocket>
#include <CXDefinitions.h>

#include "BXWapptom.h"

BXWapptom::~BXWapptom() {

}

void BXWapptom::fSetup() {
  setObjectName(fName());
  mPrecision = cDefaultPrecision;
  mActiveComponents = 0;
  mActive = false;
  mSingleShot = false;
  mResponseStateIsAnswer = false;
  mStatus = CXDefinitions::EServiceStopped;
  mValue = "0";
  mDisplayValue = "0";
  mInitialized = false;
  connect(&mPollTimer, &QTimer::timeout, this, &BXWapptom::tRequestUpdateValue);
}

void BXWapptom::tRequestUpdateValue() {
  emit sUpdateValue(fName());
}

void BXWapptom::tSetActive(bool lActive) {  
  if(lActive) {      
    mActiveComponents += 1;
    mActive = true;
    QTimer::singleShot(mStartingOffset, this, &BXWapptom::tStart);
  }
  else {
    if(mActiveComponents > 0) mActiveComponents -= 1;
    if(mPollTimer.isActive() && !mActiveComponents) {
      mActive = false;
      mPollTimer.stop();
    }
  }
  emit sActiveChanged();
}

void BXWapptom::tStart() {
  if(mSingleShot) mPollTimer.singleShot(mPollingTime, this, &BXWapptom::tRequestUpdateValue);
  else { if(!mPollTimer.isActive()) mPollTimer.start(mPollingTime); }
}
