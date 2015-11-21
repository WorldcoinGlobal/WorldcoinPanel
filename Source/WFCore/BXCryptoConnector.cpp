#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <qjsonrpcglobal.h>
#include <qjsonrpcmessage.h>
#include <qjsonrpcservicereply.h>
#include <QSettings>
#include <QTextStream>
#include <CXDefinitions.h>

#include "BXCryptoConnector.h"
#include "BXGuiApplication.h"
#include "CXMessage.h"
#include "CXMessagePool.h"
#include "CXRcpClient.h"

BXCryptoConnector::~BXCryptoConnector() {

}

bool BXCryptoConnector::fCheckParameters() {
  QStringList lParameters;
  lParameters << fLabel();
  if(mBinaryName.isEmpty()) {
    lParameters << "BinaryName";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
  if(mUser.isEmpty()) {
    lParameters << "User";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
  if(mPassword.isEmpty()) {
    lParameters << "Password";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
  if(mPort.isEmpty()) {
    lParameters << "Port";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
  if(mRpcPort.isEmpty()) {
    lParameters << "RpcPort";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
  if(mPidFileName.isEmpty()) {
    lParameters << "PidFile";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
  if(mLockFileName.isEmpty()) {
    lParameters << "LockFile";
    emit sLogMessageRequest(3200005, lParameters, QString(), CXDefinitions::ELogAll);
    return false;
  }
 return true;
}

bool BXCryptoConnector::fCreateConfFile(const QString& lDataDirName) {
  QFile lConf(QString("%1/%2").arg(lDataDirName).arg(fConfigFile()));
  if(lConf.open(QFile::WriteOnly | QFile::Truncate)) {
    QTextStream lOut(&lConf);
    lOut << QString("rpcuser=%1").arg(mUser) << endl
         << QString("rpcpassword=%1").arg(mPassword) << endl
         << QString("rpcport=%1").arg(mRpcPort) << endl
         << QString("port=%1").arg(mPort) << endl
         << QString("daemon=1") << endl
         << QString("server=1") << endl
         << QString("gen=0") << endl
         << QString("listen=1") << endl
         << QString("testnet=0") << endl
         << QString("maxconnections=100") << endl
         << QString("rpcthreads=10") << endl;
  }
  else {
    emit sLogMessageRequest(3200009, QStringList() << fConfigFile(), tr("Connector: '%1'").arg(fLabel()), CXDefinitions::ELogAll);
    return false;
  }
  return true;
}

bool BXCryptoConnector::fCreateDataDir(const QString& lDataDirName) {
  QDir lDataDir(lDataDirName);
  if(!lDataDir.exists(lDataDirName) && !lDataDir.mkpath(lDataDirName)) {
    emit sLogMessageRequest(3200002, QStringList() << lDataDirName, tr("Connector: '%1'").arg(fLabel()), CXDefinitions::ELogAll);
    return false;
  }
  return true;
}

bool BXCryptoConnector::fKillDaemon(const QString& lDataDirName) {
//  tStop();
  QProcess lKill;
  if(CXDefinitions::fCurrentOS() == CXDefinitions::ELinuxOS) lKill.start("pkill", QStringList() << "-9" << mBinaryName);
  if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) lKill.start("taskkill", QStringList() << "/F" << "/IM" << mBinaryName);
  lKill.waitForFinished();
  QEventLoop lDaemonLoop;
  QTimer::singleShot(cKillDaemonWaitTime, &lDaemonLoop, &QEventLoop::quit);
  lDaemonLoop.exec();
 // tStop(); // Otherwise ports are still open

  QFile fLock(QString("%1/%2").arg(lDataDirName).arg(mLockFileName));
  if(fLock.exists() && !fLock.remove()) {
    emit sLogMessageRequest(3200004, QStringList() << mLockFileName, tr("Connector: '%1'").arg(fLabel()), CXDefinitions::ELogAll);
    return false;
  }
  QFile fPid(QString("%1/%2").arg(lDataDirName).arg(mPidFileName));
  if(fPid.exists() && !fPid.remove()) {
    emit sLogMessageRequest(3200004, QStringList() << mPidFileName, tr("Connector: '%1'").arg(fLabel()), CXDefinitions::ELogAll);
    return false;
  }
  return true;
}

void BXCryptoConnector::fLoadCommandDefinitions(const QString& lFileName) {
  mCommandDefinitions.clear();
  QSettings lSettings(lFileName, QSettings::IniFormat);
  lSettings.beginGroup(fName());
  QStringList lKeys(lSettings.allKeys());
  for(const QString& lKey : lKeys) {
    QStringList lTypes(lSettings.value(lKey).toString().split(","));
    QList<int> lJsonTypes;
    for(const QString& lRawType : lTypes) {
      QString lType(lRawType.simplified());
      if(!lType.isEmpty() && lType != "Bool" && lType != "String" && lType != "Array" && lType != "Double" && lType != "Object") {
        emit sLogMessageRequest(5200008, QStringList() << fName() << lFileName << lKey, QString(), CXDefinitions::ELogAll);
        return;
      }
      if(lType == "Bool") lJsonTypes << QJsonValue::Bool;
      if(lType == "Array") lJsonTypes << QJsonValue::Array;
      if(lType == "Double") lJsonTypes << QJsonValue::Double;
      if(lType == "String") lJsonTypes << QJsonValue::String;
      if(lType == "Object") lJsonTypes << QJsonValue::Object;
    }
    mCommandDefinitions.insert(lKey, lJsonTypes);
  }
  lSettings.endGroup();
  if(mCommandDefinitions.size() == 0) emit sLogMessageRequest(5200009, QStringList() << fName() << lFileName, QString(), CXDefinitions::ELogAll);
}

QStringList BXCryptoConnector::fParse(const QString& lInput) const {
  QStringList lParsedInput;
  lParsedInput << QString();
  QString lSimpleInput;

  bool lInString = false;
  bool lMultipleSpace = true;

// Simplify (Remove spaces)
  for(int i = 0; i < lInput.size(); i++) {
    if(lInput.at(i) == QChar('\"')) lInString = !lInString;
    if(lInput.at(i) == QChar(' ') && (!lMultipleSpace || lInString)) { lSimpleInput +=  QChar(' '); lMultipleSpace = true; }
    if(lInput.at(i) != QChar(' ')) { lSimpleInput += lInput.at(i); lMultipleSpace = false; }
  }
  if(lSimpleInput.right(1) == QChar(' ')) lSimpleInput = lSimpleInput.left(lSimpleInput.size() - 1);
// Extract params
  int lParamCount = 0;
  lInString = false;
  for(int i = 0; i < lSimpleInput.size(); i++) {
    if(lSimpleInput.at(i) == QChar('\"')) { lInString = !lInString; continue; }
    if(lSimpleInput.at(i) != QChar(' ')) lParsedInput[lParamCount] += lSimpleInput.at(i);
    if((lSimpleInput.at(i) == QChar(' ')) && lInString)  lParsedInput[lParamCount] += lSimpleInput.at(i);
    if((lSimpleInput.at(i) == QChar(' ')) && !lInString) { lParamCount++; lParsedInput << QString(); }
  }
  return(lParsedInput);
}

bool BXCryptoConnector::tEndService() {
  return tStop();
}

bool BXCryptoConnector::tRestart() {
  if(tStop()) {
    if(tStart()) return true;
    else return false;
  }
  return false;
}

void BXCryptoConnector::fSetup() {
  fSetStatus(CXDefinitions::EServiceStopped);
  QString lRpcUrl(QString("http://127.0.0.1:%1").arg(mRpcPort));
  rRpc = new CXRcpClient(lRpcUrl,mUser,mPassword, this);
  if(!rRpc->isValid()) {
    emit sLogMessageRequest(3200012, QStringList() << fName() << lRpcUrl, QString(), CXDefinitions::ELogAll);
    fSetStatus(CXDefinitions::EServiceError);
  }
  rRpcReply = nullptr;
  connect(&mTimer, &QTimer::timeout, this, &BXCryptoConnector::tTryConnection);
}

void BXCryptoConnector::fSetStatus(int lStatus) {
  mStatus = lStatus;

  emit sStatusChanged(fName(), mStatus);
  if(lStatus == CXDefinitions::EServiceProcessing)
    mTimer.start(cDefaultSampleTime);
  else {
    emit sProcessingFinished();
    mTimer.stop();
  }
}

void BXCryptoConnector::tLoadSettings() {
  QSettings lSettings(cDaemonsConf, QSettings::IniFormat);
  lSettings.beginGroup(fName());
  mBinaryName = lSettings.value("BinaryName").toString();
  mDataDirectory = lSettings.value("DataDirectory").toString();
  mUser = lSettings.value("User").toString();
  mPassword = lSettings.value("Password").toString();
  mPort = lSettings.value("Port").toString();
  mRpcPort = lSettings.value("RpcPort").toString();
  mPidFileName = lSettings.value("PidFile").toString();
  mLockFileName = lSettings.value("LockFile").toString();
  lSettings.endGroup();

  fLoadCommandDefinitions(cCommandDefinitions);
}

bool BXCryptoConnector::tExecute(int lRequestType, quint64 lRequestID, const QString& lInput, const QString &lOutput, bool lResponseStateIsAnswer, bool lParse, int lLogType) {
  if(fStatus() == CXDefinitions::EServiceError) return false;
  QString lMethod;
  QStringList lParams(fParse(lInput));
  lMethod = lParams.takeFirst();
  if(!mCommandDefinitions.contains(lMethod)) {
    CXMessage lMessage(CXMessagePool::fMessage(4200002, QStringList() << fName() << lMethod, QString()));
    emit sReply(false, lRequestID, lMessage.fText());
    return false;
  }
  QList<int> lJsonTypes(mCommandDefinitions.value(lMethod));
  QJsonArray lJsonParams;
  if(lJsonTypes.size() < lParams.size()) {
    CXMessage lMessage(CXMessagePool::fMessage(4200003, QStringList() << fName() << lMethod, QString()));
    emit sReply(false, lRequestID, lMessage.fText());
    return false;
  }
  for(int i = 0; i < lParams.size(); i++) {
    bool lOk = false;
    if(lJsonTypes.at(i) == QJsonValue::Bool) {
      bool lParamValue = lParams.at(i).toInt(&lOk);
      if(!lOk) {
        CXMessage lMessage(CXMessagePool::fMessage(4200004, QStringList() << fName() << lMethod << lParams.at(i), QString()));
        emit sReply(false, lRequestID, lMessage.fText());
        return false;
      }
      lJsonParams << QJsonValue(lParamValue);
    }
    if(lJsonTypes.at(i) == QJsonValue::Double) {
      double lParamValue = lParams.at(i).toDouble(&lOk);
      if(!lOk) {
        CXMessage lMessage(CXMessagePool::fMessage(4200004, QStringList() << fName() << lMethod << lParams.at(i), QString()));
        emit sReply(false, lRequestID, lMessage.fText());
        return false;
      }
      lJsonParams << QJsonValue(lParamValue);
    }
    if(lJsonTypes.at(i) == QJsonValue::String) {
      QString lParamValue = lParams.at(i);
      lJsonParams << QJsonValue(lParamValue);
    }
  }
  QJsonRpcMessage message = QJsonRpcMessage::createRequest(lMethod, lJsonParams);
  rRpcReply = rRpc->sendMessage(message);
  rRpcReply->setProperty("yInput", lInput);
  rRpcReply->setProperty("yOutput", lOutput);
  rRpcReply->setProperty("yRequestID", lRequestID);
  rRpcReply->setProperty("yRequestType", lRequestType);
  rRpcReply->setProperty("yResponseStateIsAnswer", lResponseStateIsAnswer);
  rRpcReply->setProperty("yParse", lParse);
  rRpcReply->setProperty("yLogType", lLogType);
  connect(rRpcReply, &QJsonRpcServiceReply::finished, this, &BXCryptoConnector::tSendReply);

  return true;
}

void BXCryptoConnector::tSendReply() {
  bool lSuccess = false;
  QJsonRpcServiceReply* pReply = qobject_cast<QJsonRpcServiceReply*> (sender());
  QJsonRpcMessage lResponse = pReply->response();
  QString lInput(pReply->property("yInput").toString());
  QString lOutput(pReply->property("yOutput").toString());
  QString lRequestID(pReply->property("yRequestID").toString());
  bool lResponseStateIsAnswer(pReply->property("yResponseStateIsAnswer").toInt());
  bool lParse(pReply->property("yParse").toInt());
  QString lObjResponse;
  if((lResponse.type() == QJsonRpcMessage::Error || lResponse.type() == QJsonRpcMessage::Invalid) && !lResponseStateIsAnswer) {
    static int lMessageCounter = 0;
    lMessageCounter += 1;
    if(lMessageCounter == 1 ) {
      int lCode;
      QStringList lParams;
      switch(lResponse.errorCode()) {
        case QJsonRpc::InternalError:  // The signal is emitted twice when connection is refused
          lCode = 4200001;
          lParams << fName();
          break;
        case QJsonRpc::ParseError:
          lCode = 3200021;
          lParams << fName() << lRequestID << lInput << lResponse.errorData().toString();
          break;
        case QJsonRpc::InvalidRequest:  // The signal is emitted twice when connection is refused
          lCode = 3200020;
          lParams << fName() << lRequestID << lInput << lResponse.errorData().toString();
          break;
        case QJsonRpc::MethodNotFound:
          lCode = 3200018;
          lParams << fName() << lRequestID << lInput << lResponse.errorData().toString();
          break;
        case QJsonRpc::InvalidParams:  // The signal is emitted twice when connection is refused
          lCode = 3200019;
          lParams << fName() << lRequestID << lInput << lResponse.errorData().toString();
          break;
        default:
          lCode = 3200013;
          lParams << fName() << lResponse.errorMessage() << QString::number(lResponse.errorCode());
      }
      emit sLogMessageRequest(lCode, lParams, QString(), CXDefinitions::ELogAll);
      CXMessage lMessage(CXMessagePool::fMessage(lCode, lParams, QString()));
      emit sReply(lSuccess, lRequestID.toULongLong(), lMessage.fText());
    }
    if(lMessageCounter == 2) lMessageCounter = 0;
  }
  else {
    QJsonValue lResult(lResponse.toObject().value(cDefaultRcpResult));
    int lLogType = pReply->property("yLogType").toInt();
    if(lParse) {
      if(lResponseStateIsAnswer) {
        if(lResponse.type() == QJsonRpcMessage::Error || lResponse.type() == QJsonRpcMessage::Invalid) lObjResponse = "0";
        else lObjResponse = "1";
      }
      else lObjResponse = fParseResponse(lResult, lOutput, lRequestID, 0);
      lSuccess = true;
      if(pReply->property("yRequestType").toInt() != CXDefinitions::EWapptom) emit sLogMessageRequest(1200003, QStringList() << fName() << lRequestID << lInput, QString(), lLogType);
      emit sReply(lSuccess, lRequestID.toULongLong(), lObjResponse);
    }
    else {
      lSuccess = true;
      if(pReply->property("yRequestType").toInt() != CXDefinitions::EWapptom) emit sLogMessageRequest(1200003, QStringList() << fName() << lRequestID << lInput, QString(), lLogType);
      emit sReplyJson(lSuccess, lRequestID.toULongLong(), lResult);
    }
  }
 // mProcessing = false;  
  pReply->deleteLater();
}

QString BXCryptoConnector::fParseResponse(const QJsonValue& lResult, const QString& lOutput, const QString &lRequestID, int lIndentation) {
  QString lObjResponse;
  if(lResult.type() == QJsonValue::Double) {
    QString lInd; lInd.fill(' ', lIndentation);
    lObjResponse.setNum(lResult.toDouble(), 'f', cDefaultPrecision);
    if(lOutput.isEmpty()) lObjResponse.prepend(lInd);
   }
  if(lResult.type() == QJsonValue::String) {
    QString lInd; lInd.fill(' ', lIndentation);
    lObjResponse = lResult.toString();
    if(lOutput.isEmpty()) lObjResponse.prepend(lInd);
   }
  if(lResult.type() == QJsonValue::Bool) {
    QString lInd; lInd.fill(' ', lIndentation);
    lObjResponse = lResult.toString();
      if(lOutput.isEmpty()) lObjResponse.prepend(lInd);

    lObjResponse.setNum(lResult.toBool());
  }
  if(lResult.type() == QJsonValue::Array) {
    QString lInd; lInd.fill(' ', lIndentation);
    if(lOutput.isEmpty()) {
      QJsonArray lJsonArray(lResult.toArray());
      lObjResponse += lInd + "[\n";
      lIndentation += 2;
      int i = 0;
      for(const QJsonValue& lValue : lJsonArray) {
        lObjResponse += fParseResponse(lValue, lOutput, lRequestID, lIndentation);
        if(i < lJsonArray.size() - 1) lObjResponse += ",\n";
        i++;
      }
      lObjResponse += lInd + "\n]";
    }
    else {
      QJsonArray lJsonArray(lResult.toArray());
      int i = 0;
      for(const QJsonValue& lValue : lJsonArray) {
        if(!lValue.toObject().contains(lOutput)) emit sLogMessageRequest(5200007, QStringList() << lRequestID << lOutput , QString(), CXDefinitions::ELogAll);
        else
          lObjResponse += fParseResponse(lValue.toObject().value(lOutput), lOutput, lRequestID, lIndentation);
        if(i < lJsonArray.size() - 1) lObjResponse += ",";
        i++;
      }
    }
  }
  if(lResult.type() == QJsonValue::Object) {
    if(lOutput.isEmpty()) {
      QString lInd; lInd.fill(' ', lIndentation);
      lObjResponse += lInd + "{\n";
      QStringList lKeys = lResult.toObject().keys();
      lIndentation += 2;
      QString lSep = ",";
      for(int i = 0; i < lKeys.size(); i++) {
        QString lKey = lKeys[i];
        QJsonValue lResult2(lResult.toObject().value(lKey));
        QString lInd; lInd.fill(' ', lIndentation);
        if(i == lKeys.size() - 1) lSep.clear();
        lObjResponse += lInd + QString("%1: %2").arg(lKey).arg(fParseResponse(lResult2,  lOutput, lRequestID, lIndentation)) + lSep + "\n" ;
      }
      lObjResponse += lInd + "}";
    }
    else {
      if(!lResult.toObject().contains(lOutput)) emit sLogMessageRequest(5200007, QStringList() << lRequestID << lOutput , QString(), CXDefinitions::ELogAll);
      else lObjResponse = fParseResponse(lResult.toObject().value(lOutput), lOutput, lRequestID, lIndentation);
    }
  }
  return lObjResponse;
}

bool BXCryptoConnector::tStop() {    
  QProcess lDaemon;
  fSetStatus(CXDefinitions::EServiceStopped);
  QFile lDaemonFile(QString("%1/%2/%3").arg(qApp->applicationDirPath()).arg(cDaemonsDir).arg(mBinaryName));
  if(lDaemonFile.exists()) {
    QEventLoop lDaemonLoop;
    if(mStatus == CXDefinitions::EServiceProcessing) {
      connect(this, &BXCryptoConnector::sProcessingFinished, &lDaemonLoop, &QEventLoop::quit);
      lDaemonLoop.exec();
    }    
    lDaemon.start(lDaemonFile.fileName(), QStringList() << QString("-conf=%1/%2").arg(mDataDirectory).arg(fConfigFile()) << QString("-datadir=%1").arg(mDataDirectory) << QString("stop"));
    QTimer::singleShot(5000,&lDaemonLoop, SLOT(quit()));
    connect(&lDaemon, SIGNAL(finished(int)), &lDaemonLoop, SLOT(quit()));
    lDaemonLoop.exec();
  }
  mTimer.stop();
  return true;
}

bool BXCryptoConnector::tStart() {
  if(CXDefinitions::fCurrentOS() == CXDefinitions::EWindowsOS) mBinaryName = mBinaryName + ".exe";
  //if(CXDefinitions::fCurrentOS() == CXDefinitions::ELinuxOS) mBinaryName = mBinaryName + ".exe";

  if(fStatus() == CXDefinitions::EServiceError) return false;
  fSetStatus(CXDefinitions::EServiceProcessing);
  if(!fCheckParameters()) {
    fSetStatus(CXDefinitions::EServiceError);
    return false;
  }
  if(!fCreateDataDir(mDataDirectory)) {
    fSetStatus(CXDefinitions::EServiceError);
    return false;
  }
  if(!fCreateConfFile(mDataDirectory)) {
    fSetStatus(CXDefinitions::EServiceError);
    return false;
  }
  if(!fKillDaemon(mDataDirectory)) {
    fSetStatus(CXDefinitions::EServiceError);
    return false;
  }
  QFile lDaemonFile(QString("%1/%2/%3").arg(qApp->applicationDirPath()).arg(cDaemonsDir).arg(mBinaryName));
  if(!lDaemonFile.exists()) {
    emit sLogMessageRequest(3200010, QStringList() << lDaemonFile.fileName(), tr("Connector: '%1'").arg(fLabel()), CXDefinitions::ELogAll);
    if(fName() == cDefaultDaemon) {
      fSetStatus(CXDefinitions::EServiceError);
      return false;
    }
  }
  else mDaemon.start(lDaemonFile.fileName(), QStringList() << QString("-conf=%1/%2").arg(mDataDirectory).arg(fConfigFile()) << QString("-datadir=%1").arg(mDataDirectory) << QString("-rpcwait"));
  return true;
}

void BXCryptoConnector::tEvaluateConnection() {
  QJsonRpcMessage lResponse = qobject_cast<QJsonRpcServiceReply*> (sender())->response();
  if(lResponse.type() == QJsonRpcMessage::Error || lResponse.type() == QJsonRpcMessage::Invalid) {
    if(lResponse.errorCode() == QJsonRpc::InternalError) {  // The signal is emitted twice when connection is refused
      static int lMessageCounter = 0;
      lMessageCounter += 1;
      if(lMessageCounter == 1 ) {
        static int lTryCounter = 0;
        lTryCounter += 1;
        if(lTryCounter == cDefaultMaxTries) {
          emit sLogMessageRequest(3200014, QStringList() << fName(), QString(), CXDefinitions::ELogAll);
          fSetStatus(CXDefinitions::EServiceError);
        }
        else emit sLogMessageRequest(4200001, QStringList() << fName(), QString(), CXDefinitions::ELogAll);
      }
      if(lMessageCounter == 2 ) lMessageCounter = 0;
    }
  }
  else {
    emit sLogMessageRequest(2200006, QStringList() << fName(), QString(), CXDefinitions::ELogAll);
    fSetStatus(CXDefinitions::EServiceReady);
  }
}

void BXCryptoConnector::tTryConnection() {
  if(fStatus() != CXDefinitions::EServiceProcessing) return;
  QJsonRpcMessage message = QJsonRpcMessage::createRequest(fTestConnectionCommand());
  rRpcTestConnectonReply = rRpc->sendMessage(message);
  connect(rRpcTestConnectonReply, &QJsonRpcServiceReply::finished, this, &BXCryptoConnector::tEvaluateConnection);
}
