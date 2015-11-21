#include <CXDefinitions.h>

#include "WapptomBalanceWithoutConf.h"

WapptomBalanceWithoutConf::~WapptomBalanceWithoutConf() {

}

void WapptomBalanceWithoutConf::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.toDouble(), 'f', mPrecision);
  emit sDisplayValueChanged();
}

void WapptomBalanceWithoutConf::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getbalance");
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}
