import SpriteKit

final class Wheel: SKSpriteNode {
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
