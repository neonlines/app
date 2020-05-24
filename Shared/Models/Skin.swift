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
        case .foe0: return .init(id, colour: .init(white: 0.45, alpha: 1))
        case .foe1: return .init(id, colour: .init(red: 0.74, green: 0.65, blue: 0.04, alpha: 1))
        case .foe2: return .init(id, colour: .init(red: 0.56, green: 0.69, blue: 0.17, alpha: 1))
        case .foe3: return .init(id, colour: .init(red: 0.66, green: 0.04, blue: 0.68, alpha: 1))
        case .foe4: return .init(id, colour: .init(red: 0.7, green: 0.3, blue: 0.3, alpha: 1))
        }
    }
    
    private init(_ id: Id, colour: SKColor) {
        self.colour = colour
        self.texture = "skin_" + id.rawValue
    }
}
