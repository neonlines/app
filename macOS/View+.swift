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
        guard state == .play, let radians = with.radians else { return }
        beginMove(radians)
        NSCursor.pointingHand.set()
    }
    
    override func mouseDragged(with: NSEvent) {
        guard state == .play, let radians = with.radians else {
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
    
    func victory() {
//        window!.show(GameOver(victory: true, seconds: seconds, ai: nil))
    }
    
    func gameOver(_ ai: Int?) {
//        window!.show(GameOver(victory: false, seconds: seconds, ai: ai))
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
