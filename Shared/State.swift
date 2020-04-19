import GameplayKit

class State: GKState {
    var press = [CGPoint]()
    private weak var view: View!
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
    
    private func control() { }
    
    final class Start: State {
        override func didEnter(from: GKState?) {
            super.didEnter(from: from)
            let scene = StartScene()
            scene.delegate = view
            view.presentScene(scene, transition: .fade(withDuration: 3))
        }
        
        override func control() {
            guard let _ = press.popLast() else { return }
            
            let scene = PlayScene()
            scene.delegate = view
            view.presentScene(scene, transition: .fade(withDuration: 1.5))
            stateMachine!.enter(Play.self)
        }
    }

    final class Play: State {
        override func didEnter(from: GKState?) {
            super.didEnter(from: from)
            
        }
        
        override func control() {
            guard let press = self.press.popLast() else { return }
    //        scene.area.setTileGroup(tilePrepare, forColumn: scene.area.tileColumnIndex(fromPosition: press), row: scene.area.tileRowIndex(fromPosition: press))
        }
    }
}
