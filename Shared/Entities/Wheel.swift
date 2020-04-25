import GameplayKit

final class Wheel: GKEntity {
    let node = SKSpriteNode(texture: .init(imageNamed: "wheel"), size: .init(width: 240, height: 120))
    
    func align() {
        node.position.y = (node.scene!.frame.height / -2) + 60
    }
}
