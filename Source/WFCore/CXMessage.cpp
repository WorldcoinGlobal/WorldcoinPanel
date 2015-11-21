#include "CXMessage.h"

CXMessage::CXMessage(int lType, int lCode, const QString& lText, const QString& lHelpText, const QString& lCustomText)
         : mCode(lCode), mType(lType), mCustomText(lCustomText), mHelpText(lHelpText), mText(lText) {

}

CXMessage::~CXMessage() {

}

