struct Swift_5_5: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_5
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
                name: "Async await",
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
            
            SwiftChange(
                name: "Async sequences",
                evolutionID: "SE-0298",
                description: "Swift's async/await feature provides an intuitive, built-in way to write and use functions that return a single value at some future point in time. We propose building on top of this feature to create an intuitive, built-in way to write and use functions that return many values over time.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        // Counter
                        struct Counter : AsyncSequence {
                          let howHigh: Int
                        
                          struct AsyncIterator : AsyncIteratorProtocol {
                            let howHigh: Int
                            var current = 1
                            mutating func next() async -> Int? {
                              // We could use the `Task` API to check for cancellation here and return early.
                              guard current <= howHigh else {
                                return nil
                              }
                        
                              let result = current
                              current += 1
                              return result
                            }
                          }
                        
                          func makeAsyncIterator() -> AsyncIterator {
                            return AsyncIterator(howHigh: howHigh)
                          }
                        }
                        
                        // Counter Usage
                        for await i in Counter(howHigh: 3) {
                          print(i)
                        }
                        
                        /*
                        Prints the following, and finishes the loop:
                        1
                        2
                        3
                        */
                        
                        
                        for await i in Counter(howHigh: 3) {
                          print(i)
                          if i == 2 { break }
                        }
                        /*
                        Prints the following:
                        1
                        2
                        */
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Effectful read-only properties",
                evolutionID: "SE-0310",
                description: "Nominal types such as classes, structs, and enums in Swift support computed properties and subscripts, which are members of the type that invoke programmer-specified computations when getting or setting them. The recently accepted proposal SE-0296 introduced asynchronous functions via async, in conjunction with await, but did not specify that computed properties or subscripts can support effects like asynchrony. Furthermore, to take full advantage of async properties, the ability to specify that a property throws is also important. This document aims to partially fill in this gap by proposing a syntax and semantics for effectful read-only computed properties and subscripts.",
                examples: [
                    SwiftCodeExample(
                        code: """
                        // For the problems detailed in the motivation section, the proposed solution is to allow async, throws, or both of these effect specifiers to be marked on a read-only computed property or subscript
                        class BankAccount {
                          // ...
                          var lastTransaction: Transaction {
                            get async throws {   // <-- NEW: effects specifiers!
                              guard manager != nil else {
                                throw BankError.notInYourFavor
                              }
                              return await manager!.getLastTransaction()
                            }
                          }
                        
                          subscript(_ day: Date) -> [Transaction] {
                            get async { // <-- NEW: effects specifiers!
                              return await manager?.getTransactions(onDay: day) ?? []
                            }
                          }
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Structured concurrency",
                evolutionID: "SE-0304",
                description: #"""
                    async/await is a language mechanism for writing natural, efficient asynchronous code. Asynchronous functions (introduced with async) can give up the thread on which they are executing at any given suspension point (marked with await), which is necessary for building highly-concurrent systems.
                    
                    However, the async/await proposal does not introduce concurrency per se: ignoring the suspension points within an asynchronous function, it will execute in essentially the same manner as a synchronous function. This proposal introduces support for structured concurrency in Swift, enabling concurrent execution of asynchronous code with a model that is ergonomic, predictable, and admits efficient implementation.
                """#,
                examples: [
                    SwiftCodeExample(
                        code: """
                        func makeDinner() async throws -> Meal {
                          // Prepare some variables to receive results from our concurrent child tasks
                          var veggies: [Vegetable]?
                          var meat: Meat?
                          var oven: Oven?
                        
                          enum CookingStep {
                            case veggies([Vegetable])
                            case meat(Meat)
                            case oven(Oven)
                          }
                          
                          // Create a task group to scope the lifetime of our three child tasks
                          try await withThrowingTaskGroup(of: CookingStep.self) { group in
                            group.addTask {
                              try await .veggies(chopVegetables())
                            }
                            group.addTask {
                              await .meat(marinateMeat())
                            }
                            group.addTask {
                              try await .oven(preheatOven(temperature: 350))
                            }
                                                                     
                            for try await finishedStep in group {
                              switch finishedStep {
                                case .veggies(let v): veggies = v
                                case .meat(let m): meat = m
                                case .oven(let o): oven = o
                              }
                            }
                          }
                        
                          // If execution resumes normally after `withTaskGroup`, then we can assume
                          // that all child tasks added to the group completed successfully. That means
                          // we can confidently force-unwrap the variables containing the child task
                          // results here.
                          let dish = Dish(ingredients: [veggies!, meat!])
                          return try await oven!.cook(dish, duration: .hours(3))
                        }
                        """
                    )
                ]
            ),
            
            SwiftChange(
                name: "async let bindings",
                evolutionID: "SE-0317",
                description: "Structured concurrency provides a paradigm for spawning concurrent child tasks in scoped task groups, establishing a well-defined hierarchy of tasks which allows for cancellation, error propagation, priority management, and other tricky details of concurrency management to be handled transparently.",
                examples: [
                    SwiftCodeExample(
                        code: """
                            // given:
                            //   func chopVegetables() async throws -> [Vegetables]
                            //   func marinateMeat() async -> Meat
                            //   func preheatOven(temperature: Int) async -> Oven

                            func makeDinner() async throws -> Meal {
                              async let veggies = chopVegetables()
                              async let meat = marinateMeat()
                              async let oven = preheatOven(temperature: 350)

                              let dish = Dish(ingredients: await [try veggies, meat])
                              return try await oven.cook(dish, duration: .hours(3))
                            }
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Continuations for interfacing async tasks with synchronous code",
                evolutionID: "SE-0300",
                description: "Asynchronous Swift code needs to be able to work with existing synchronous code that uses techniques such as completion callbacks and delegate methods to respond to events. Asynchronous tasks can suspend themselves on continuations which synchronous code can then capture and invoke to resume the task in response to an event."
            ),
            
            SwiftChange(
                name: "Actors",
                evolutionID: "SE-0306",
                description: "The actor model defines entities called actors that are perfect for this task. Actors allow you as a programmer to declare that a bag of state is held within a concurrency domain and then define multiple operations that act upon it. Each actor protects its own data through data isolation, ensuring that only a single thread will access that data at a given time, even when many clients are concurrently making requests of the actor. As part of the Swift Concurrency Model, actors provide the same race and memory safety properties as structured concurrency, but provide the familiar abstraction and reuse features that other explicitly declared types in Swift enjoy.",
                examples: [
                    SwiftCodeExample(
                        code: """
                            actor BankAccount {
                              let accountNumber: Int
                              var balance: Double

                              init(accountNumber: Int, initialDeposit: Double) {
                                self.accountNumber = accountNumber
                                self.balance = initialDeposit
                              }
                            }
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Global actors",
                evolutionID: "SE-0316",
                description: """
                    This proposal introduces global actors, which extend the notion of actor isolation outside of a single actor type, so that global state (and the functions that access it) can benefit from actor isolation, even if the state and functions are scattered across many different types, functions and modules. Global actors make it possible to safely work with global variables in a concurrent program, as well as modeling other global program constraints such as code that must only execute on the "main thread" or "UI thread".

                    Global actors also provide a means to eliminate data races on global and static variables, allowing access to such variables to be synchronized via a global actor.
                    """
            ),
            
            SwiftChange(
                name: "Sendable and @Sendable closures",
                evolutionID: "SE-0302",
                description: "This proposal describes an approach to address one of the challenging problems in this space — how to type check value passing between structured concurrency constructs and actors messages. As such, this is a unifying theory that provides some of the underlying type system mechanics that make them both safe and work well together."
            ),
            
            SwiftChange(
                name: "#if for postfix member expressions",
                evolutionID: "SE-0308",
                description: "Swift has conditional compilation block #if ... #endif which allows code to be conditionally compiled depending on the value of one or more compilation conditions. Currently, unlike #if in C family languages, the body of each clause must surround complete statements. However, in some cases, especially in result builder contexts, demand for applying #if to partial expressions has emerged. This proposal expands #if ... #endif to be able to surround postfix member expressions.",
                examples: [
                    SwiftCodeExample(
                        code: """
                            baseExpr
                            #if CONDITION
                              .someOptionalMember?
                              .someMethod()
                            #else
                              .otherMember
                            #endif
                            """
                    )
                ]
            ),
            
            SwiftChange(
                name: "Allow interchangeable use of CGFloat and Double types",
                evolutionID: "SE-0307",
                description: "I propose to extend the language and allow Double and CGFloat types to be used interchangeably by means of transparently converting one type into the other as a sort of retroactive typealias between these two types. This is a narrowly defined implicit conversion intended to be part of the existing family of implicit conversions (including NSType <=> CFType conversions) supported by Swift to strengthen Objective-C and Swift interoperability. The only difference between the proposed conversion and existing ones is related to the fact that interchangeability implies both narrowing conversion (Double -> CGFloat) and widening one (CGFloat -> Double) on 32-bit platforms. This proposal is not about generalizing support for implicit conversions to the language."
            ),
            
            SwiftChange(
                name: "Codable synthesis for enums with associated values",
                evolutionID: "SE-0295",
                description: """
                    Codable was introduced in SE-0166 with support for synthesizing Encodable and Decodable conformance for class and struct types, that only contain values that also conform to the respective protocols.

                    This proposal will extend the support for auto-synthesis of these conformances to enums with associated values.
                    """
            ),
            
            SwiftChange(
                name: "Extend property wrappers to function and closure parameters",
                evolutionID: "SE-0293",
                description: "Property Wrappers were introduced in Swift 5.1, and have since become a popular mechanism for abstracting away common accessor patterns for properties. Currently, applying a property wrapper is solely permitted on local variables and type properties. However, with increasing adoption, demand for extending where property wrappers can be applied has emerged. This proposal aims to extend property wrappers to function and closure parameters."
            ),
            
            SwiftChange(
                name: "Extending static member lookup in generic contexts",
                evolutionID: "SE-0299",
                description: "Using static member declarations to provide semantic names for commonly used values which can then be accessed via leading dot syntax is an important tool in API design, reducing type repetition and improving call-site legibility. Currently, when a parameter is generic, there is no effective way to take advantage of this syntax. This proposal aims to relax restrictions on accessing static members on protocols to afford the same call-site legibility to generic APIs."
            )
        ]
    }
}
