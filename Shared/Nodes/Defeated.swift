import SpriteKit

final class Defeated: SKNode {
    private weak var label: SKLabelNode!
    private weak var icon: SKSpriteNode!
    private weak var beamer: SKShapeNode!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
        formatter.numberStyle = .decimal
        
        let beamer = SKShapeNode(circleOfRadius: 12)
        beamer.fillColor = .indigoLight
        beamer.lineWidth = 0
        addChild(beamer)
        self.beamer = beamer
        
        let icon = SKSpriteNode(texture: .init(imageNamed: "counter"))
        addChild(icon)
        self.icon = icon
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.text = "0"
        label.fontColor = .init(white: 0.6, alpha: 1)
        label.bold(16)
        addChild(label)
        self.label = label
    }
    
    func align() {
        icon.position = .init(x: (scene!.frame.width / -2) + 35, y: (scene!.frame.height / 2) - 60)
        label.position = .init(x: (scene!.frame.width / -2) + 55, y: (scene!.frame.height / 2) - 60)
        beamer.position = icon.position
    }
    
    func counter(_ count: Int) {
        label.text = formatter.string(from: .init(value: count))!
        beamer.alpha = 1
        beamer.setScale(1)
        beamer.run(.group([.fadeOut(withDuration: 1), .scale(to: 2, duration: 1)]))
    }
}
