#ifndef HXOBJECTS_H
#define HXOBJECTS_H

#include <QtCore/qglobal.h>

#if defined(WFOBJECTS_LIBRARY)
#  define WFOBJECTS_EXPORT Q_DECL_EXPORT
#else
#  define WFOBJECTS_EXPORT Q_DECL_IMPORT
#endif

#endif // HXOBJECTS_H

