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
        label.horizontalAlignmentMode = .center
        label.fontColor = .init(white: 0.7, alpha: 1)
        label.bold(14)
        addChild(label)
        self.label = label
        
        counter(0)
    }
    
    func align() {
        label.position.y = (scene!.frame.height / 2) - 55
    }
    
    func counter(_ count: Int) {
        label.text = formatter.string(from: .init(count))!
    }
}
