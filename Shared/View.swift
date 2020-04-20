import GameplayKit

final class View: SKView, SKSceneDelegate {
    private(set) var state: GKStateMachine!
    private var time = TimeInterval()
    private var drag = Drag.no
    
    override var mouseDownCanMoveWindow: Bool { true }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        showsFPS = true
        showsNodeCount = true
        
        state = .init(states: [.Start(self), .Play(self)])
        state.enter(GKState.Start.self)
    }
    
    func update(_ time: TimeInterval, for: SKScene) {
        state.update(deltaTime: self.time == 0 ? 0 : time - self.time)
        self.time = time
    }
    
    override func mouseDown(with: NSEvent) {
        if convert(with).valid {
            drag = .start(x: 0, y: 0)
        } else {
            drag = .no
        }
    }
    
    override func mouseDragged(with: NSEvent) {
        let point = convert(with)
        if point.valid {
            NSCursor.pointingHand.set()
            switch drag {
            case .drag:
                (state.currentState as! GKState.State).drag.append(point.radians)
            case .start(var x, var y):
                x += with.deltaX
                y += with.deltaY
                if abs(x) + abs(y) > 15 {
                    drag = .drag
                } else {
                    drag = .start(x: x, y: y)
                    (state.currentState as! GKState.State).drag = [point.radians]
                }
            default: break
            }
        } else {
            switch drag {
            case .start(_, _):
                drag = .no
            default: break
            }
        }
    }
    
    override func mouseUp(with: NSEvent) {
        (state.currentState as! GKState.State).press.insert(with.location(in: scene!), at: 0)
        (state.currentState as! GKState.State).drag = []
        drag = .no
        NSCursor.arrow.set()
    }
    
    private func convert(_ event: NSEvent) -> CGPoint {
        {
            .init(x: $0.x - frame.midX, y: $0.y - frame.midY + 150)
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
