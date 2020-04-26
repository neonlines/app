import SpriteKit

final class Hud: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        fillColor = .windowBackgroundColor
        strokeColor = .black
        lineWidth = 1
        zPosition = 2
    }
    
    func align() {
        path = .init(rect: .init(x: scene!.frame.width / -2, y: (scene!.frame.height / -2), width: scene!.frame.width, height: 50), transform: nil)
    }
}
