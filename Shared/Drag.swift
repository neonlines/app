import CoreGraphics

enum Drag {
    case
    no,
    start(x: CGFloat, y: CGFloat, origin: CGFloat),
    drag(origin: CGFloat)
}
