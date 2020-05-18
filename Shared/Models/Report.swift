import CoreGraphics

struct Report: Codable {
    enum Mode: UInt8, Codable {
        case
        position,
        profile,
        move
    }
    
    let mode: Mode
    let player: Int
    let position: CGPoint
    let rotation: CGFloat!
    let skin: Skin.Id!
    
    static func position(_ player: Int, position: CGPoint) -> Report {
        .init(.position, player: player, position: position, rotation: nil, skin: nil)
    }
    
    static func profile(_ player: Int, position: CGPoint, rotation: CGFloat, skin: Skin.Id) -> Report {
        .init(.profile, player: player, position: position, rotation: rotation, skin: skin)
    }
    
    static func move(_ player: Int, position: CGPoint, rotation: CGFloat) -> Report {
        .init(.move, player: player, position: position, rotation: rotation, skin: nil)
    }
    
    private init(_ mode: Mode, player: Int, position: CGPoint, rotation: CGFloat?, skin: Skin.Id?) {
        self.mode = mode
        self.player = player
        self.position = position
        self.rotation = rotation
        self.skin = skin
    }
}
