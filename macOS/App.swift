import AppKit
import GameKit

let game = GameMaster()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, GameDelegate {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        game.delegate = self
        game.auth()
        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
    }
    
    func auth(_ controller: NSViewController) {
        NSWindow(contentViewController: controller).makeKeyAndOrderFront(self)
    }
    
    func dismissGameCenter() {
        GKDialogController.shared().dismiss(self)
    }
    
    func newGame(_ view: View) {
        windows.first!.show(view)
    }
    
    func show(_ controller: GKViewController) {
        GKDialogController.shared().parentWindow = windows.first
        switch controller {
        case let controller as GKMatchmakerViewController:
            GKDialogController.shared().present(controller)
        case let controller as GKGameCenterViewController:
            GKDialogController.shared().present(controller)
        default: break
        }
    }
    
    func gameCenterError() {
        let alert = NSAlert()
        alert.messageText = .key("Game.center.error")
        alert.informativeText = .key("Check.you.are.logged")
        alert.addButton(withTitle: .key("Continue"))
        alert.addButton(withTitle: .key("Go.to.settings"))
        alert.alertStyle = .informational
        alert.beginSheetModal(for: windows.first!) {
            if $0 == .alertSecondButtonReturn {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.internet_accounts")!)
            }
        }
    }
}
