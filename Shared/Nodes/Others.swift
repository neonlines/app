import GameKit

final class Others: SKNode {
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / -2) + 5, y: (scene!.frame.height / -2) + 5)
    }
    
    func load(_ match: GKMatch) {
        var y = CGFloat()
        match.players.forEach {
            let label = SKLabelNode()
            label.horizontalAlignmentMode = .left
            label.bold(12)
            label.text = $0.displayName
            label.position.y = y
            label.verticalAlignmentMode = .bottom
            addChild(label)
            y += 20
        }
    }
}
