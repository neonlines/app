import GameplayKit

final class Playing: State {
    private var timer = TimeInterval()
    
    override func didEnter(from: GKState?) {
        super.didEnter(from: from)
        timer = 0.02
    }
    
    override func update(deltaTime: TimeInterval) {
        timer -= deltaTime
        if timer <= 0 {
            timer = 0.02
            (view.scene as? Grid)?.player.move()
        }
    }
    
    override func startRotating() {
        (view.scene as? Grid)?.startRotating()
    }
    
    override func rotate(_ radians: CGFloat) {
        (view.scene as? Grid)?.rotate(radians)
    }
}
