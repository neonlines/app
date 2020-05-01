import SpriteKit

final class Line: SKShapeNode {
    private(set) var points = [CGPoint]() {
        didSet {
            path = {
                $0.addLines(between: self.points)
                return $0
            } (CGMutablePath())
            
            let points = self.points.dropLast(6)
            guard !points.isEmpty else { return }
            physicsBody = .init(edgeChainFrom: {
                $0.addLines(between: .init(points))
                return $0
            } (CGMutablePath()))
            physicsBody!.collisionBitMask = .none
            physicsBody!.contactTestBitMask = .none
            physicsBody!.categoryBitMask = .line
        }
    }
    
    let skin: Skin
    
    required init?(coder: NSCoder) { nil }
    init(skin: Skin) {
        self.skin = skin
        super.init()
        lineWidth = 20
        lineCap = .round
        zPosition = 1
        strokeColor = skin.colour
        points.reserveCapacity(350)
    }
    
    func append(_ position: CGPoint) {
        points = (points + [position]).suffix(350)
    }
    
    func recede() {
        guard points.count > 0 else {
            (scene!.view as! View).remove(self)
            return
        }
        points.removeFirst()
    }
}
