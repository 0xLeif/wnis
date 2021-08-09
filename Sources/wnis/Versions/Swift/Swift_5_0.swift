struct Swift_5_0: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_0
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Raw strings",
                evolutionID: "SE-0200",
                description: "Raw strings added the ability to create raw strings, where backslashes and quote marks are interpreted as those literal symbols rather than escapes characters or string terminators. This makes a number of use cases more easy, but regular expressions in particular will benefit. To use raw strings, place one or more # symbols before and after your string.",
                examples: [
                    SwiftCodeExample(
                        code: ##"print(#""Raw" Strings \(value)"#)"##,
                        output: {
                            #""Raw" Strings \(value)"#
                        }
                    )
                ]
            ),
            
            SwiftChange(
                name: "Result type",
                evolutionID: "SE-0235",
                description: "Swift’s Result type is implemented as an enum that has two cases: success and failure. Both are implemented using generics so they can have an associated value of your choosing, but failure must be something that conforms to Swift’s Error type.",
                examples: [
                    SwiftCodeExample(
                        code: #"""
                        func fetchData() -> Result<String, Error> {
                            // ...
                            return .success("DATA")
                            // ...
                            return .failure(Error)
                        }
                        """#,
                        output: {
                            try! Result<String, Error>.success("DATA").get()
                        }
                    )
                ]
            )
        ]
    }
}
