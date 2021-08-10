struct Swift_5_6: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_6
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Unavailability Condition",
                evolutionID: "SE-0290",
                description: "Swift historically supported the #available condition to check if a specific symbol is available for usage, but not the opposite. In this proposal, we'll present cases where checking for the unavailability of something is necessary, the ugly workaround needed to achieve it today and how a new #unavailable condition can fix it.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        if #unavailable(iOS 15.0) {
                            // Old functionality
                        } else {
                            // iOS 15 functionality
                        }
                        """
                    )
                ]
            ),
        ]
    }
}
