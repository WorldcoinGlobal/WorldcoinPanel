import qbs

DynamicLibrary {
  version: project.version

  name: "WFObjects"
  targetName: "WFObjects"

  destinationDirectory: project.installDirectory

  cpp.includePaths: [ '../WFDefinitions','../WFCore' ]
  cpp.defines: ["WFOBJECTS_LIBRARY"]
  cpp.cxxLanguageVersion: "c++11"

  files: [ "*.cpp", "*.h" ]

  Depends { name: "WFDefinitions"; }
  Depends { name: "WFCore"; }
  Depends { name: "cpp" }
  Depends { name: "Qt"; submodules: ["core", "gui", "quick", "websockets","widgets"]}
}
