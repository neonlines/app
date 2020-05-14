import AppKit
import Balam
import Combine
import GameKit

var profile = Profile()
let balam = Balam("lines")

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, GKGameCenterControllerDelegate {
    private var subs = Set<AnyCancellable>()
    private let board = "neon.lines.scores"
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
        balam.nodes(Profile.self).sink {
            guard let stored = $0.first else {
                balam.add(profile)
                return
            }
            profile = stored
        }.store(in: &subs)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        GKLocalPlayer.local.authenticateHandler = { [weak self] controller, _ in
            guard let controller = controller else { return }
            NSWindow(contentViewController: controller).makeKeyAndOrderFront(self)
        }
    }
    
    func leaderboards() {
        guard false && GKLocalPlayer.local.isAuthenticated else {
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
            return
        }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = board
        GKDialogController.shared().parentWindow = windows.first
        GKDialogController.shared().present(controller)
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        GKDialogController.shared().dismiss(self)
    }
    
    func score(_ points: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = .init(points)
        GKScore.report([report])
    }
}
