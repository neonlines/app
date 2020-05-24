import SpriteKit

final class Wheel: SKSpriteNode {
    weak var player: Player?
    private let delta = CGFloat(0.02)
    
    override var zRotation: CGFloat {
        didSet {
            guard let player = self.player else { return }
            if zRotation <= 0 {
                if player.zRotation >= 0 {
                    if -zRotation >= player.zRotation {
                        player.zRotation = min(-zRotation, player.zRotation + delta)
                    } else {
                        player.zRotation = max(-zRotation, player.zRotation - delta)
                    }
                } else {
                    let inverse = (.pi * 2) - player.zRotation
                    if -zRotation >= inverse {
                        player.zRotation = min(-zRotation, inverse + delta)
                    } else {
                        player.zRotation = max(-zRotation, inverse - delta)
                    }
                }
            } else {
                if player.zRotation <= 0 {
                    if -zRotation < player.zRotation {
                        player.zRotation = max(-zRotation, player.zRotation - delta)
                    } else {
                        player.zRotation = min(-zRotation, player.zRotation + delta)
                    }
                } else {
                    let inverse = player.zRotation - (.pi * 2)
                    if -zRotation < inverse {
                        player.zRotation = max(-zRotation, inverse - delta)
                    } else {
                        player.zRotation = min(-zRotation, inverse + delta)
                    }
                }
            }
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
