import GameplayKit

extension GKState {
    class State: GKState {
        var press = [CGPoint]()
        fileprivate weak var view: View!
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
        }
        
        fileprivate func control() { }
    }
        
    final class Start: State {
        override func didEnter(from: GKState?) {
            super.didEnter(from: from)
            let scene = SKScene.Start()
            scene.delegate = view
            view.presentScene(scene, transition: .fade(withDuration: 3))
        }
        
        override func control() {
            guard let _ = press.popLast() else { return }
            
            let scene = SKScene.Play()
            scene.delegate = view
            view.presentScene(scene, transition: .crossFade(withDuration: 1.5))
            stateMachine!.enter(Play.self)
        }
    }

    final class Play: State {
        override func update(deltaTime: TimeInterval) {
            super.update(deltaTime: deltaTime)
            view.scene!.update(deltaTime)
        }
    }
}
