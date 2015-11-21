#include <CXDefinitions.h>

#include "WapptomNetworkHashPS.h"

WapptomNetworkHashPS::~WapptomNetworkHashPS() {

}

void WapptomNetworkHashPS::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.section(".",0,0).toLongLong());
  emit sDisplayValueChanged();
}

void WapptomNetworkHashPS::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getnetworkhashps");
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}
