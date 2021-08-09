struct Swift_5_0: SwiftVersion {
    var versionNumber: SwiftVersionNumber = .swift5_0
    
    var changes: [SwiftChange] {
        [
            SwiftChange(
            name: "Raw strings",
                evolutionID: "SE-0200",
                description: "Raw strings added the ability to create raw strings, where backslashes and quote marks are interpreted as those literal symbols rather than escapes characters or string terminators. This makes a number of use cases more easy, but regular expressions in particular will benefit. To use raw strings, place one or more # symbols before and after your string.",
                exampleCode: ##"print(#""Raw" Strings \(value)"#)"##,
                example: {
                    #""Raw" Strings \(value)"#
                }
            )
        ]
    }
}
