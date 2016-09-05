#include <QMap>
#include <QStringList>
#include <CXDefinitions.h>

#include "WapptomExchangeRate.h"

WapptomExchangeRate::~WapptomExchangeRate() {

}

void WapptomExchangeRate::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.toDouble(), 'f', mPrecision);
  emit sDisplayValueChanged();
}

void WapptomExchangeRate::fSetup() {
  BXWapptom::fSetup();
  tSetSource("Network");
  tSetOutput("exch_rate");
  tSetPollingTime(cDefaultSampleTime);
//  tSetConnector(cDefaultDaemon);
}
