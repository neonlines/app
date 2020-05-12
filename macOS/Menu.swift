import AppKit

final class Menu: NSMenu {
    required init(coder: NSCoder) { fatalError() }
    init() {
        super.init(title: "")
        items = [neonlines, window, help]
    }

    private var neonlines: NSMenuItem {
        menu(.key("Neon.lines"), items: [
            .init(title: .key("About"), action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""),
        .separator(),
        .init(title: .key("Hide"), action: #selector(NSApplication.hide), keyEquivalent: "h"),
        {
            $0.keyEquivalentModifierMask = [.option, .command]
            return $0
        } (NSMenuItem(title: .key("Hide.others"), action: #selector(NSApplication.hideOtherApplications), keyEquivalent: "h")),
        .init(title: .key("Show.all"), action: #selector(NSApplication.unhideAllApplications), keyEquivalent: ""),
        .separator(),
        .init(title: .key("Quit"), action: #selector(NSApplication.terminate), keyEquivalent: "q")])
    }
    
    private var window: NSMenuItem {
        menu(.key("Window"), items: [
            .init(title: .key("Minimize"), action: #selector(Window.miniaturize), keyEquivalent: "m"),
            .init(title: .key("Zoom"), action: #selector(Window.zoom), keyEquivalent: "p"),
            .separator(),
            .init(title: .key("Bring.all"), action: #selector(NSApplication.arrangeInFront), keyEquivalent: ""),
            .separator(),
            .init(title: .key("Close"), action: #selector(NSWindow.close), keyEquivalent: "w")])
    }
    
    private var help: NSMenuItem {
        menu(.key("Help"), items: [])
    }
    
    private func menu(_ name: String, items: [NSMenuItem]) -> NSMenuItem {
        let menu = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menu.submenu = .init(title: name)
        menu.submenu?.items = items
        return menu
    }
}