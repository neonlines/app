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
                        print("a")
                        player.zRotation = min(rotation, maxDelta)
                    } else {
                        print("b")
                        player.zRotation = max(rotation, minDelta)
                    }
                } else {
                    if rotation > .pi {
                        print("c")
                        player.zRotation = max(rotation - (2 * .pi), minDelta)
                    } else {
                        print("d")
                        player.zRotation = min(rotation, maxDelta)
                    }
                }
            } else {
                if player.zRotation < 0 {
                    if rotation < player.zRotation {
                        print("e")
                        player.zRotation = max(rotation, minDelta)
                    } else {
                        print("f")
                        player.zRotation = min(rotation, maxDelta)
                    }
                } else {
                    if rotation < -.pi {
                        print("g")
                        player.zRotation = min((2 * .pi) - rotation, maxDelta)
                    } else {
                        print("h")
                        player.zRotation = max(rotation, minDelta)
                    }
                }
            }
            print(player.zRotation)
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
