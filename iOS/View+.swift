import GameKit

extension View {
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        super.touchesBegan(touches, with: with)
        guard state == .play, let radian = touches.first!.radians else { return }
        beginMove(radian)
        (controller as? Controller)?.haptics.impactOccurred()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with: UIEvent?) {
        super.touchesMoved(touches, with: with)
        guard state == .play, let radians = touches.first!.radians else {
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
    
    func victory() {
        vibrate()
        controller?.navigationController?.show(GameOver.Victory(seconds: seconds))
    }
    
    func defeat() {
        vibrate()
        controller?.navigationController?.show(GameOver.Defeat(seconds: seconds))
    }
    
    func gameOver(_ ai: Int) {
        vibrate()
        controller?.navigationController?.show(GameOver.Over(seconds: seconds, ai: ai))
    }
    
    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
