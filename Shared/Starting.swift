import GameplayKit

final class Starting: State {
    override func didEnter(from: GKState?) {
        super.didEnter(from: from)
        let scene = Title()
        scene.delegate = view
        view.presentScene(scene, transition: .fade(withDuration: 3))
    }
    
    override func control() {
        guard !press.isEmpty else { return }
        let scene = Grid()
        scene.delegate = view
        view.presentScene(scene, transition: .crossFade(withDuration: 1.5))
        stateMachine!.enter(Playing.self)
    }
}