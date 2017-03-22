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
  tSetOutput("price");
  tSetPollingTime(cDefaultSampleTime);
//  tSetConnector(cDefaultDaemon);
}

QString WapptomExchangeRate::fPreProcess(const QString& lOriginalAnswer) {
   QString lResp = lOriginalAnswer;
   lResp.remove("\"ticker\":{");
   lResp.remove("}");
   lResp += "}";
   return lResp;
}
