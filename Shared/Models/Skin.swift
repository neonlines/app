import SpriteKit

struct Skin {
    enum Id: String, Codable, CaseIterable {
        case
        basic,
        foe0,
        foe1,
        foe2,
        foe3,
        foe4
    }
    
    let colour: SKColor
    let texture: String
    
    static func make(id: Id) -> Skin {
        switch id {
        case .basic: return .init(id, colour: #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1))
        case .foe0: return .init(id, colour: #colorLiteral(red: 0.7058823529, green: 0.7058823529, blue: 0.7058823529, alpha: 1))
        case .foe1: return .init(id, colour: #colorLiteral(red: 1, green: 0.9333333333, blue: 0.3450980392, alpha: 1))
        case .foe2: return .init(id, colour: #colorLiteral(red: 0.7764705882, green: 0.9098039216, blue: 0.4078431373, alpha: 1))
        case .foe3: return .init(id, colour: #colorLiteral(red: 0.9921568627, green: 0.5882352941, blue: 1, alpha: 1))
        case .foe4: return .init(id, colour: #colorLiteral(red: 1, green: 0.6078431373, blue: 0.6078431373, alpha: 1))
        }
    }
    
    private init(_ id: Id, colour: SKColor) {
        self.colour = colour
        self.texture = "skin_" + id.rawValue
    }
}
