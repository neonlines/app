import AppKit

final class Options: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let image = NSImageView(image: NSImage(named: "logo")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let newGame = Label(.key("New.game"), .bold(14))
        newGame.textColor = .secondaryLabelColor
        addSubview(newGame)
        
        let againstAi = Button(.key("Against.ai"))
        againstAi.indigo()
        againstAi.target = self
        againstAi.action = #selector(ai)
        addSubview(againstAi)
        
        let againstOthers = Button(.key("Against.others"))
        againstOthers.indigo()
        againstOthers.target = self
        againstOthers.action = #selector(multiplayer)
        addSubview(againstOthers)
        
        let settings = Button(.key("Settings"))
        settings.minimal()
        settings.target = self
        settings.action = #selector(self.settings)
        addSubview(settings)
        
        let store = Button(.key("Store"))
        store.minimal()
        store.target = self
        store.action = #selector(self.store)
        addSubview(store)
        
        let scores = Button(.key("Scores"))
        scores.minimal()
        scores.target = self
        scores.action = #selector(self.scores)
        addSubview(scores)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: newGame.topAnchor, constant: -60).isActive = true
        image.widthAnchor.constraint(equalToConstant: 104).isActive = true
        image.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        newGame.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        newGame.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        
        againstAi.topAnchor.constraint(equalTo: newGame.bottomAnchor, constant: 20).isActive = true
        againstAi.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        againstOthers.topAnchor.constraint(equalTo: againstAi.bottomAnchor, constant: 20).isActive = true
        againstOthers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        settings.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        settings.topAnchor.constraint(equalTo: againstOthers.bottomAnchor, constant: 60).isActive = true
        
        store.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        store.topAnchor.constraint(equalTo: settings.bottomAnchor, constant: 20).isActive = true
        
        scores.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scores.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 20).isActive = true
    }
    
    private var playable: Bool {
        game.profile.purchases.contains("neon.lines.premium.unlimited") || Date() > Calendar.current.date(byAdding: .hour, value: 12, to: game.profile.lastGame)!
    }
    
    @objc private func ai() {
        guard playable else {
            window!.show(Froob())
            return
        }
        (NSApp as! App).newGame(AiView(radius: 3_000))
    }
    
    @objc private func multiplayer() {
        guard playable else {
            window!.show(Froob())
            return
        }
        game.match()
    }
    
    @objc private func settings() {
        window!.show(Settings())
    }
    
    @objc private func store() {
        window!.show(Store())
    }
    
    @objc private func scores() {
        game.leaderboards()
    }
}
