import AppKit

extension NSColor {
    static let indigoLight = NSColor(named: "indigoLight")!
    static let indigoDark = NSColor(named: "indigoDark")!
}

extension CGColor {
    static let indigoLight = NSColor.indigoLight.cgColor
    static let indigoDark = NSColor.indigoDark.cgColor
}
