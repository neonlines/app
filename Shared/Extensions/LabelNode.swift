import SpriteKit

#if os(macOS)

extension SKLabelNode {
    func bold(_ size: CGFloat) {
        fontSize = size
        fontName = NSFont.systemFont(ofSize: 18, weight: .bold).fontName
    }
}

#endif
#if os(iOS)

extension SKLabelNode {
    func bold(_ size: CGFloat) {
        fontSize = size
        fontName = "Arial-BoldMT"
    }
}

#endif
