import SpriteKit

final class Hud: SKShapeNode {
    private weak var label: SKLabelNode!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        fillColor = .windowBackgroundColor
        strokeColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .black : .white
        lineWidth = 1
        zPosition = 11
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.fontSize = 16
        label.fontName = "bold"
        label.fontColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .white : .black
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
