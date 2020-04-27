import GameplayKit

final class GameOver: State {
    private var closing = TimeInterval()
    
    override func didEnter(from: GKState?) {
        super.didEnter(from: from)
        closing = 3
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        closing -= deltaTime
        if closing <= 0 {
            stateMachine!.enter(Starting.self)
        }
    }
    
    override func move() {
        scene.move()
    }
}
