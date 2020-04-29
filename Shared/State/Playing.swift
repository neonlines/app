import GameplayKit

final class Playing: State {
    private var timer = TimeInterval()
    
    override func didEnter(from: GKState?) {
        super.didEnter(from: from)
        timer = 0.2
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        timer -= deltaTime
        if timer <= 0 {
            timer = 0.2
            scene.foes()
        }
    }
    
    override func startRotating() {
        scene.startRotating()
    }
    
    override func rotate(_ radians: CGFloat) {
        scene.rotate(radians)
    }
    
    override func move() {
        scene.move()
    }
}
