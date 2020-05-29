import SpriteKit

final class Others: SKNode {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        zPosition = 11
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / -2) + 10, y: (scene!.frame.height / 2) - 60)
    }
    
    func player(_ id: Int, skin: Skin.Id, name: String) {
        addChild(Item(id: id, skin: skin, name: name))
    }
    
    func explode(_ player: Int) {
        children.compactMap { $0 as? Item }.first { $0.id == player }?.run(.fadeOut(withDuration: 1))
    }
}

private final class Item: SKShapeNode {
    let id: Int
    
    required init?(coder: NSCoder) { nil }
    init(id: Int, skin: Skin.Id, name: String) {
        self.id = id
        super.init()
        lineWidth = 0
        fillColor = Skin.make(id: skin).colour.withAlphaComponent(0.95)
        path = .init(roundedRect: .init(x: 0, y: 0, width: 150, height: 26), cornerWidth: 7, cornerHeight: 7, transform: nil)
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.bold(13)
        label.fontColor = .black
        label.text = name
        label.verticalAlignmentMode = .center
        label.position = .init(x: 7, y: 13)
        addChild(label)
    }
}
