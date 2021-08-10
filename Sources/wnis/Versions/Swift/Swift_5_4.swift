struct Swift_5_4: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_4
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Extend implicit member syntax to cover chains of member references",
                evolutionID: "SE-0287",
                description: #"When the type of an expression is implied by the context, Swift allows developers to use what is formally referred to as an "implicit member expression," sometimes referred to as "leading dot syntax"."#,
                examples: [
                    SwiftCodeExample(
                        code: """
                        let milky: UIColor = .white.withAlphaComponent(0.5)
                        let milky2: UIColor = .init(named: "white")!.withAlphaComponent(0.5)
                        let milkyChance: UIColor? = .init(named: "white")?.withAlphaComponent(0.5)
                    
                        struct Foo {
                            static var foo = Foo()
                            
                            var anotherFoo: Foo { Foo() }
                            func getFoo() -> Foo { Foo() }
                            var optionalFoo: Foo? { Foo() }
                            var fooFunc: () -> Foo { { Foo() } }
                            var optionalFooFunc: () -> Foo? { { Foo() } }
                            var fooFuncOptional: (() -> Foo)? { { Foo() } }
                            subscript() -> Foo { Foo() }
                        }
                    
                        let _: Foo = .foo.anotherFoo
                        let _: Foo = .foo.anotherFoo.anotherFoo.anotherFoo.anotherFoo
                        let _: Foo = .foo.getFoo()
                        let _: Foo = .foo.optionalFoo!.getFoo()
                        let _: Foo = .foo.fooFunc()
                        let _: Foo = .foo.optionalFooFunc()!
                        let _: Foo = .foo.fooFuncOptional!()
                        let _: Foo = .foo.optionalFoo!
                        let _: Foo = .foo[]
                        let _: Foo = .foo.anotherFoo[]
                        let _: Foo = .foo.fooFuncOptional!()[]
                    
                        struct Bar {
                            var anotherFoo = Foo()
                        }
                    
                        extension Foo {
                            static var bar = Bar()
                            var anotherBar: Bar { Bar() }
                        }
                    
                        let _: Foo = .bar.anotherFoo
                        let _: Foo = .foo.anotherBar.anotherFoo
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Allow Multiple Variadic Parameters in Functions, Subscripts, and Initializers",
                evolutionID: "SE-0284",
                description: """
                    Currently, variadic parameters in Swift are subject to two main restrictions:

                        - Only one variadic parameter is allowed per parameter list
                        - If present, the parameter which follows a variadic parameter must be labeled
                    
                    This proposal seeks to remove the first restriction while leaving the second in place, allowing a function, subscript, or initializer to have multiple variadic parameters so long as every parameter which follows a variadic one has a label.
                    """,
                examples: [
                    SwiftCodeExample(
                        code: """
                            struct HasSubscript {
                                // Not allowed because the second parameter does not have an external label.
                                subscript(a: Int..., b: Int...) -> [Int] { a + b }

                                // Allowed
                                subscript(a: Int..., b b: Int...) -> [Int] { a + b }
                            }
                            """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                            // Note the label on the second parameter is required because it follows a variadic parameter.
                            func twoVarargs(_ a: Int..., b: Int...) { }
                            twoVarargs(1, 2, 3, b: 4, 5, 6)

                            // Variadic parameters can be omitted because they default to [].
                            twoVarargs(1, 2, 3)
                            twoVarargs(b: 4, 5, 6)
                            twoVarargs()

                            // The third parameter does not require a label because the second isn't variadic.
                            func splitVarargs(a: Int..., b: Int, _ c: Int...) { }
                            splitVarargs(a: 1, 2, 3, b: 4, 5, 6, 7)
                            // a is [1, 2, 3], b is 4, c is [5, 6, 7].
                            splitVarargs(b: 4)
                            // a is [], b is 4, c is [].

                            // Note the third parameter doesn't need a label even though the second has a default expression. This
                            // is consistent with the current behavior, which allows a variadic parameter followed by a labeled,
                            // defaulted parameter, followed by an unlabeled required parameter.
                            func varargsSplitByDefaultedParam(_ a: Int..., b: Int = 42, _ c: Int...) { }
                            varargsSplitByDefaultedParam(1, 2, 3, b: 4, 5, 6, 7)
                            // a is [1, 2, 3], b is 4, c is [5, 6, 7].
                            varargsSplitByDefaultedParam(b: 4, 5, 6, 7)
                            // a is [], b is 4, c is [5, 6, 7].
                            varargsSplitByDefaultedParam(1, 2, 3)
                            // a is [1, 2, 3], b is 42, c is [].
                            // Note: it is impossible to call varargsSplitByDefaultedParam providing a value for the third parameter
                            // without also providing a value for the second.
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Local functions now support overloading",
                evolutionID: "SR-10069",
                description: """
                    These don't  compile:

                        - Nested overloads with different parameter types.
                        - Calling a nested function before an overload is defined later in the function.
                    """,
                examples: [
                    SwiftCodeExample(
                        code: """
                            func ƒ() {
                              func nested(_: Bool) { }
                              func nested(_: Int) { }
                            }

                            func ƒ2() {
                              func nested(bool _: Bool) { }

                              nested(bool: false)

                              func nested(int _: Int) { }
                            }
                            """
                    ),
                    
                    SwiftCodeExample(
                        code: """
                            func outer(x: Int, y: String) {
                              func doIt(_: Int) {}
                              func doIt(_: String) {}
                              doIt(x) // calls the first 'doIt(_:)' with an Int value
                              doIt(y) // calls the second 'doIt(_:)' with a String value
                            }
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Function builders",
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
            
            SwiftChange(
                name: "Declaring executable targets in Package Manifests",
                evolutionID: "SE-0294",
                description: """
                    This proposal lets Swift Package authors declare targets as executable in the package manifest. This replaces the current approach of inferring executability based on the presence of a source file with the base name main at the top level of the target source directory.

                    Letting package authors declare targets as executable allows the use of @main in Swift package targets. It also allows for better diagnostics, since the purpose of the target is unambiguous even if source files are moved or renamed.
                    """,
                examples: [
                    SwiftCodeExample(
                        code: """
                            /// Creates an executable target.
                            ///
                            /// An executable target can contain either Swift or C-family source files, but not both. It contains code that
                            /// is built as an executable module that can be used as the main target of an executable product.  The target
                            /// is expected to either have a source file named `main.swift`, `main.m`, `main.c`, or `main.cpp`, or a source
                            ///  file that contains the `@main` keyword.
                            ///
                            /// - Parameters:
                            ///   - name: The name of the target.
                            ///   - dependencies: The dependencies of the target. A dependency can be another target in the package or a product from a package dependency.
                            ///   - path: The custom path for the target. By default, the Swift Package Manager requires a target's sources to reside at predefined search paths;
                            ///       for example, `[PackageRoot]/Sources/[TargetName]`.
                            ///       Don't escape the package root; for example, values like `../Foo` or `/Foo` are invalid.
                            ///   - exclude: A list of paths to files or directories that the Swift Package Manager shouldn't consider to be source or resource files.
                            ///       A path is relative to the target's directory.
                            ///       This parameter has precedence over the `sources` parameter.
                            ///   - sources: An explicit list of source files. If you provide a path to a directory,
                            ///       the Swift Package Manager searches for valid source files recursively.
                            ///   - resources: An explicit list of resources files.
                            ///   - publicHeadersPath: The directory containing public headers of a C-family library target.
                            ///   - cSettings: The C settings for this target.
                            ///   - cxxSettings: The C++ settings for this target.
                            ///   - swiftSettings: The Swift settings for this target.
                            ///   - linkerSettings: The linker settings for this target.
                            @available(_PackageDescription, introduced: 999.0)
                            public static func executableTarget(
                               name: String,
                               dependencies: [Dependency] = [],
                               path: String? = nil,
                               exclude: [String] = [],
                               sources: [String]? = nil,
                               resources: [Resource]? = nil,
                               publicHeadersPath: String? = nil,
                               cSettings: [CSetting]? = nil,
                               cxxSettings: [CXXSetting]? = nil,
                               swiftSettings: [SwiftSetting]? = nil,
                               linkerSettings: [LinkerSetting]? = nil
                            ) -> Target {
                               return Target(
                                   name: name,
                                   dependencies: dependencies,
                                   path: path,
                                   exclude: exclude,
                                   sources: sources,
                                   resources: resources,
                                   publicHeadersPath: publicHeadersPath,
                                   type: .executable,
                                   cSettings: cSettings,
                                   cxxSettings: cxxSettings,
                                   swiftSettings: swiftSettings,
                                   linkerSettings: linkerSettings
                               )
                            }
                            """
                    )
                ]
            )
        ]
    }
}
