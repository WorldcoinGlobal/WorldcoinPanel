#include <CXDefinitions.h>

#include "WapptomDifficulty.h"

WapptomDifficulty::~WapptomDifficulty() {

}

void WapptomDifficulty::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.toDouble(), 'f', mPrecision);
  emit sDisplayValueChanged();
}

void WapptomDifficulty::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getdifficulty");
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
//  tSetConnector(cDefaultDaemon);
}
