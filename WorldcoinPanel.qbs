import qbs

Project {
  property string version: "2.0.1"
  Properties {
    condition: qbs.targetOS.contains("linux")
    property string QJsonRpcIncludePath: "/home/Berzeck/Data/Development/Libraries/QJsonRpc/include/qjsonrpc"
    property string QJsonRpcLibPath: "/home/Berzeck/Data/Development/Libraries/QJsonRpc/lib"
    property string installDirectory: "/home/Berzeck/Applications/WorldcoinPanel"
  }
  Properties {
    condition: qbs.targetOS.contains("windows")
    property string QJsonRpcIncludePath: "D:/Development/Libraries/QJsonRpc/bin/include/qjsonrpc"
    property string QJsonRpcLibPath: "D:/Development/Libraries/QJsonRpc/bin/lib"
    property string installDirectory: "D:/Development/Berzeck/WorldcoinPanel/Binary"
  }
  name: "WorldcoinPanel"
  references: [
    "Source/WFDefinitions/WFDefinitions.qbs",
    "Source/WFCore/WFCore.qbs",
    "Source/WFConnectors/WFConnectors.qbs",
    "Source/WFObjects/WFObjects.qbs",
    "Source/WFWapptoms/WFWapptoms.qbs",
    "Source/WorldcoinPanel/WorldcoinPanel.qbs",
    "Source/WFUserInterface/WFUserInterface.qbs",
    "Source/Components/Components.qbs"
  ]
}
