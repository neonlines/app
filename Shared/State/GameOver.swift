import GameplayKit

final class GameOver: State {
    private var timer = TimeInterval()
    
    override func didEnter(from: GKState?) {
        super.didEnter(from: from)
        timer = 500
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        timer -= 1
        if timer < 0 {
            stateMachine!.enter(Starting.self)
        }
    }
}
