import GameplayKit

extension GKEntity {
    final class Node: GKEntity {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            addComponent(.Colour(.white, secondary: .init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)))
            addComponent(.Sprite("node", size: 32))
            addComponent(.Body(radius: 16))
            addComponent(.Path())
            addComponent(.Speed())
            addComponent(.Wheel())
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
