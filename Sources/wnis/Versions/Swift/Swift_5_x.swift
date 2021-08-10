struct Swift_5_x: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_x
    
    var changes: [SwiftChange] {
        [
            // Swift 5.0
            SwiftChange(
                name: "Add Result to the Standard Library (Swift 5.0)",
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
            
            // Swift 5.1
            
            SwiftChange(
                name: "Synthesize default values for the memberwise initializer (Swift 5.1)",
                evolutionID: "SE-0242",
                description: "This proposal aims to solve a simple outstanding problem with the way the Swift compiler currently synthesizes the memberwise initializer for structures by synthesizing default values for properties with default initializers.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        struct Dog {
                          var age: Int = 0
                          var name: String
                        
                          // The generated memberwise init:
                          init(age: Int = 0, name: String)
                        }
                        
                        // This now works
                        let sparky = Dog(name: "Sparky") // Dog(age: 0, name: "Sparky")
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        struct Alphabet {
                          var a: Int = 97
                          let b: String
                          var c: String = "c"
                          let d: Bool = true
                          var e: Double = Double.random(in: 0 ... .pi)
                        
                          // The generated memberwise init:
                          init(
                            a: Int = 97,
                            b: String,
                            c: String = "c",
                            e: Double = Double.random(in: 0 ... .pi)
                          )
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Implicit returns from single-expression functions (Swift 5.1)",
                evolutionID: "SE-0255",
                description: "Swift provides a pleasant shorthand for short closures: if a closure contains just a single expression, that expression is implicitly returned--the return keyword can be omitted. We should provide this shorthand for functions as well.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        func sum() -> Element {
                            reduce(0, +)
                        }
                        """
                    ),
                ]
            ),
            
            // Swift 5.2
            
            
            // Swift 5.3
            
            SwiftChange(
                name: "Multiple trailing closures (Swift 5.3)",
                evolutionID: "SE-0279",
                description: #"Since its inception, Swift has supported trailing closure syntax: a bit of syntactic sugar that lets you "pop" the final argument to a function out of the parentheses when it's a closure."#,
                examples: [
                    SwiftCodeExample(
                        code: """
                        // Single trailing closure argument
                        UIView.animate(withDuration: 0.3) {
                          self.view.alpha = 0
                        }
                        // Multiple trailing closure arguments
                        UIView.animate(withDuration: 0.3) {
                          self.view.alpha = 0
                        } completion: { _ in
                          self.view.removeFromSuperview()
                        }
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        ipAddressPublisher
                          .sink { identity in
                            self.hostnames.insert(identity.hostname!)
                          }
                        
                        ipAddressPublisher
                          .sink { identity in
                            self.hostnames.insert(identity.hostname!)
                          } receiveCompletion: { completion in
                            // handle error
                          }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Synthesized Comparable conformance for enums (Swift 5.3)",
                evolutionID: "SE-0266",
                description: "SE-185 introduced synthesized, opt-in Equatable and Hashable conformances for eligible types. Their sibling protocol Comparable was left out at the time, since it was less obvious what types ought to be eligible for a synthesized Comparable conformance and where a comparison order might be derived from. This proposal seeks to allow users to opt-in to synthesized Comparable conformances for enum types without raw values or associated values not themselves conforming to Comparable, a class of types which I believe make excellent candidates for this feature. The synthesized comparison order would be based on the declaration order of the enum cases, and then the lexicographic comparison order of the associated values for an enum case tie.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        enum Membership: Comparable {
                            case premium(Int)
                            case preferred
                            case general
                        }
                        
                        ([.preferred, .premium(1), .general, .premium(0)] as [Membership]).sorted()
                        // [Membership.premium(0), Membership.premium(1), Membership.preferred, Membership.general]
                        """
                    )
                ]
            ),
            
            // Swift 5.4
            
            SwiftChange(
                name: "Function builders (Swift 5.4)",
                evolutionID: "SE-0289",
                description: "This proposal describes function builders, a new feature which allows certain functions (specially-annotated, often via context) to implicitly build up a value from a sequence of components.",
                examples: [
                    SwiftCodeExample(
                        code: """
                            // Original source code:
                            @TupleBuilder
                            func build() -> (Int, Int, Int) {
                              1
                              2
                              3
                            }
                            
                            // This code is interpreted exactly as if it were this code:
                            func build() -> (Int, Int, Int) {
                              let _a = TupleBuilder.buildExpression(1)
                              let _b = TupleBuilder.buildExpression(2)
                              let _c = TupleBuilder.buildExpression(3)
                              return TupleBuilder.buildBlock(_a, _b, _c)
                            }
                            """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                            @functionBuilder
                            struct HTMLBuilder {
                              // We'll use these typealiases to make the lifting rules clearer in this example.
                              // Function builders don't really require these to be specific types that can
                              // be named this way!  For example, Expression could be "either a String or an
                              // HTMLNode", and we could just overload buildExpression to accept either.
                              // Similarly, Component could be "any Collection of HTML", and we'd just have
                              // to make buildBlock et al generic functions to support that.  But we'll keep
                              // it simple so that we can write these typealiases.
                            
                              // Expression-statements in the DSL should always produce an HTML value.
                              typealias Expression = HTML
                            
                              // "Internally" to the DSL, we'll just build up flattened arrays of HTML
                              // values, immediately flattening any optionality or nested array structure.
                              typealias Component = [HTML]
                            
                              // Given an expression result, "lift" it into a Component.
                              //
                              // If Component were "any Collection of HTML", we could have this return
                              // CollectionOfOne to avoid an array allocation.
                              static func buildExpression(_ expression: Expression) -> Component {
                                return [expression]
                              }
                            
                              // Build a combined result from a list of partial results by concatenating.
                              //
                              // If Component were "any Collection of HTML", we could avoid some unnecessary
                              // reallocation work here by just calling joined().
                              static func buildBlock(_ children: Component...) -> Component {
                                return children.flatMap { $0 }
                              }
                            
                              // We can provide this overload as a micro-optimization for the common case
                              // where there's only one partial result in a block.  This shows the flexibility
                              // of using an ad-hoc builder pattern.
                              static func buildBlock(_ component: Component) -> Component {
                                return component
                              }
                              
                              // Handle optionality by turning nil into the empty list.
                              static func buildOptional(_ children: Component?) -> Component {
                                return children ?? []
                              }
                            
                              // Handle optionally-executed blocks.
                              static func buildEither(first child: Component) -> Component {
                                return child
                              }
                              
                              // Handle optionally-executed blocks.
                              static func buildEither(second child: Component) -> Component {
                                return child
                              }
                            }
                            """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                            func body(@HTMLBuilder makeChildren: () -> [HTML]) -> HTMLNode {
                              return HTMLNode(tag: "body", attributes: [:], children: makeChildren())
                            }
                            func division(@HTMLBuilder makeChildren: () -> [HTML]) -> HTMLNode { ... }
                            func paragraph(@HTMLBuilder makeChildren: () -> [HTML]) -> HTMLNode { ... }
                            """
                    )
                ]
            ),
            
            // Swift 5.5
            
            SwiftChange(
                name: "Async await (Swift 5.5)",
                evolutionID: "SE-0296",
                description: #"Modern Swift development involves a lot of asynchronous (or "async") programming using closures and completion handlers, but these APIs are hard to use. This gets particularly problematic when many asynchronous operations are used, error handling is required, or control flow between asynchronous calls gets complicated. This proposal describes a language extension to make this a lot more natural and less error prone."#,
                examples: [
                    SwiftCodeExample(
                        code: """
                        class Teacher {
                          init(hiringFrom: College) async throws {
                            ...
                          }
                          
                          private func raiseHand() async -> Bool {
                            ...
                          }
                        }
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        func loadWebResource(_ path: String) async throws -> Resource
                        func decodeImage(_ r1: Resource, _ r2: Resource) async throws -> Image
                        func dewarpAndCleanupImage(_ i : Image) async throws -> Image
                        
                        func processImageData() async throws -> Image {
                          let dataResource  = try await loadWebResource("dataprofile.txt")
                          let imageResource = try await loadWebResource("imagedata.dat")
                          let imageTmp      = try await decodeImage(dataResource, imageResource)
                          let imageResult   = try await dewarpAndCleanupImage(imageTmp)
                          return imageResult
                        }
                        """
                    )
                ]
            ),
        ]
    }
}
