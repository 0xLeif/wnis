struct Swift_5_0: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_0
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Enhancing String Literals Delimiters to Support Raw Text",
                evolutionID: "SE-0200",
                description: "We propose to alter Swift's string literal design to do the same, using a new design which we believe fits Swift's simple and clean syntax. This design supports both single-line and multi-line string literals, and can contain any content whatsoever.",
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
                name: "Add Result to the Standard Library",
                evolutionID: "SE-0235",
                description: "Swift's current error-handling, using throws, try, and catch, offers automatic and synchronous handling of errors through explicit syntax and runtime behavior. However, it lacks the flexibility needed to cover all error propagation and handling in the language. Result is a type commonly used for manual propagation and handling of errors in other languages and within the Swift community. Therefore this proposal seeks to add such a type to the Swift standard library.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        enum Result<Success, Failure: Error> {
                            case success(Success)
                            case failure(Failure)
                        }
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        URLSession.shared.dataTask(with: url) { (result: Result<(response: URLResponse, data: Data), Error>) in // Type added for illustration purposes.
                            switch result {
                            case let .success(success):
                                handleResponse(success.response, data: success.data)
                            case let .error(error):
                                handleError(error)
                            }
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Fix ExpressibleByStringInterpolation",
                evolutionID: "SE-0228",
                description: "String interpolation is a simple and powerful feature for expressing complex, runtime-created strings, but the current version of the ExpressibleByStringInterpolation protocol has been deprecated since Swift 3. We propose a new design that improves its performance, clarity, and efficiency."
            ),
            
            SwiftChange(
                name: #"Introduce user-defined dynamically "callable" types"#,
                evolutionID: "SE-0216",
                description: #"This proposal is a follow-up to SE-0195 - Introduce User-defined "Dynamic Member Lookup" Types, which shipped in Swift 4.2. It introduces a new @dynamicCallable attribute, which marks a type as being "callable" with normal syntax."#,
                examples: [
                    SwiftCodeExample(
                        code: """
                            @dynamicCallable
                            struct ToyCallable {
                              func dynamicallyCall(withArguments: [Int]) {}
                              func dynamicallyCall(withKeywordArguments: KeyValuePairs<String, Int>) {}
                            }
                            let x = ToyCallable()
                            x(1, 2, 3) // desugars to `x.dynamicallyCall(withArguments: [1, 2, 3])`
                            x(label: 1, 2) // desugars to `x.dynamicallyCall(withKeywordArguments: ["label": 1, "": 2])`
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Handling Future Enum Cases",
                evolutionID: "SE-0192",
                description: "Since the proposal was accepted months after it was written, the rollout plan turned out to be a little too aggressive. Therefore, in Swift 5 the diagnostic for omitting @unknown default: or @unknown case _: will only be a warning, and in Swift 4 mode there will be no diagnostic at all. (The previous version of the proposal used an error and a warning, respectively.) Developers are still free to use @unknown in Swift 4 mode, in which case the compiler will still produce a warning if all known cases are not handled.",
                examples: [
                    SwiftCodeExample(
                        code: """
                            switch excuse {
                            case .eatenByPet:
                              // …
                            case .thoughtItWasDueNextWeek:
                              // …
                            @unknown default:
                              // …
                            }
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Adding isMultiple to BinaryInteger",
                evolutionID: "SE-0225",
                description: "This proposal adds var isEven: Bool, var isOdd: Bool, and func isMultiple(of other: Self) -> Bool to the BinaryInteger protocol. isEven and isOdd are convenience properties for querying the parity of the integer and isMultiple is a more general function to determine whether an integer is a multiple of another integer.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        // Integers.swift.gyb
                        // On protocol BinaryInteger
                        
                        @_transparent
                        public var isEven: Bool { return _lowWord % 2 == 0 }
                        
                        @_transparent
                        public var isOdd: Bool { return !isEven }
                        
                        func isMultiple(of other: Self) -> Bool
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Introduce compactMapValues to Dictionary",
                evolutionID: "SE-0218",
                description: "This proposal adds a combined filter/map operation to Dictionary, as a companion to the mapValues and filter methods introduced by SE-0165. The new compactMapValues operation corresponds to compactMap on Sequence.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        let d: [String: String?] = ["a": "1", "b": nil, "c": "3"]
                        let r4 = d.compactMapValues({$0})
                        print(r4)
                        """,
                        output: {
                            #"["a": "1", "c": "3"]"#
                        }
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        let d: [String: String] = ["a": "1", "b": "2", "c": "three"]
                        let r5 = d.compactMapValues(Int.init)
                        print(r5)
                        """,
                        output: {
                            #"["a": 1, "b": 2]"#
                        }
                    )
                ]
            )
        ]
    }
}
