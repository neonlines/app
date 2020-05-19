#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif
import GameKit

protocol GameDelegate: AnyObject {
    func dismissGameCenter()
    func newGame(_ view: View)
    func show(_ controller: GKViewController)
    func gameCenterError()

#if os(macOS)
    func auth(_ controller: NSViewController)
#endif
#if os(iOS)
    func auth(_ controller: UIViewController)
#endif
}
