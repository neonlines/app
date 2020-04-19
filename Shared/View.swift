import GameplayKit

final class View: SKView, SKSceneDelegate {
    private(set) var state: GKStateMachine!
    private var time = TimeInterval()
    
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
        print(convert(with))
        if valid(convert(with)) {
//            drag = .start(x: 0, y: 0)
            print("valid")
        } else {
            print("not")
        }
    }
    
    override func mouseUp(with: NSEvent) {
        (state.currentState as! GKState.State).press.insert(with.location(in: scene!), at: 0)
    }
    
    private func convert(_ event: NSEvent) -> CGPoint {
        {
            .init(x: $0.x - frame.midX, y: $0.y - frame.midY + 150)
        } (convert(event.locationInWindow, from: nil))
    }
    
    private func valid(_ point: CGPoint) -> Bool {
        let distance = pow(point.x, 2) + pow(point.y, 2)
        return distance > 900 && distance < 19_600
    }
}
