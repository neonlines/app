import AppKit

extension View {
    override var mouseDownCanMoveWindow: Bool { true }
    
    override func viewDidMoveToWindow() {
        align()
    }
    
    override func viewDidEndLiveResize() {
        align()
    }
    
    override func mouseDown(with: NSEvent) {
        guard let radians = with.radians else { return }
        start(radians: radians)
        NSCursor.pointingHand.set()
    }
    
    override func mouseDragged(with: NSEvent) {
        guard let radians = with.radians else {
            stop()
            NSCursor.arrow.set()
            return
        }
        update(radians: radians)
    }
    
    override func mouseUp(with: NSEvent) {
        stop()
        NSCursor.arrow.set()
    }
    
    func finish(_ score: Int) {
        window!.show(Score(points: score))
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
