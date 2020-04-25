import GameplayKit

final class View: SKView, SKSceneDelegate {
    private(set) var state: GKStateMachine!
    private var time = TimeInterval()
    private var drag: CGFloat?
    
    override var mouseDownCanMoveWindow: Bool { true }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        showsFPS = true
        
        state = .init(states: [Starting(self), Playing(self), GameOver(self)])
        state.enter(Starting.self)
    }
    
    override func viewDidEndLiveResize() {
        (scene as? Scene)?.align()
    }
    
    func update(_ time: TimeInterval, for: SKScene) {
        state.update(deltaTime: self.time == 0 ? 0 : time - self.time)
        self.time = time
    }
    
    override func mouseDown(with: NSEvent) {
        let point = convert(with)
        if point.valid {
            drag = point.radians
            (state.currentState as! State).startRotation()
        } else {
            drag = nil
        }
    }
    
    override func mouseDragged(with: NSEvent) {
        let point = convert(with)
        if point.valid {
            NSCursor.pointingHand.set()
            if let drag = self.drag {
                (state.currentState as! State).rotate(point.radians - drag)
            }
        } else {
            drag = nil
        }
    }
    
    override func mouseUp(with: NSEvent) {
        (state.currentState as! State).press.insert(with.location(in: scene!), at: 0)
        drag = nil
        NSCursor.arrow.set()
    }
    
    private func convert(_ event: NSEvent) -> CGPoint {
        {
            .init(x: $0.x - frame.midX, y: $0.y)
        } (convert(event.locationInWindow, from: nil))
    }
}

private extension CGPoint {
    var valid: Bool {
        let distance = pow(x, 2) + pow(y, 2)
        return distance > 900 && distance < 19_600
    }
    
    var radians: CGFloat {
        atan2(x, y)
    }
}
