struct Runner {
    let version: SwiftVersion
    
    func run() {
        print("What's new in Swift \(version.versionNumber.rawValue)?\n")

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
            
            for example in change.examples {
                guard InputHandler.handleInput(
                    message: "See an example (y/n)",
                    outcomes: [
                        "y": .success,
                        "n": .fail
                    ]
                ) else {
                    continue
                }
                
                print(
                    """
                    Code: \(example.code)

                    Output: \(example.output())\n
                    """
                )
            }
        }

    }
}
