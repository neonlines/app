import GameKit

class MultiplayerView: View, GKMatchDelegate {
    private let match: GKMatch
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat, match: GKMatch) {
        self.match = match
        super.init(radius: radius)
        match.delegate = self
    }
    
    final func match(_: GKMatch, didReceive: Data, fromRemotePlayer: GKPlayer) {
        
    }
    
    override func update(_ delta: TimeInterval) {
        super.update(delta)
        if wheel != nil {
            if times.send.timeout(delta) {
                send()
            }
        }
    }
    
    override func gameOver(_ score: Int) {
        super.gameOver(score)
        match.disconnect()
        match.delegate = nil
    }
    
    private func send() {
        try? match.sendData(toAllPlayers: .init(), with: .unreliable)
    }
}
