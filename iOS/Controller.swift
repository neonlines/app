import UIKit

final class Controller: UIViewController {
    private let radius: CGFloat
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        self.radius = radius
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let game = Game(radius: radius)
        game.controller = self
        view = game
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (view as! Game).align()
    }
}
