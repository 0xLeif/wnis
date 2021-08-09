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
                break
            }
            
            print(
                """
                Name: \(change.name)
                Evolution ID: \(change.evolutionID)

                Description: \(change.description)

                Code Example: \(change.exampleCode)
                
                Code Example Output: \(change.example())\n
                """
            )
        }

    }
}
