enum SwiftVersionNumber: String, CaseIterable {
    case swift5_x = "5.x"
    case swift5_0 = "5.0"
    case swift5_1 = "5.1"
    case swift5_2 = "5.2"
    case swift5_3 = "5.3"
    case swift5_4 = "5.4"
    case swift5_5 = "5.5"
    case swift5_6 = "5.6"
}

extension SwiftVersionNumber {
    var swiftVersion: SwiftVersion {
        switch self {
        case .swift5_x:
            return Swift_5_x()
        case .swift5_0:
            return Swift_5_0()
        case .swift5_1:
            return Swift_5_1()
        case .swift5_2:
            return Swift_5_2()
        case .swift5_3:
            return Swift_5_3()
        case .swift5_4:
            return Swift_5_4()
        case .swift5_5:
            return Swift_5_5()
        case .swift5_6:
            return Swift_5_6()
        }
    }
}
