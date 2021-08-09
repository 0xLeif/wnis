enum InputHandler {
    enum InputOutcome {
        case success
        case retry
        case fail
    }
    
    static func handleInput(
        message: String,
        outcomes: [String: InputOutcome]
    ) -> Bool {
        var outcome: InputOutcome = .retry
        
        while outcome == .retry {
            print("\(message): ", terminator: "")
            
            if let input = readLine(),
               let inputOutcome = outcomes[input] {
                outcome = inputOutcome
            }
        }
        
        return outcome == .success
    }
}
