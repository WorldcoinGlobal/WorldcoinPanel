#ifndef HXCORE_H
#define HXCORE_H

#include <QtCore/qglobal.h>

#if defined(WFCORE_LIBRARY)
#  define WFCORE_EXPORT Q_DECL_EXPORT
#else
#  define WFCORE_EXPORT Q_DECL_IMPORT
#endif

#endif // HXCORE_H

