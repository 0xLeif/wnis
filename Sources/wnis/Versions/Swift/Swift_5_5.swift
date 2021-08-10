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
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Continuations for interfacing async tasks with synchronous code",
                evolutionID: "SE-0300",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Actors",
                evolutionID: "SE-0306",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Global actors",
                evolutionID: "SE-0316",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Sendable and @Sendable closures",
                evolutionID: "SE-0302",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "#if for postfix member expressions",
                evolutionID: "SE-0308",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Allow interchangeable use of CGFloat and Double types",
                evolutionID: "SE-0307",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Codable synthesis for enums with associated values",
                evolutionID: "SE-0295",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Extend property wrappers to function and closure parameters",
                evolutionID: "SE-0293",
                description: "",
                examples: []
            ),
            
            SwiftChange(
                name: "Extending static member lookup in generic contexts",
                evolutionID: "SE-0299",
                description: "",
                examples: []
            )
        ]
    }
}
