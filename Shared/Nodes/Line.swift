import SpriteKit

final class Line: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    init(color: SKColor) {
        super.init()
        lineWidth = 32
        lineCap = .round
        zPosition = 1
        strokeColor = color
    }
}
