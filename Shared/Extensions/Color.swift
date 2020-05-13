#if os(macOS)
import AppKit

extension NSColor {
    static let indigoLight = NSColor(named: "indigoLight")!
    static let indigoDark = NSColor(named: "indigoDark")!
    static let background = NSColor.windowBackgroundColor
    static let text = NSColor.labelColor
}

extension CGColor {
    static let indigoLight = NSColor.indigoLight.cgColor
    static let indigoDark = NSColor.indigoDark.cgColor
    static let background = NSColor.windowBackgroundColor.cgColor
    static let text = NSColor.labelColor.cgColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    static let indigoLight = UIColor(named: "indigoLight")!
    static let indigoDark = UIColor(named: "indigoDark")!
    static let background = UIColor.systemBackground
    static let text = UIColor.label
}

extension CGColor {
    static let indigoLight = UIColor.indigoLight.cgColor
    static let indigoDark = UIColor.indigoDark.cgColor
    static let background = UIColor.systemBackground.cgColor
    static let text = UIColor.label.cgColor
}
#endif
