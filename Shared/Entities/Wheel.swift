import GameplayKit

final class Wheel: GKEntity {
    let node = SKSpriteNode(texture: .init(imageNamed: "wheel" + (NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? "_dark" : "_light")), size: .init(width: 240, height: 240))
    
    func align() {
        node.position.y = node.scene!.frame.height / -2
    }
    
    func rotate(_ radians: CGFloat) {
        node.zRotation = radians
    }
}
