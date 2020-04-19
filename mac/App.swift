import Git
import Balam
import AppKit

let balam = Balam("awoca")
let git = Git()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
    
    func applicationDidBecomeActive(_: Notification) {
//        news.refresh()
    }
    
    func applicationWillFinishLaunching(_: Notification) {
//        mainMenu = Menu()
        Launch().makeKeyAndOrderFront(nil)
    }
    
//    @objc func preferences() {
//        windows.filter { $0 is Settings }.forEach { $0.close() }
//        Settings().makeKeyAndOrderFront(nil)
//    }
}
