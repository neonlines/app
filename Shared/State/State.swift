import GameplayKit

class State: GKState {
    var press = [CGPoint]()
    private(set) weak var view: View!
    private var timer = TimeInterval()
    
    init(_ view: View) {
        super.init()
        self.view = view
    }
    
    override func didEnter(from: GKState?) {
        press = []
    }
    
    override func update(deltaTime: TimeInterval) {
        timer -= deltaTime
        if timer <= 0 {
            timer = 0.15
            control()
        }
        view.scene!.update(deltaTime)
    }
    
    func control() { }
}
