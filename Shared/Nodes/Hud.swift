import SpriteKit

final class Hud: SKNode {
    private weak var label: SKLabelNode!
    private let formatter = DateComponentsFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.fontColor = .init(white: 0.7, alpha: 1)
        label.bold(14)
        addChild(label)
        self.label = label
        
        counter(0)
    }
    
    func align() {
        label.position = .init(x: (scene!.frame.width / -2) + 20, y: (scene!.frame.height / -2) + 25)
    }
    
    func counter(_ count: Int) {
        label.text = formatter.string(from: .init(count))!
    }
}
