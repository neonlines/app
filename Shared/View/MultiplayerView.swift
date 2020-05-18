import GameKit

class MultiplayerView: View, GKMatchDelegate {
    private var playerId = 0
    private let match: GKMatch
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat, match: GKMatch) {
        self.match = match
        super.init(radius: radius)
        match.delegate = self
        others.load(match)

        if !match.players.filter({ $0.displayName > GKLocalPlayer.local.displayName }).isEmpty {
            master()
        }
    }
    
    final func match(_: GKMatch, didReceive: Data, fromRemotePlayer: GKPlayer) {
        guard let report = try? JSONDecoder().decode(Report.self, from: didReceive) else { return }
        switch report.mode {
        case .position:
            playerId = report.player
            start(report.position)
        case .profile:
            _ = spawn(report.position, rotation: report.rotation, skin: report.skin)
        case .move:
            break
        }
    }
    
    override func update(_ delta: TimeInterval) {
        super.update(delta)
        switch state {
        case .play:
            if times.send.timeout(delta) {
//                send()
            }
        default: break
        }
    }
    
    override func gameOver(_ score: Int) {
        super.gameOver(score)
        match.disconnect()
        match.delegate = nil
    }
    
    private func master() {
        var positions = [CGPoint]()
        match.players.forEach {
            let position = certainPosition(positions)
            let report = Report.position(positions.count, position: position)
            positions.append(position)
            try? match.send(JSONEncoder().encode(report), to: [$0], dataMode: .reliable)
        }
        playerId = positions.count
        start(certainPosition(positions))
    }
    
    private func start(_ position: CGPoint) {
        let rotation = randomRotation
        let report = Report.profile(playerId, position: position, rotation: rotation, skin: profile.skin)
        startPlayer(position, rotation: rotation)
        try? match.sendData(toAllPlayers: JSONEncoder().encode(report), with: .reliable)
    }
}
