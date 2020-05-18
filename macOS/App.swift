import AppKit
import Balam
import Combine
import GameKit

var profile = Profile()
let balam = Balam("lines")

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate {
    private var subs = Set<AnyCancellable>()
    private let board = "neon.lines.scores"
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        GKLocalPlayer.local.authenticateHandler = { [weak self] controller, _ in
            guard let controller = controller else { return }
            NSWindow(contentViewController: controller).makeKeyAndOrderFront(self)
        }
        
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
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFind: GKMatch) {
        GKDialogController.shared().dismiss(self)
        newGame(MultiplayerView(radius: 3_000, match: didFind))
    }
    
    func matchmakerViewControllerWasCancelled(_: GKMatchmakerViewController) {
        GKDialogController.shared().dismiss(self)
    }
    
    func matchmakerViewController(_: GKMatchmakerViewController, didFailWithError: Error) {
        GKDialogController.shared().dismiss(self)
    }
    
    func gameCenterViewControllerDidFinish(_: GKGameCenterViewController) {
        GKDialogController.shared().dismiss(self)
    }
    
    func leaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else {
            gameCenterError()
            return
        }
        let controller = GKGameCenterViewController()
        controller.viewState = .leaderboards
        controller.gameCenterDelegate = self
        controller.leaderboardIdentifier = board
        GKDialogController.shared().parentWindow = windows.first
        GKDialogController.shared().present(controller)
    }
    
    func score(_ points: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        let report = GKScore(leaderboardIdentifier: board)
        report.value = .init(points)
        GKScore.report([report])
    }
    
    func match() {
        guard GKLocalPlayer.local.isAuthenticated else {
            gameCenterError()
            return
        }
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 3
        request.defaultNumberOfPlayers = 2
        
        guard let controller = GKMatchmakerViewController(matchRequest: request) else { return }
        controller.matchmakerDelegate = self
        
        GKDialogController.shared().parentWindow = windows.first
        GKDialogController.shared().present(controller)
    }
    
    func newGame(_ view: View) {
        windows.first!.show(view)
    }
    
    private func gameCenterError() {
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
