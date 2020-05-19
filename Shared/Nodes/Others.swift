import SpriteKit

final class Others: SKNode {
    private var y = CGFloat()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / -2) + 10, y: (scene!.frame.height / -2) + 18)
    }
    
    func player(_ id: Int, skin: Skin.Id, name: String) {
        addChild(Item(id: id, skin: skin, name: name, y: y))
        y += 28
    }
    
    func explode(_ player: Int) {
        children.map { $0 as! Item }.first { $0.id == player }?.run(.fadeOut(withDuration: 1))
    }
}

private final class Item: SKShapeNode {
    let id: Int
    
    required init?(coder: NSCoder) { nil }
    init(id: Int, skin: Skin.Id, name: String, y: CGFloat) {
        self.id = id
        super.init()
        lineWidth = 0
        fillColor = Skin.make(id: skin).colour.withAlphaComponent(0.95)
        position.y = y
        path = .init(roundedRect: .init(x: 0, y: 0, width: 110, height: 22), cornerWidth: 6, cornerHeight: 6, transform: nil)
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.bold(12)
        label.fontColor = .background
        label.text = .init(name.prefix(16))
        label.verticalAlignmentMode = .bottom
        label.position = .init(x: 5, y: 3)
        addChild(label)
    }
}
