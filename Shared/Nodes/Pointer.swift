import SpriteKit

final class Pointer: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    
    init(color: SKColor, position: CGPoint) {
        super.init()
        path = .init(ellipseIn: .init(x: -8 + position.x, y: -8 + position.y, width: 12, height: 12), transform: nil)
        lineWidth = 2
        fillColor = color
        strokeColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .black : .white
        alpha = 0.3
        zPosition = 20
    }
}
