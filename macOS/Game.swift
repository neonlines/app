import AppKit

final class Game: View {
    override var mouseDownCanMoveWindow: Bool { true }
    
    override func viewDidMoveToWindow() {
        align()
    }
    
    override func viewDidEndLiveResize() {
        align()
    }
    
    override func mouseDown(with: NSEvent) {
        guard let wheel = self.wheel, let radians = with.radians else {
            drag = nil
            return
        }
        drag = radians
        rotation = wheel.zRotation
        wheel.on = true
        NSCursor.pointingHand.set()
    }
    
    override func mouseDragged(with: NSEvent) {
        guard let wheel = self.wheel, let radians = with.radians, let drag = self.drag else {
            self.drag = nil
            self.wheel?.on = false
            NSCursor.arrow.set()
            return
        }
        wheel.zRotation = rotation - (radians - drag)
        pointers.zRotation = -wheel.zRotation
    }
    
    override func mouseUp(with: NSEvent) {
        drag = nil
        wheel?.on = false
        NSCursor.arrow.set()
    }
}

private extension NSEvent {
    var radians: CGFloat? {
        {
            let point = CGPoint(x: $0.x - window!.contentView!.frame.midX, y: $0.y - 140)
            guard point.valid else { return nil }
            return point.radians
        } (window!.contentView!.convert(locationInWindow, from: nil))
    }
}
