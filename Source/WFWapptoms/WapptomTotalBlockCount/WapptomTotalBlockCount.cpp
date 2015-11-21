#include <QMap>
#include <QStringList>
#include <CXDefinitions.h>

#include "WapptomTotalBlockCount.h"

WapptomTotalBlockCount::~WapptomTotalBlockCount() {

}

void WapptomTotalBlockCount::tSetDisplayValue(const QString& lValue) {
  mDisplayValue.setNum(lValue.section(".",0,0).toLongLong());
  emit sDisplayValueChanged();
}

void WapptomTotalBlockCount::fSetup() {
  BXWapptom::fSetup();
  mSource = tr("Network");
  tSetPollingTime(cDefaultSampleTime);
  tSetConnector(cDefaultDaemon);
}

/*void WapptomTotalBlockCount::tSetValue(const QString& lValue) {
  QStringList lValues(lValue.split(","));
  QMap<quint64, int> lModeMap;
  for(const QString& lVal : lValues) {
    quint64 lCurrent = lVal.section(".",0,0).toLongLong();
    if(lModeMap.contains(lCurrent)) lModeMap[lCurrent] += 1;
    else lModeMap[lCurrent] = 1;
  }
  int lCurrentMode = 0;
  QString lModeValue;
  QMapIterator<quint64, int> i(lModeMap);
  while(i.hasNext()) {
    i.next();
    if(i.value() > lCurrentMode) {
      lCurrentMode = i.value();
      lModeValue.setNum(i.key());
    }
  }
  BXWapptom::tSetValue(lModeValue);
}*/
