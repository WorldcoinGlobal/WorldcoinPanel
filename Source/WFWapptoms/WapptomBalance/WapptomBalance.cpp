#include <CXDefinitions.h>

#include "WapptomBalance.h"

WapptomBalance::~WapptomBalance() {

}

void WapptomBalance::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.toDouble(), 'f', mPrecision);
  emit sDisplayValueChanged();
}

void WapptomBalance::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getbalance");
  mParams = QString("\"*\" %1").arg(cDefaultMinConfForBalance);
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}
