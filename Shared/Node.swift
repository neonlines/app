import GameplayKit

final class Node: GKEntity {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        addComponent(Sprite())
    }
}
