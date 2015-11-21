#include <CXDefinitions.h>

#include "WapptomBlockCount.h"

WapptomBlockCount::~WapptomBlockCount() {

}

void WapptomBlockCount::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.section(".",0,0).toLongLong());
  emit sDisplayValueChanged();
}

void WapptomBlockCount::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getblockcount");
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}
