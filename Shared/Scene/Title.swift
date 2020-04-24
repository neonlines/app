import SpriteKit

final class Title: Scene {
    override func didMove(to: SKView) {
        let press = SKLabelNode(attributedText: .init(string: .key("Press.start"), attributes: [.font: NSFont.systemFont(ofSize: 18, weight: .bold),
                                                                                                .foregroundColor: NSColor.labelColor]))
        press.alpha = 0
        press.verticalAlignmentMode = .center
        addChild(press)
        press.run(.repeatForever(.sequence([.fadeIn(withDuration: 0.5), .wait(forDuration: 1), .fadeOut(withDuration: 0.5)])))
    }
}
