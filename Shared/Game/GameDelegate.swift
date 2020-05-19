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
    func gameCenterError()

#if os(macOS)
    func auth(_ controller: NSViewController)
    func show(_ controller: GKViewController & NSViewController)
#endif
#if os(iOS)
    func auth(_ controller: UIViewController)
    func show(_ controller: UINavigationController)
#endif
}
