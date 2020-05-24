import SpriteKit

final class Wheel: SKSpriteNode {
    weak var player: Player?
    private let delta = CGFloat(0.02)
    
    override var zRotation: CGFloat {
        didSet {
            guard let player = self.player else { return }
            let rotation = -zRotation
            let minDelta = player.zRotation - delta
            let maxDelta = player.zRotation + delta
            if rotation >= 0 {
                if player.zRotation >= 0 {
                    if rotation >= player.zRotation {
                        player.zRotation = min(rotation, maxDelta)
                    } else {
                        player.zRotation = max(rotation, minDelta)
                    }
                } else {
                    let inverse = (2 * .pi) + player.zRotation
                    if rotation >= inverse {
                        player.zRotation = min(rotation, inverse + delta)
                    } else {
                        player.zRotation = max(rotation, inverse - delta)
                    }
                }
            } else {
                if player.zRotation <= 0 {
                    if rotation < player.zRotation {
                        player.zRotation = max(rotation, minDelta)
                    } else {
                        player.zRotation = min(rotation, maxDelta)
                    }
                } else {
                    let inverse = player.zRotation - (2 * .pi)
                    if rotation < inverse {
                        player.zRotation = max(rotation, inverse - delta)
                    } else {
                        player.zRotation = min(rotation, inverse + delta)
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
