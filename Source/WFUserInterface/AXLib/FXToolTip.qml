import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Item {
  id: root
  width: toolTip.contentWidth
  height: toolTipContainer.height
  visible: false
  clip: false
 // z: 999999999

  property alias text: toolTip.text
  property alias radius: content.radius
  property alias backgroundColor: content.color
  property alias textColor: toolTip.color
  property alias font: toolTip.font
  property var target: null

 /* function onMouseHover(x, y) {
    var obj = root.target.mapToItem(root.parent, x, y);
    root.x = obj.x;
    root.y = obj.y + 5;
  }*/
  function fuCalculateFixedXY(x, y) {
    var obj = root.target.mapToItem(root.parent, x, y);
    if(obj.x + root.width + 20 > root.parent.width) root.x = root.parent.width - root.width - 20
    else root.x = obj.x
    if(obj.y + root.height + 20 > root.parent.height) root.y = root.parent.height - root.height - 20
    else root.y = obj.y + target.height + 5;
  }

  function onVisibleStatus(flag) {
    root.visible = flag
    fuCalculateFixedXY(0,0)
  }
  function onClick() { root.target.fuClicked() }

  Component.onCompleted: {
    var itemParent = root.target;
    var newObject = Qt.createQmlObject('import QtQuick 2.5;
        MouseArea {
          signal mouserHover(int x, int y);
          signal showChanged(bool flag);
          signal siClicked()
          anchors.fill: parent;
          propagateComposedEvents: true;
          hoverEnabled: true;
          onPositionChanged: {mouserHover(mouseX, mouseY)}
          onEntered: {showChanged(true)}
          onExited:{showChanged(false)}
          onClicked:{parent.focus = true; siClicked()}
        }',
        itemParent, "mouseItem");
  //  newObject.mouserHover.connect(onMouseHover);
    newObject.showChanged.connect(onVisibleStatus);
    newObject.siClicked.connect(onClick);
  }

  Item {
    id: toolTipContainer
    z: root.z + 1
    width: content.width + (2*toolTipShadow.radius)
    height: content.height + (2*toolTipShadow.radius)

    Rectangle {
      id: content
      anchors.centerIn: parent
      width: root.width
      height: toolTip.contentHeight + 10
      Text {
        id: toolTip
        anchors {fill: parent; margins: 5}
        wrapMode: Text.WordWrap
      }
    }
  }
  states: [
    State { when: root.visible;
      PropertyChanges { target: content; opacity: 1.0    }
    },
    State { when: !root.visible;
      PropertyChanges { target: content; opacity: 0.0    }
    }
  ]
  transitions: Transition {
    NumberAnimation { target: content; property: "opacity"; duration: 800}
  }
  DropShadow {
    id: toolTipShadow
    z: root.z + 1
    anchors.fill: source
    cached: true
    horizontalOffset: 4
    verticalOffset: 4
    radius: 8.0
    samples: 16
    color: "#80000000"
    smooth: true
    source: toolTipContainer
  }

//  Behavior on visible { NumberAnimation { duration: 1000 }}
}
