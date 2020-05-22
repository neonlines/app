import Foundation

protocol StoreDelegate: AnyObject {
    func refresh()
    func error(_ error: String)
}
