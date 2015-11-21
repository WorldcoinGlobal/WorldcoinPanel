#include <QCursor>
#include <QQuickItem>
#include "BXWapptom.h"
#include "GXSubWindow.h"

GXSubWindow::GXSubWindow(QQuickItem* lParent )
           : QQuickItem(lParent), mActive(false)  {
  setClip(true);
}
