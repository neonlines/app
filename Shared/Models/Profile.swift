import Foundation

struct Profile: Codable, Equatable {
    var seconds = 0
    var ai = 0
    var duels = 0
    var skin = Skin.Id.basic
    var purchases = Set<String>()
    var lastGame = Date.distantPast
    let created = Date()
    
    func hash(into: inout Hasher) { }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
