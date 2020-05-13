import UIKit

final class Controller: UIViewController {
    private let radius: CGFloat
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        self.radius = radius
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = Game(radius: radius)
    }
}
