import SpriteKit

final class Line: SKShapeNode {
    private let max = 500
    private var points = [CGPoint]() {
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
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        lineWidth = 16
        lineCap = .round
        strokeColor = .init(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        points.reserveCapacity(max)
    }
    
    func append(_ position: CGPoint) {
        points = (points + [position].suffix(max))
    }
    
    func recede() {
        if points.count > 0 {
            points.removeFirst()
        }
    }
}
