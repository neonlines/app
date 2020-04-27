import GameplayKit

final class Playing: State {
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
