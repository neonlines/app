import SpriteKit

struct Skin {
    enum Id: Int, Codable {
        case
        basic
    }
    
    let colour: SKColor
    let texture: String
    
    static func make(id: Id) -> Skin {
        switch id {
        case .basic: return .init(colour: .init(white: 0.85, alpha: 1), texture: "")
        }
    }
}
