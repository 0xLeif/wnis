let argument = CommandLine.arguments.dropFirst().first ?? "5.0"
let versionNumber = SwiftVersionNumber(rawValue: argument)

var swiftVersion: SwiftVersion

switch versionNumber {
case .swift5_0:
    swiftVersion = Swift_5_0()
default:
    swiftVersion = Swift_5_0()
}

let runner = Runner(version: swiftVersion)
runner.run()
