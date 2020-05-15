import GameKit

final class Controller: UIViewController {
    let haptics = UIImpactFeedbackGenerator(style: .heavy)
    private let game: View
    
    required init?(coder: NSCoder) { nil }
    init(_ view: View) {
        game = view
        super.init(nibName: nil, bundle: nil)
        haptics.prepare()
    }
    
    override func loadView() {
        view = game
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (view as! View).align()
    }
}
