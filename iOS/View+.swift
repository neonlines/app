import GameKit

extension View {
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        super.touchesBegan(touches, with: with)
        guard let radian = touches.first!.radians else { return }
        start(radians: radian)
        (controller as? Controller)?.haptics.impactOccurred()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with: UIEvent?) {
        super.touchesMoved(touches, with: with)
        guard let radians = touches.first!.radians else {
            stop()
            return
        }
        update(radians: radians)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with: UIEvent?) {
        super.touchesEnded(touches, with: with)
        stop()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with: UIEvent?) {
        super.touchesCancelled(touches, with: with)
        stop()
    }
    
    func finish(_ score: Int) {
        controller?.navigationController?.show(Score(points: score))
    }
}

private extension UITouch {
    var radians: CGFloat? {
        {
            let point = CGPoint(x: $0.x - view!.frame.midX, y: (view!.frame.maxY - 140) - $0.y)
            guard point.valid else { return nil }
            return point.radians
        } (location(in: view!))
    }
}
