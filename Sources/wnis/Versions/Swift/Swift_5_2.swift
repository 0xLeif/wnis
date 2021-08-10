struct Swift_5_2: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_2
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Key Path Expressions as Functions",
                evolutionID: "SE-0249",
                description: #"This proposal introduces the ability to use the key path expression \Root.value wherever functions of (Root) -> Value are allowed."#,
                examples: [
                    SwiftCodeExample(
                        code: #"""
                            // You write this:
                            let f: (User) -> String = \User.email
                            
                            // The compiler generates something like this:
                            let f: (User) -> String = { kp in { root in root[keyPath: kp] } }(\User.email)
                            """#
                    )
                ]
            ),
            
            SwiftChange(
                name: "Callable values of user-defined nominal types",
                evolutionID: "SE-0253",
                description: #"This proposal introduces "statically" callable values to Swift. Callable values are values that define function-like behavior and can be called using function call syntax. In contrast to dynamically callable values introduced in SE-0216, this feature supports statically declared arities, argument labels, and parameter types, and is not constrained to primary type declarations."#,
                examples: [
                    SwiftCodeExample(
                        code: #"""
                            struct Adder {
                                var base: Int
                                func callAsFunction(_ x: Int) -> Int {
                                    return base + x
                                }
                            }

                            let add3 = Adder(base: 3)
                            add3(10) // => 13
                            """#
                    ),
                    
                    SwiftCodeExample(
                        code: #"""
                            // Represents a nullary function capturing a value of type `T`.
                            struct BoundClosure<T> {
                                var function: (T) -> Void
                                var value: T

                                func callAsFunction() { return function(value) }
                            }

                            let x = "Hello world!"
                            let closure = BoundClosure(function: { print($0) }, value: x)
                            closure() // prints "Hello world!"
                            """#
                    ),
                    
                    SwiftCodeExample(
                        code: #"""
                            struct Model {
                                var conv = Conv2D<Float>(filterShape: (5, 5, 3, 6))
                                var maxPool = MaxPool2D<Float>(poolSize: (2, 2), strides: (2, 2))
                                var flatten = Flatten<Float>()
                                var dense = Dense<Float>(inputSize: 36 * 6, outputSize: 10)

                                func callAsFunction(_ input: Tensor<Float>) -> Tensor<Float> {
                                    // Call syntax.
                                    return dense(flatten(maxPool(conv(input))))
                                }
                            }

                            let model: Model = ...
                            let ŷ = model(x)
                            """#
                    )
                ]
            )
        ]
    }
}
