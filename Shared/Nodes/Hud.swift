import SpriteKit

final class Hud: SKNode {
    private weak var label: SKLabelNode!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
        formatter.numberStyle = .decimal
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .right
        label.bold(18)
        addChild(label)
        self.label = label
    }
    
    func align() {
        label.position = .init(x: (scene!.frame.width / 2) - 8, y: (scene!.frame.height / -2) + 72)
    }
    
    func counter(_ count: Int) {
        label.text = formatter.string(from: .init(value: count))!
    }
}
