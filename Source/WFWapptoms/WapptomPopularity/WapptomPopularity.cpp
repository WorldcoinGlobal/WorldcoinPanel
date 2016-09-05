#include <QMap>
#include <QString>
#include <QStringList>
#include <CXDefinitions.h>

#include "WapptomPopularity.h"

WapptomPopularity::~WapptomPopularity() {

}

void WapptomPopularity::tSetDisplayValue(const QString& lValue) {
  mDisplayValue = lValue;
  emit sDisplayValueChanged();
}

void WapptomPopularity::tSetValue(const QString& lValue) {
  if(mFirstTime) {
    tSetPollingTime(cDefaultSampleTime * 12 * 60 * 6); // 6 hours
    tStart();
    mFirstTime = false;
  }
  QStringList lPage(lValue.split("\n"));
  QStringList lPopularity(lPage.filter("Popularity (hits per day)"));
  QStringList lPopularityStripped;
  if(lPopularity.length()) {
    QString lPopularityString;
    QString lPopularityDisplay;
    lPopularity[0].remove("<b>");
    lPopularity[0].remove("</b>");
    lPopularity[0].remove("<br />");
    lPopularity[0].remove("</th>");
    lPopularity[0].remove("(");
    lPopularity[0].remove(")");
    lPopularityString = lPopularity.at(0).section(":",1).simplified();
    lPopularityStripped = lPopularityString.split(",");
    for(int i = 0; i < lPopularityStripped.size(); i++) {
      lPopularityStripped[i] = lPopularityStripped.at(i).section(":",1,1).simplified();
      switch(i) {
        case 0: lPopularityDisplay += tr("Period: 12 Months, Position: %1, Average hits: %2").arg(lPopularityStripped[i].section(" ",0,0)).arg(lPopularityStripped[i].section(" ",1,1)); break;
        case 1: lPopularityDisplay += tr("\nPeriod: 6 Months, Position: %1, Average hits: %2").arg(lPopularityStripped[i].section(" ",0,0)).arg(lPopularityStripped[i].section(" ",1,1)); break;
        case 2: lPopularityDisplay += tr("\nPeriod: 3 Months, Position: %1, Average hits: %2").arg(lPopularityStripped[i].section(" ",0,0)).arg(lPopularityStripped[i].section(" ",1,1)); break;
        case 3: lPopularityDisplay += tr("\nPeriod: 4 Weeks, Position: %1, Average hits: %2").arg(lPopularityStripped[i].section(" ",0,0)).arg(lPopularityStripped[i].section(" ",1,1)); break;
        case 4: lPopularityDisplay += tr("\nPeriod: 1 Week, Position: %1, Average hits: %2").arg(lPopularityStripped[i].section(" ",0,0)).arg(lPopularityStripped[i].section(" ",1,1)); break;
      }
    }
    mValue = lPopularityStripped.last().section(" ",0,0);
    emit sValueChanged();
    tSetDisplayValue(lPopularityDisplay);
  }
}

void WapptomPopularity::fSetup() {
  BXWapptom::fSetup();
  mFirstTime = true;
  mSource = tr("Network");
  tSetPollingTime(cDefaultSampleTime);
 // tSetConnector(cDefaultDaemon);
}
