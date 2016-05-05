#include <CXDefinitions.h>
#include "CXMessagePool.h"

CXMessagePool::CXMessagePool(QObject *pParent)
             : QObject(pParent) {

}

const CXMessage CXMessagePool::fMessage(int lCode, const QStringList& lParameters, const QString& lCustomText) {
  int lType = fMessageType(lCode);
  CXMessage lMessage(lType, lCode);

  switch(lCode) {
    case 1200001: lMessage.fSetText(tr("Welcome to Worldcoin Business Center!")); break;
    case 1200002: lMessage.fSetText(tr("Component loaded succesfully. Component name '%1'").arg(lParameters.at(0))); break;
    case 1200003: lMessage.fSetText(tr("Request completed succesfully. Connector: '%1'. Request ID: '%2'. Command: '%3'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2))); break;
    case 1200004: lMessage.fSetText(tr("Connection to Pulzar Services established")); break;
    case 2200001: lMessage.fSetText(tr("Ready!")); break;
    case 2200002: lMessage.fSetText(tr("Loading Connectors ...")); break;
    case 2200003: lMessage.fSetText(tr("Starting daemons ...")); break;
    case 2200004: lMessage.fSetText(tr("Worldcoin daemon started successfully")); break;
    case 2200005: lMessage.fSetText(tr("Loading Wapptoms ...")); break;
    case 2200006: lMessage.fSetText(tr("Connection with daemon established. Connector '%1'").arg(lParameters.at(0))); break;
    case 2200007: lMessage.fSetText(tr("Main daemon stopped. Connector '%1'").arg(lParameters.at(0))); break;
    case 2200008: lMessage.fSetText(tr("Main daemon indexing. Please wait ... Connector '%1'").arg(lParameters.at(0))); break;
    case 2200009: lMessage.fSetText(tr("Closing Business Centre ... Please wait")); break;
    case 2200010: lMessage.fSetText(tr("Checkpoint: %1").arg(lParameters.at(0))); break;
    case 3200001: lMessage.fSetText(tr("Unable to open file! File name: '%1'").arg(lParameters.at(0))); break;
    case 3200002: lMessage.fSetText(tr("Unable to create folder! Folder name: '%1'").arg(lParameters.at(0))); break;
    case 3200003: lMessage.fSetText(tr("Unable to copy file! Folder name: '%1'. File name : '%2'.").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 3200004: lMessage.fSetText(tr("Unable to remove file! File name: '%1'").arg(lParameters.at(0))); break;
    case 3200005: lMessage.fSetText(tr("Service could not start because a parameter is missing. Service: '%1'. Parameter: '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 3200006: lMessage.fSetText(tr("Main daemon was not loaded succesfully!")); break;
    case 3200007: lMessage.fSetText(tr("A critical error has ocurred ! Check log and contact support !")); break;
    case 3200008: lMessage.fSetText(tr("Unable to load plugin! File name: '%1'. Loader Error: '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 3200009: lMessage.fSetText(tr("Unable to create file! File name: '%1'").arg(lParameters.at(0))); break;
    case 3200010: lMessage.fSetText(tr("Unable to find file! File name : '%1'").arg(lParameters.at(0))); break;
    case 3200011: lMessage.fSetText(tr("Some Wapptoms couldn't be loaded properly ! Check log and contact support !")); break;
    case 3200012: lMessage.fSetText(tr("JSon RPC client has a wrong URL! Check Daemons.cfg config file. Connector: '%1'. Url: '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 3200013: lMessage.fSetText(tr("JSon RPC error! Connector: '%1'. Error: '%2'. Code: '%3'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2))); break;
    case 3200014: lMessage.fSetText(tr("JSon RPC connection error! Connector: '%1'").arg(lParameters.at(0))); break;
    case 3200015: lMessage.fSetText(tr("Main daemon error! Connector: '%1'. ").arg(lParameters.at(0))); break;
    case 3200016: lMessage.fSetText(tr("Unable to load component! Component name: '%1'").arg(lParameters.at(0))); break;
    case 3200017: lMessage.fSetText(tr("Component loaded does not inherit the correct type ! Component name: '%1'").arg(lParameters.at(0))); break;
    case 3200018: lMessage.fSetText(tr("JSon RPC - Method not found. Connector: '%1'. Request ID: '%2'. Command: '%3'. Error: '%4'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2)).arg(lParameters.at(3))); break;
    case 3200019: lMessage.fSetText(tr("JSon RPC - Invalid parameter(s). Connector: '%1'. Request ID: '%2'. Command: '%3'. Error: '%4'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2)).arg(lParameters.at(3))); break;
    case 3200020: lMessage.fSetText(tr("JSon RPC - Invalid request. Connector: '%1'. Request ID: '%2'. Command: '%3'. Error: '%4'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2)).arg(lParameters.at(3))); break;
    case 3200021: lMessage.fSetText(tr("JSon RPC - Parse error. Connector: '%1'. Request ID: '%2'. Command: '%3'. Error: '%4'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2)).arg(lParameters.at(3))); break;      
    case 3200022: lMessage.fSetText(tr("Network request error! Object: '%1'. Request ID: '%2'. Request: '%3'. Error: '%4'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2)).arg(lParameters.at(3))); break;
    case 3200023: lMessage.fSetText(tr("Unable to connect to Pulzar Services. Error: '%1'").arg(lParameters.at(0))); break;
    case 3200024: lMessage.fSetText(tr("Unable to start daemon '%1'").arg(lParameters.at(0))); break;
    case 4200001: lMessage.fSetText(tr("Starting the application ... wait a few more seconds until daemon is up and ready. Connector: '%1'").arg(lParameters.at(0))); break;
    case 4200002: lMessage.fSetText(tr("Command not found in definitions! Type 'help' for a list of known commands. Connector: '%1'. Command '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 4200003: lMessage.fSetText(tr("Incorrect number of params! Type 'help %2' for more information. Connector: '%1'. Command '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 4200004: lMessage.fSetText(tr("Incorrect param type! Type 'help %2' for more information. Connector: '%1'. Command '%2'. Parameter '%3'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2))); break;
    case 4200005: lMessage.fSetText(tr("Disconnected from Pulzar Services")); break;
    case 5200001: lMessage.fSetText(tr("Wapptoms tried to invoke inexistent connector ! Wapptom : '%1'. Connector: '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 5200002: lMessage.fSetText(tr("Connector not found in mConnectors table ! Connector: '%1'").arg(lParameters.at(0))); break;
    case 5200003: lMessage.fSetText(tr("Wapptom not found in mWapptoms table ! Wapptom: '%1'").arg(lParameters.at(0))); break;
    case 5200004: lMessage.fSetText(tr("Reply not found in pending requests table ! RequesID: '%1'").arg(lParameters.at(0))); break;
    case 5200005: lMessage.fSetText(tr("Unable to load themed component file! File name: '%1'").arg(lParameters.at(0))); break;
    case 5200006: lMessage.fSetText(tr("Component is not registered! Component name: '%1'").arg(lParameters.at(0))); break;
    case 5200007: lMessage.fSetText(tr("Unexpected JSon RPC result! Request ID: '%1'. Tag: '%2'").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 5200008: lMessage.fSetText(tr("Bad command definition! Connector: '%1'. File: '%2'. Command: '%3'").arg(lParameters.at(0)).arg(lParameters.at(1)).arg(lParameters.at(2))); break;
    case 5200009: lMessage.fSetText(tr("Command definition files empty! Connector: '%1'. File: '%2'.").arg(lParameters.at(0)).arg(lParameters.at(1))); break;
    case 5200010: lMessage.fSetText(tr("Network reply is null!")); break;
    case 5200011: lMessage.fSetText(tr("Wrong parameters! %1").arg(lParameters.at(0))); break;
    case 5200012: lMessage.fSetText(tr("Pulzar Services returned null data!")); break;
  }
  if(lCustomText.simplified().isEmpty()) lMessage.fSetText(QString("%1").arg(lMessage.fText()));
  else lMessage.fSetText(QString("%1. %2").arg(lMessage.fText()).arg(lCustomText));
  return lMessage;
}

int CXMessagePool::fMessageType(int lCode) {
  if(lCode < 2000000)
    return CXDefinitions::ESuccessMessage;
  if(lCode < 3000000)
    return CXDefinitions::EInfoMessage;
  if(lCode < 4000000)
    return CXDefinitions::EErrorMessage;
  if(lCode < 5000000)
    return CXDefinitions::EWarningMessage;
  return CXDefinitions::EBugMessage;
}
