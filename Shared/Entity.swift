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
            addComponent(.Fade())
            component(ofType: GKComponent.Sprite.self)!.sprite.position = position
        }
    }
    
    final class Wheel: GKEntity {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            addComponent(.Sprite("wheel", size: 240))
            component(ofType: GKComponent.Sprite.self)!.sprite.position.y = -150
        }
    }
}
