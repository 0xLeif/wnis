struct Swift_5_3: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_3
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Multi-pattern catch clauses",
                evolutionID: "SE-0276",
                description: "Currently, each catch clause in a do-catch statement may only contain a single pattern and where clause. This is inconsistent with the behavior of cases in switch statements, which provide similar functionality. It also makes some error handling patterns awkward to express. This proposal extends the grammar of catch clauses to support a comma-separated list of patterns (with optional where clauses), resolving this inconsistency.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        do {
                          try performTask()
                        } catch TaskError.someRecoverableError {    // OK
                          recover()
                        } catch TaskError.someFailure(let msg),
                                TaskError.anotherFailure(let msg) { // Also Allowed
                          showMessage(msg)
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Multiple trailing closures",
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
                name: "Synthesized Comparable conformance for enums",
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
            
            SwiftChange(
                name: "Increase availability of implicit self in @escaping closures when reference cycles are unlikely to occur",
                evolutionID: "SE-0269",
                description: "Modify the rule that all uses of self in escaping closures must be explicit by allowing for implicit uses of self in situations where the user has already made their intent explicit, or where strong reference cycles are otherwise unlikely to occur. There are two situations covered by this proposal."
            ),
            
            SwiftChange(
                name: "@main: Type-Based Program Entry Points",
                evolutionID: "SE-0281",
                description: "A Swift language feature for designating a type as the entry point for beginning program execution. Instead of writing top-level code, users can use the @main attribute on a single type. Libraries and frameworks can then provide custom entry-point behavior through protocols or class inheritance.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        // In a framework:
                        public protocol ApplicationRoot {
                            // ...
                        }
                        extension ApplicationRoot {
                            public static func main() {
                                // ...
                            }
                        }
                        
                        // In MyProgram.swift:
                        @main
                        struct MyProgram: ApplicationRoot {
                            // ...
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "where clauses on contextually generic declarations",
                evolutionID: "SE-0267",
                description: "This proposal aims to lift the restriction on attaching where clauses to member declarations that can reference only outer generic parameters. Simply put, this means the 'where' clause cannot be attached error will be relaxed for most declarations nested inside generic contexts.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        // 'Foo' can be any kind of nominal type declaration.
                        // For a protocol, 'T' would be Self or an associatedtype.
                        struct Foo<T>
                        
                        extension Foo where T: Sequence, T.Element: Equatable {
                            func slowFoo() { ... }
                        }
                        extension Foo where T: Sequence, T.Element: Hashable {
                            func optimizedFoo() { ... }
                        }
                        extension Foo where T: Sequence, T.Element == Character {
                            func specialCaseFoo() { ... }
                        }
                        
                        extension Foo where T: Sequence, T.Element: Equatable {
                            func slowFoo() { ... }
                        
                            func optimizedFoo() where T.Element: Hashable { ... }
                        
                            func specialCaseFoo() where T.Element == Character { ... }
                        }
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        class Base<T> {
                            func foo() where T == Int { ... }
                        }
                        
                        class Derived<T>: Base<T> {
                            // OK, the substitutions for <T: Equatable> are a superset of those for <T == Int>
                            override func foo() where T: Equatable { ... }
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Enum cases as protocol witnesses",
                evolutionID: "SE-0280",
                description: "The aim of this proposal is to lift an existing restriction, which is that enum cases cannot participate in protocol witness matching."
            ),
            
            SwiftChange(
                name: "Refined didSet Semantics",
                evolutionID: "SE-0268",
                description: #"""
                    Introduce two changes to didSet semantics -
                    
                    If a didSet observer does not reference the oldValue in its body, then the call to fetch the oldValue will be skipped. We refer to this as a "simple" didSet.
                    If we have a "simple" didSet and no willSet, then we could allow modifications to happen in-place.
                    """#,
                examples: [
                    SwiftCodeExample(
                        code: """
                        // The property's getter is no longer called if we do not refer to the oldValue inside the body of the didSet.
                        class Foo {
                          var bar = 0 {
                            didSet { print("didSet called") }
                          }

                          var baz = 0 {
                            didSet { print(oldValue) }
                          }
                        }

                        let foo = Foo()
                        // This will not call the getter to fetch the oldValue
                        foo.bar = 1
                        // This will call the getter to fetch the oldValue
                        foo.baz = 2
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "A new Float16 type",
                evolutionID: "SE-0277",
                description: "Introduce the Float16 type conforming to the BinaryFloatingPoint and SIMDScalar protocols, binding the IEEE 754 binary16 format (aka float16, half-precision, or half), and bridged by the compiler to the C _Float16 type."
            ),
            
            SwiftChange(
                name: "Swift Package Manager gains binary dependencies, resources, and more",
                evolutionID: "SE-0271, SE-0272, SE-0273",
                description: """
                    Packages should be able to contain images, data files, and other resources needed at runtime. This proposal describes SwiftPM support for specifying such package resources, and introduces a consistent way of accessing them from the source code in the package.

                    SwiftPM has a large appeal to certain developer communities, like the iOS ecosystem, where it is currently very common to rely on closed source dependencies such as Firebase, GoogleAnalytics, Adjust and many more. Existing package managers like Cocoapods support these use cases. By adding such support to SwiftPM, we will unblock substantially more adoption of SwiftPM within those communities.
                    
                    This proposal introduces the ability for Swift package authors to conditionalize target dependencies on platform and configuration with a similar syntax to the one introduced in SE-0238 for build settings. This gives developers more flexibility to describe complex target dependencies to support multiple platforms or different configuration environments.
                    """
            )
        ]
    }
}
