import SpriteKit

final class Wheel: SKSpriteNode {
    private(set) weak var player: Player!
    
    override var zRotation: CGFloat {
        didSet {
            player.zRotation = -zRotation
        }
    }
    
    var on = false {
        didSet {
            update()
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(player: Player) {
        super.init(texture: nil, color: .clear, size: .init(width: 182, height: 182))
        zPosition = 10
        self.player = player
        update()
    }
    
    func align() {
        position.y = (scene!.frame.height / -2) + 140
    }
    
    private func update() {
        texture = .init(imageNamed: "wheel_" + (on ? "on" : "off") + (UI.darkMode ? "_dark" : "_light"))
    }
}
