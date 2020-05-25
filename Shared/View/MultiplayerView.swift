import GameKit

final class MultiplayerView: View, GKMatchDelegate {
    private(set) weak var others: Others!
    private var playerId = 0
    private let match: GKMatch
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat, match: GKMatch) {
        self.match = match
        super.init(radius: radius)
        match.delegate = self
        
        let others = Others()
        scene!.camera!.addChild(others)
        self.others = others

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
    
    override func align() {
        super.align()
        others.align()
    }
    
    override func explode(_ player: Player) {
        others.explode(player.id)
        
        if players.filter({ $0.physicsBody != nil }).filter({ $0.id != playerId }).isEmpty {
            state = .victory
            
            let label = SKLabelNode(text: .key("Victory"))
            label.bold(25)
            label.alpha = 0
            label.fontColor = .black
            label.zPosition = 30
            scene!.camera!.addChild(label)
            scene!.camera!.run(.scale(to: 10, duration: 6))
            wheel.alpha = 0
            
            label.run(.fadeIn(withDuration: 3)) { [weak self] in
                self?.scene!.run(.fadeOut(withDuration: 2)) {
                    self?.match.disconnect()
                    self?.match.delegate = nil
                    self?.victory()
                }
            }
        }
    }
    
    override func gameOver() {
        match.disconnect()
        match.delegate = nil
        defeat()
    }
    
    override func rotate() {
        guard let player = self.player, player.zRotation != -wheel.zRotation else { return }
        let report = Report.move(playerId, rotation: -wheel.zRotation)
        try? match.sendData(toAllPlayers: JSONEncoder().encode(report), with: .reliable)
        super.rotate()
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
        let report = Report.profile(playerId, position: position, rotation: rotation, skin: game.profile.skin, name: GKLocalPlayer.local.displayName)
        startPlayer(position, rotation: rotation)
        player!.id = playerId
        try? match.sendData(toAllPlayers: JSONEncoder().encode(report), with: .reliable)
    }
}
