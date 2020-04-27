import SpriteKit

final class Wheel: SKSpriteNode {
    private(set) weak var player: Player!
    
    override var zRotation: CGFloat {
        didSet {
            player.zRotation = -zRotation
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(player: Player) {
        super.init(texture: .init(imageNamed: "wheel" + (NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? "_dark" : "_light")), color: .clear, size: .init(width: 240, height: 240))
        zPosition = 10
        self.player = player
    }
    
    func align() {
        position.y = (scene!.frame.height / -2) + 60
    }
}
