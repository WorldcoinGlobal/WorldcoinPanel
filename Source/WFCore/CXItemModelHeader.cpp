#include "CXItemModelHeader.h"

CXItemModelHeader::CXItemModelHeader(const QString& lTitle, int lDataType, QObject* pParent)
                 : QObject(pParent), mTitle(lTitle), mDataType(lDataType) {

}

CXItemModelHeader::~CXItemModelHeader() {

}

