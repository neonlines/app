import GameplayKit

final class GameOver: State {
    private var closing = TimeInterval()
    private var timer = TimeInterval()
    
    override func didEnter(from: GKState?) {
        super.didEnter(from: from)
        closing = 3
        timer = 0.02
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        closing -= deltaTime
        timer -= deltaTime
        if closing <= 0 {
            stateMachine!.enter(Starting.self)
        }
        if timer <= 0 {
            timer = 0.02
            (view.scene as? Grid)?.player.recede()
        }
    }
}
