import UIKit

final class Game: View {
    weak var controller: Controller!
    
    override func show(_ score: Int) {
        controller.navigationController?.show(Score(points: score))
    }
}
