import SpriteKit

final class Hud: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        fillColor = .windowBackgroundColor
        strokeColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .black : .white
        lineWidth = 1
        zPosition = 2
    }
    
    func align() {
        position.y = (scene!.frame.height / -2) + 30
        path = .init(rect: .init(x: scene!.frame.width / -2, y: -30, width: scene!.frame.width, height: 60), transform: nil)
    }
}
