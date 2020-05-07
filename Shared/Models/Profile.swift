import Foundation

struct Profile: Codable, Equatable {
    var maxScore = 0
    var skin = Skin.Id.basic
    var purchases = Set<String>()
    var lastGame = Date.distantPast
    let created = Date()
    
    func hash(into: inout Hasher) { }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
