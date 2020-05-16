#if os(macOS)
import AppKit

extension NSColor {
    static let indigo = NSColor(named: "indigo")!
    static let background = NSColor.windowBackgroundColor
    static let text = NSColor.labelColor
}

extension CGColor {
    static let indigo = NSColor.indigo.cgColor
    static let background = NSColor.windowBackgroundColor.cgColor
    static let text = NSColor.labelColor.cgColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    static let indigo = UIColor(named: "indigo")!
    static let background = UIColor.secondarySystemBackground
    static let text = UIColor.label
}

extension CGColor {
    static let indigo = UIColor.indigo.cgColor
    static let background = UIColor.tertiarySystemBackground.cgColor
    static let text = UIColor.label.cgColor
}
#endif
