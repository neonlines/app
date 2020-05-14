import GameKit

final class Controller: UIViewController {
    private let match: GKMatch?
    private let radius: CGFloat
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat, match: GKMatch?) {
        self.radius = radius
        self.match = match
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let game = Game(radius: radius, match: match)
        game.controller = self
        view = game
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (view as! Game).align()
    }
}
