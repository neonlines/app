import GameKit

final class Others: SKNode {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / -2) + 10, y: (scene!.frame.height / -2) + 18)
    }
    
    func load(_ match: GKMatch) {
        var y = CGFloat()
        match.players.forEach {
            addChild(Item(player: $0, y: y))
            y += 28
        }
    }
}

private final class Item: SKShapeNode {
    private let player: GKPlayer
    
    required init?(coder: NSCoder) { nil }
    init(player: GKPlayer, y: CGFloat) {
        self.player = player
        super.init()
        lineWidth = 0
        fillColor = SKColor.text.withAlphaComponent(0.5)
        position.y = y
        path = .init(roundedRect: .init(x: 0, y: 0, width: 110, height: 22), cornerWidth: 6, cornerHeight: 6, transform: nil)
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.bold(12)
        label.fontColor = .background
        label.text = .init(player.displayName.prefix(16))
        label.verticalAlignmentMode = .bottom
        label.position = .init(x: 5, y: 3)
        addChild(label)
    }
}
