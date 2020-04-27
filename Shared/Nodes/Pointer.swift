import SpriteKit

final class Pointer: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    
    init(color: SKColor, position: CGPoint) {
        super.init()
        path = .init(ellipseIn: .init(x: -8 + position.x, y: -8 + position.y, width: 16, height: 16), transform: nil)
        lineWidth = 1
        fillColor = color
        strokeColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .black : .white
        alpha = 0.75
        zPosition = 9
    }
}
