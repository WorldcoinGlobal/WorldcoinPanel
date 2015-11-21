#include <QCursor>

#include "GXWindow.h"
#include "BXGuiApplication.h"

GXWindow::GXWindow(QWindow* lParent )
        : QQuickWindow(lParent)  {

}

QString GXWindow::fDaemonSetting(const QString& lDaemon, const QString& lParameter) const {
  return BXGuiApplication::fDaemonSetting(lDaemon, lParameter);
}

QString GXWindow::fDefaultDaemon() const {
  return BXGuiApplication::fDefaultDaemon();
}
