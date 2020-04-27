import SpriteKit

final class Line: SKShapeNode {
    private weak var grid: Grid!
    private var points = [CGPoint]() {
        didSet {
            path = {
                $0.addLines(between: self.points)
                return $0
            } (CGMutablePath())
            
            let points = self.points.dropLast(10)
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
    init(grid: Grid, color: SKColor) {
        super.init()
        lineWidth = 20
        lineCap = .round
        zPosition = 1
        strokeColor = color
        points.reserveCapacity(max)
        self.grid = grid
    }
    
    func append(_ position: CGPoint) {
        points = (points + [position]).suffix(max)
    }
    
    func recede() {
        guard points.count > 0 else {
            grid.remove(self)
            return
        }
        points.removeFirst()
    }
}
