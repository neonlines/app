import SpriteKit

final class Line: SKShapeNode {
    private(set) var points = [CGPoint]() {
        didSet {
            path = {
                $0.addLines(between: self.points)
                return $0
            } (CGMutablePath())
            
            let points = self.points.dropLast(12)
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
    
    private let max = 500
    
    required init?(coder: NSCoder) { nil }
    init(color: SKColor) {
        super.init()
        lineWidth = 20
        lineCap = .round
        zPosition = 1
        strokeColor = color
        points.reserveCapacity(max)
    }
    
    func append(_ position: CGPoint) {
        points = (points + [position]).suffix(max)
    }
    
    func recede() {
        guard points.count > 0 else {
            (scene!.view as! View).remove(self)
            return
        }
        points.removeFirst()
    }
}
