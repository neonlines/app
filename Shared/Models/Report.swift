import CoreGraphics

struct Report: Codable {
    enum Mode: UInt8, Codable {
        case
        positions,
        profile,
        move
    }
    
    struct Position: Codable {
        let player: String
        let position: CGPoint
    }

    struct Profile: Codable {
        let player: String
        let position: CGPoint
        let rotation: CGFloat
        let skin: Skin.Id
    }
    
    struct Move: Codable {
        let player: String
        let position: CGPoint
        let rotation: CGFloat
    }
    
    var positions: [Position]?
    var profile: Profile?
    var move: Move?
}
