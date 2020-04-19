import GameplayKit

final class View: SKView, SKSceneDelegate {
    private(set) var state: GKStateMachine!
    private var time = TimeInterval()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        
        state = .init(states: [.Start(self), .Play(self)])
        state.enter(GKState.Start.self)
    }
    
    func update(_ time: TimeInterval, for: SKScene) {
        state.update(deltaTime: self.time == 0 ? 0 : time - self.time)
        self.time = time
    }
    
    override func mouseUp(with: NSEvent) {
        (state.currentState as! GKState.State).press.insert(with.location(in: scene!), at: 0)
    }
}
