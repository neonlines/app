import GameplayKit

extension GKEntity {
    final class Node: GKEntity {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            addComponent(.Sprite("node", size: 32))
            addComponent(.Draw())
            addComponent(.Speed())
        }
    }
    
    final class Path: GKEntity {
        required init?(coder: NSCoder) { nil }
        init(_ position: CGPoint) {
            super.init()
            addComponent(.Sprite("path", size: 10))
            component(ofType: GKComponent.Sprite.self)!.sprite.position = position
        }
    }
}
