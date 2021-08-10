struct Swift_5_2: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_2
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Key Path Expressions as Functions",
                evolutionID: "SE-0249",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Callable values of user-defined nominal types",
                evolutionID: "SE-0249",
                description: "",
                examples: []
            )
        ]
    }
}
