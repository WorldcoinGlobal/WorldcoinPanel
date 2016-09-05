#include <CXDefinitions.h>

#include "WapptomBestBlockHash.h"

WapptomBestBlockHash::~WapptomBestBlockHash() {

}

void WapptomBestBlockHash::fSetup() {
  BXWapptom::fSetup();
  mInput = QString("getbestblockhash");
  mSource = tr("Local Wallet");
  tSetPollingTime(cDefaultSampleTime);
//  tSetConnector(cDefaultDaemon);
}
