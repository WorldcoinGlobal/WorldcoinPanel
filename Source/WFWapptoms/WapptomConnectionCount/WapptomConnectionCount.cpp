#include <CXDefinitions.h>

#include "WapptomConnectionCount.h"

WapptomConnectionCount::~WapptomConnectionCount() {

}

void WapptomConnectionCount::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.section(".",0,0).toLongLong());
  emit sDisplayValueChanged();
}

void WapptomConnectionCount::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getconnectioncount");
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}
