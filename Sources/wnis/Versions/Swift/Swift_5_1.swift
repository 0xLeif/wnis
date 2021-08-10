struct Swift_5_1: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_1
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Synthesize default values for the memberwise initializer",
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
                name: "Implicit returns from single-expression functions",
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
            
            SwiftChange(
                name: "Expanding Swift Self to class members and value types",
                evolutionID: "SE-0068",
                description: #"Within a class scope, Self means "the dynamic class of self". This proposal extends that courtesy to value types and to the bodies of class members by renaming dynamicType to Self. This establishes a universal and consistent way to refer to the dynamic type of the current receiver."#
            ),
            
            SwiftChange(
                name: "Opaque return types",
                evolutionID: "SE-0244",
                description: "This proposal is the first part of a group of changes we're considering in a design document for improving the UI of the generics model. We'll try to make this proposal stand alone to describe opaque return types, their design, and motivation, but we also recommend reading the design document for more in-depth exploration of the relationships among other features we're considering. We'll link to relevant parts of that document throughout this proposal.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        struct EightPointedStar: GameObject {
                          var shape: some Shape {
                            return Union(Rectangle(), Transformed(Rectangle(), by: .fortyFiveDegrees)
                          }
                        }
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        // An opaque type behaves like a "reverse generic". In a traditional generic function, the caller decides what types get bound to the callee's generic arguments
                        func generic<T: Shape>() -> T { ... }
                        
                        let x: Rectangle = generic() // T == Rectangle, chosen by caller
                        let x: Circle = generic() // T == Circle, chosen by caller
                        """
                    ),
                ]
            ),
            
            SwiftChange(
                name: "Static and class subscripts",
                evolutionID: "SE-0254",
                description: "We propose allowing static subscript and, in classes, class subscript declarations. These could be used through either TypeName[index] or TypeName.self[index] and would have all of the capabilities you would expect of a subscript. We also propose extending dynamic member lookup to static properties by using static subscripts.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        // In any place where it was previously legal to declare a subscript, it will now be legal to declare a static subscript as well. In classes it will also be legal to declare a class subscript.
                        public enum Environment {
                          public static subscript(_ name: String) -> String? {
                            get {
                              return getenv(name).map(String.init(cString:))
                            }
                            set {
                              guard let newValue = newValue else {
                                unsetenv(name)
                                return
                              }
                              setenv(name, newValue, 1)
                            }
                          }
                        }
                        """
                    ),
                ]
            ),
            
            SwiftChange(
                name: "Ordered collection diffing",
                evolutionID: "SE-0240",
                description: "This proposal describes additions to the standard library that provide an interchange format for diffs as well as diffing/patching functionality for appropriate collection types."
            ),
            
            SwiftChange(
                name: "Add an Array Initializer with Access to Uninitialized Storage",
                evolutionID: "SE-0245",
                description: "This proposal suggests a new initializer for Array and ContiguousArray that provides access to an array's uninitialized storage buffer.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        var myArray = Array<Int>(unsafeUninitializedCapacity: 10) { buffer, initializedCount in
                            for x in 1..<5 {
                                buffer[x] = x
                            }
                            buffer[0] = 10
                            initializedCount = 5
                        }
                        // myArray == [10, 1, 2, 3, 4]
                        """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                        // You can Try This At Home™ with this extension, which provides the semantics (but not the copy-avoiding performance benefits) of the proposed additions
                        extension Array {
                            public init(
                                unsafeUninitializedCapacity: Int,
                                initializingWith initializer: (
                                    _ buffer: inout UnsafeMutableBufferPointer<Element>,
                                    _ initializedCount: inout Int
                                ) throws -> Void
                            ) rethrows {
                                var buffer = UnsafeMutableBufferPointer<Element>
                                    .allocate(capacity: unsafeUninitializedCapacity)
                                defer { buffer.deallocate() }
                                
                                var count = 0
                                do {
                                    try initializer(&buffer, &count)
                                } catch {
                                    buffer.baseAddress!.deinitialize(count: count)
                                    throw error
                                }
                                self = Array(buffer[0..<count])
                            }
                        }
                        """
                    )
                ]
            )
        ]
    }
}
