#if os(macOS)

import AppKit

struct UI {
    static var darkMode: Bool { NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) }
}

#endif
#if os(iOS)

import UIKit

struct UI {
    static var darkMode: Bool { UITraitCollection.current.userInterfaceStyle == .dark }
}

#endif
