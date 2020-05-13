import Foundation

struct Profile: Codable, Equatable {
    var maxScore = 0 {
        didSet {
            balam.update(self)
        }
    }
    
    var skin = Skin.Id.basic {
        didSet {
            balam.update(self)
        }
    }
    
    var purchases = Set<String>() {
        didSet {
            balam.update(self)
        }
    }
    
    var lastGame = Date.distantPast {
        didSet {
            balam.update(self)
        }
    }
    
    let created = Date()
    
    func hash(into: inout Hasher) { }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
