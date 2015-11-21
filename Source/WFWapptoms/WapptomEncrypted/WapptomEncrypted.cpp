#include <CXDefinitions.h>

#include "WapptomEncrypted.h"

WapptomEncrypted::~WapptomEncrypted() {

}

void WapptomEncrypted::tSetDisplayValue(const QString& lValue) {
  int lBoolVal = lValue.toInt();
  if(lBoolVal > 0) mDisplayValue = tr("True");
  else mDisplayValue = tr("False");
  emit sDisplayValueChanged();
}

void WapptomEncrypted::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("walletlock");
  mSource = tr("Local Wallet");
  mResponseStateIsAnswer = true;
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}
