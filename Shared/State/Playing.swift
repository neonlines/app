import SpriteKit

final class Playing: State {
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        view.scene!.update(deltaTime)
    }
}
