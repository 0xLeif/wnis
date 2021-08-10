struct Swift_5_4: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_4
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Improved implicit member syntax",
                evolutionID: "SE-0287",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Multiple variadic parameters in functions",
                evolutionID: "SE-0284",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Local functions now support overloading",
                evolutionID: "SR-10069",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Result builders",
                evolutionID: "SE-0289",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Packages can now declare executable targets",
                evolutionID: "SE-0294",
                description: "",
                examples: []
            )
        ]
    }
}
