import GameplayKit

class State: GKState {
    var scene: Scene { view.scene as! Scene }
    var press = [CGPoint]()
    private(set) weak var view: View!
    private var controlTimer = TimeInterval()
    private var moveTimer = TimeInterval()
    
    init(_ view: View) {
        super.init()
        self.view = view
    }
    
    override func didEnter(from: GKState?) {
        press = []
        controlTimer = 0.15
        moveTimer = 0.02
    }
    
    override func update(deltaTime: TimeInterval) {
        controlTimer -= deltaTime
        if controlTimer <= 0 {
            controlTimer = 0.15
            if !press.isEmpty {
                control(press.removeFirst())
            }
        }
        
        moveTimer -= deltaTime
        if moveTimer <= 0 {
            moveTimer = 0.02
            move()
        }
    }
    
    func control(_ point: CGPoint) { }
    func move() { }
    func startRotating() { }
    func rotate(_ radians: CGFloat) { }
}
