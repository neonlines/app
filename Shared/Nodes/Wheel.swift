import SpriteKit

final class Wheel: SKSpriteNode {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(texture: .init(imageNamed: "wheel" + (NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? "_dark" : "_light")), color: .clear, size: .init(width: 240, height: 240))
        zPosition = 1
    }
    
    func align() {
        position.y = (scene!.frame.height / -2) + 60
    }
    
    func rotate(_ radians: CGFloat) {
        zRotation = radians
    }
}
