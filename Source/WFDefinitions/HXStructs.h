#ifndef HXSTRUCTS_H
#define HXSTRUCTS_H

#include <QString>

struct SXRequest {
  int lType;
  int lStatus;
  int lLogType;
  bool lResponseStateIsAnswer;
  bool lParse;
  QString lConnector;
  QString lName;
  QString lInput;
  QString lOutput;
};

#endif // HXSTRUCTS_H

