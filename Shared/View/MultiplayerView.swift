import GameKit

final class MultiplayerView: View, GKMatchDelegate {
    private var playerId = 0
    private let match: GKMatch
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat, match: GKMatch) {
        self.match = match
        super.init(radius: radius)
        match.delegate = self

        if !match.players.filter({ $0.displayName > GKLocalPlayer.local.displayName }).isEmpty {
            master()
        }
    }
    
    func match(_: GKMatch, didReceive: Data, fromRemotePlayer: GKPlayer) {
        guard let report = try? JSONDecoder().decode(Report.self, from: didReceive) else { return }
        switch report.mode {
        case .position:
            playerId = report.player
            start(report.position)
        case .profile:
            spawn(report.position, rotation: report.rotation, skin: report.skin).id = report.player
            others.player(report.player, skin: report.skin, name: report.name)
        case .move:
            players.first { $0.id == report.player }.map {
                $0.zRotation = report.rotation
            }
        }
    }
    
    override func update(_ delta: TimeInterval) {
        super.update(delta)
        switch state {
        case .play:
            if times.send.timeout(delta) {
                guard let player = wheel.player else { return }
                let report = Report.move(playerId, rotation: player.zRotation)
                try? match.sendData(toAllPlayers: JSONEncoder().encode(report), with: .reliable)
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
        let report = Report.profile(playerId, position: position, rotation: rotation, skin: profile.skin, name: GKLocalPlayer.local.displayName)
        startPlayer(position, rotation: rotation)
        try? match.sendData(toAllPlayers: JSONEncoder().encode(report), with: .reliable)
    }
}
