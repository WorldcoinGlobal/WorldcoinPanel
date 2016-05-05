import qbs

DynamicLibrary {
  version: project.version

  name: "ConnectorBitcoin"
  targetName: "ConnectorBitcoin"

  destinationDirectory: project.installDirectory + "/Connectors"

  cpp.includePaths: [ '../../WFDefinitions', '../../WFCore' ]
  cpp.cxxLanguageVersion: "c++11"
  cpp.createSymlinks: false

  files: [ "*.cpp", "*.h" ]

  Depends { name: "WFDefinitions" }
  Depends { name: "WFCore" }
  Depends { name: "cpp" }
  Depends { name: "Qt"; submodules: ["core"]}
}

