import AppKit
import Balam
import Combine
import GameKit

let balam = Balam("lines")
var profile = Profile()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
//        mainMenu = Menu()
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
        GKLocalPlayer.local.authenticateHandler = { [weak self] controller, error in
            guard let controller = controller else { return }
            self?.runModal(for: .init(contentViewController: controller))
        }
    }
}
