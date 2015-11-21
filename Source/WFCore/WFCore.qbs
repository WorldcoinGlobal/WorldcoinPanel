import qbs

DynamicLibrary {
  version: project.version

  name: "WFCore"
  targetName: "WFCore"

  destinationDirectory: project.installDirectory

  cpp.includePaths: [ '../WFDefinitions', project.QJsonRpcIncludePath/*, project.QOpenSSLIncludePath */]
  cpp.libraryPaths: [ project.QJsonRpcLibPath ]
  cpp.staticLibraries: [ "qjsonrpc" ]
  cpp.defines: ["WFCORE_LIBRARY"]
  cpp.cxxLanguageVersion: "c++11"

  files: [ "*.cpp", "*.h" ]

  Depends { name: "WFDefinitions" }
  Depends { name: "cpp" }
  Depends { name: "Qt"; submodules: ["core", "gui", "network", "quick", "websockets"]}
}

