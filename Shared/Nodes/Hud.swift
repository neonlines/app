import SpriteKit

final class Hud: SKShapeNode {
    private weak var label: SKLabelNode!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        lineWidth = 0
        zPosition = 11
        formatter.numberStyle = .decimal
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.bold(18)
        label.fontColor = UI.darkMode ? .white : .black
        label.position.y = -6
        addChild(label)
        self.label = label
    }
    
    func align() {
        position.y = (scene!.frame.height / -2) + 30
        path = .init(rect: .init(x: scene!.frame.width / -2, y: -30, width: scene!.frame.width, height: 60), transform: nil)
        label.position.x = (scene!.frame.width / -2) + 20
    }
    
    func counter(_ count: Int) {
        label.text = formatter.string(from: .init(value: count))!
    }
}
