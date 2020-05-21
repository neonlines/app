import AppKit

final class Window: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 900, height: 700), styleMask: [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 500, height: 500)
        center()
        appearance = NSAppearance(named: .aqua)
        backgroundColor = .white
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        contentView = Options()
    }
    
    override func close() {
        NSApp.terminate(nil)
    }
}

extension NSWindow {
    func show(_ view: NSView) {
        makeFirstResponder(nil)
        NSAnimationContext.runAnimationGroup({
            $0.duration = 0.4
            $0.allowsImplicitAnimation = true
            contentView!.alphaValue = 0
        }) { [weak self] in
            view.wantsLayer = true
            view.alphaValue = 0
            self?.contentView = view
            NSAnimationContext.runAnimationGroup {
                $0.duration = 0.4
                $0.allowsImplicitAnimation = true
                view.alphaValue = 1
            }
        }
    }
}
