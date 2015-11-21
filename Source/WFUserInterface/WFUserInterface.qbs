import qbs
  
Product {
  version: project.version
  name: "WFUserInterface"

  Group {
    name: "AXLib"
    qbs.install: true
    qbs.installDir: "WFUserInterface/AXLib/"
    files: [ "AXLib/*.qml" ]
  }
  Group {
    name: "Theme_BlueBreeze_StyleSheet"
    qbs.install: true
    qbs.installDir: "WFUserInterface/BlueBreeze_Desktop/"
    files: [ "BlueBreeze_Desktop/*.qml" ]
  }
  Group {
    name: "Theme_BlueBreeze_Layout"
    qbs.install: true
    qbs.installDir: "WFUserInterface/BlueBreeze_Desktop/Layout"
    files: [ "BlueBreeze_Desktop/Layout/*.qml" ]
  }
  Group {
    name: "Theme_BlueBreeze_Images"
    qbs.install: true
    qbs.installDir: "WFUserInterface/BlueBreeze_Desktop/Images"
    files: [
      "BlueBreeze_Desktop/Images/*.png",
      "BlueBreeze_Desktop/Images/*.jpg",
      "BlueBreeze_Desktop/Images/*.svg"
    ]
  }
}
