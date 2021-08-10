enum MainRunner {
    static func run() {
        var argument: String? = CommandLine.arguments.dropFirst().first

        while argument == nil {
            argument = InputHandler.getInput(
                message: "What's new in Swift (\(SwiftVersionNumber.allCases.map(\.rawValue).joined(separator: ", ")))",
                outcomes: SwiftVersionNumber.allCases.reduce(
                    into: [String: InputHandler.InputOutcome](),
                    { versions, version in
                        versions[version.rawValue] = .success
                    }
                )
            )
        }

        let versionNumber = SwiftVersionNumber(rawValue: argument!)
        let version: SwiftVersion = versionNumber!.swiftVersion
        
        print("# What's new in Swift \(version.versionNumber.rawValue)?\n")

        guard InputHandler.handleInput(
            message: "Start (y/n)",
            outcomes: [
                "y": .success,
                "n": .fail
            ]
        ) else {
            return
        }

        for change in version.changes {
            guard InputHandler.handleInput(
                message: "\(change.evolutionID): \(change.name) (y/n)",
                outcomes: [
                    "y": .success,
                    "n": .fail
                ]
            ) else {
                continue
            }
            
            print(
                """
                Name: \(change.name)
                Evolution ID: \(change.evolutionID)

                Description: \(change.description)\n
                """
            )
            
            if let examples = change.examples {
                for example in examples {
                    guard InputHandler.handleInput(
                        message: "See an example (y/n)",
                        outcomes: [
                            "y": .success,
                            "n": .fail
                        ]
                    ) else {
                        continue
                    }
                    
                    if let output = example.output {
                        print(
                            """
                            Code: \(example.code)

                            Output: \(output())\n
                            """
                        )
                    } else {
                        print(
                            """
                            Code: \(example.code)\n
                            """
                        )
                    }
                }
            }
        }
    }
}
