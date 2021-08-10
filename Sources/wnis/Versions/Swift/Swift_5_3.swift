struct Swift_5_3: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_3
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Multi-pattern catch clauses",
                evolutionID: "SE-0276",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Multiple trailing closures",
                evolutionID: "SE-0279",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Synthesized Comparable conformance for enums",
                evolutionID: "SE-0266",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "self is no longer required in many places",
                evolutionID: "SE-0269",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Type-Based Program Entry Points",
                evolutionID: "SE-0281",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "where clauses on contextually generic declarations",
                evolutionID: "SE-0267",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Enum cases as protocol witnesses",
                evolutionID: "SE-0280",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Refined didSet Semantics",
                evolutionID: "SE-0268",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "A new Float16 type",
                evolutionID: "SE-0277",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Swift Package Manager gains binary dependencies, resources, and more",
                evolutionID: "SE-0271, SE-0272, SE-0273",
                description: "",
                examples: []
            )
        ]
    }
}
