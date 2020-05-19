import SpriteKit

final class Defeated: SKNode {
    private weak var label: SKLabelNode!
    private weak var title: SKLabelNode!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
        formatter.numberStyle = .decimal
        
        let title = SKLabelNode()
        title.horizontalAlignmentMode = .left
        title.text = .key("Defeated")
        title.alpha = 0.7
        title.bold(12)
        addChild(title)
        self.title = title
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.text = "0"
        label.bold(18)
        addChild(label)
        self.label = label
    }
    
    func align() {
        title.position = .init(x: (scene!.frame.width / -2) + 12, y: (scene!.frame.height / -2) + 100)
        label.position = .init(x: (scene!.frame.width / -2) + 14, y: (scene!.frame.height / -2) + 75)
    }
    
    func counter(_ count: Int) {
        label.text = formatter.string(from: .init(value: count))!
    }
}
