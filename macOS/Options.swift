import AppKit

final class Options: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let image = NSImageView(image: NSImage(named: "logo")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let againstAi = Button(.key("Against.ai"))
        againstAi.indigo()
        againstAi.target = self
        againstAi.action = #selector(ai)
        addSubview(againstAi)
        
        let againstOthers = Button(.key("Against.others"))
        againstOthers.red()
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
        image.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -60).isActive = true
        image.widthAnchor.constraint(equalToConstant: 104).isActive = true
        image.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        againstAi.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 100).isActive = true
        againstAi.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        againstOthers.topAnchor.constraint(equalTo: againstAi.bottomAnchor, constant: 20).isActive = true
        againstOthers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        scores.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scores.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        settings.rightAnchor.constraint(equalTo: scores.leftAnchor, constant: -30).isActive = true
        settings.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        store.leftAnchor.constraint(equalTo: scores.rightAnchor, constant: 30).isActive = true
        store.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    @objc private func ai() {
        guard game.playable else {
            window!.show(Froob())
            return
        }
        (NSApp as! App).newGame(AiView(radius: 3_000))
    }
    
    @objc private func multiplayer() {
        guard game.playable else {
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
