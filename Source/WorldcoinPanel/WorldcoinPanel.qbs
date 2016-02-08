import qbs

Product {
  version: project.version

  consoleApplication: false
  name: "WorldcoinPanel"
  type: "application"
  targetName: { return "WorldcoinPanel" }

  destinationDirectory: project.installDirectory

  cpp.defines: base.concat(["WORLDCOINPANEL_VERSION=" + "\"" + version + "\""])
  cpp.includePaths: [ '../WFDefinitions', '../WFCore', '../WFObjects', project.QJsonRpcIncludePath ]
  cpp.libraryPaths: [ project.installDirectory, project.QJsonRpcLibPath ]
  cpp.rpaths: qbs.targetOS.contains("linux") ? ["$ORIGIN", "$ORIGIN/.."] : []
  cpp.cxxLanguageVersion: "c++11"
  cpp.dynamicLibraries: ["WFDefinitions", "WFCore", "WFObjects" ]

  cpp.staticLibraries: [ "qjsonrpc" ]

  files: [ "*.cpp", "*.h"]
  Depends { name: "WFDefinitions" }
  Depends { name: "WFObjects" }
  Depends { name: "WFCore" }
  Depends { name: "cpp" }
  Depends { name: "Qt"; submodules: ["core","gui","quick", "websockets","widgets"] }
}

