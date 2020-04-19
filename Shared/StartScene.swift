import SpriteKit

final class StartScene: SKScene {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init(size: .zero)
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        
        let press = SKLabelNode(attributedText: .init(string: .key("StartScene.press"),
                                                      attributes: [.font: NSFont.systemFont(ofSize: 18, weight: .bold),
                                                                   .foregroundColor: NSColor.white]))
        press.alpha = 0
        press.verticalAlignmentMode = .center
        addChild(press)
        press.run(.repeatForever(.sequence([.fadeIn(withDuration: 0.5), .wait(forDuration: 1), .fadeOut(withDuration: 0.5)])))
    }
}
