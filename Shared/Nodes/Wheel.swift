import SpriteKit

final class Wheel: SKSpriteNode {
    weak var player: Player?
    private let delta = CGFloat(0.02)
    
    override var zRotation: CGFloat {
        didSet {
            guard let player = self.player else { return }
            let rotation = zRotation <= 0 ? -zRotation : (.pi * 2) - zRotation
            let current = player.zRotation >= 0 ? player.zRotation : (.pi * 2) - player.zRotation
            if rotation >= current {
                player.zRotation = min(rotation, current + delta)
            } else {
                player.zRotation = max(rotation, current - delta)
            }
            
            print("rotation: \(rotation)  \(rotation >= current) : \(player.zRotation)")
        }
    }
    
    var on = false {
        didSet {
            update()
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(texture: nil, color: .clear, size: .init(width: 182, height: 182))
        zPosition = 10
        update()
    }
    
    func align() {
        position.y = (scene!.frame.height / -2) + 200
    }
    
    private func update() {
        texture = .init(imageNamed: "wheel_" + (on ? "on" : "off"))
    }
}
