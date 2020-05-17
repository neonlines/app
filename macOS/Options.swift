import AppKit

final class Options: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let image = NSImageView(image: NSImage(named: "logo")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let title = Label(.key("Neon.lines"), .bold(16))
        title.textColor = .indigo
        addSubview(title)
        
        let newGame = Label(.key("New.game"), .bold(14))
        newGame.textColor = .secondaryLabelColor
        addSubview(newGame)
        
        let againstAi = Button(.key("Against.ai"))
        againstAi.target = self
        againstAi.action = #selector(ai)
        againstAi.label.textColor = .black
        againstAi.layer!.backgroundColor = .indigo
        addSubview(againstAi)
        
        let againstOthers = Button(.key("Against.others"))
        againstOthers.target = self
        againstOthers.action = #selector(multiplayer)
        againstOthers.label.textColor = .black
        againstOthers.layer!.backgroundColor = .indigo
        againstOthers.isHidden = true
        addSubview(againstOthers)
        
        let settings = Button(.key("Settings"))
        settings.target = self
        settings.action = #selector(self.settings)
        settings.layer!.borderWidth = 1
        settings.layer!.borderColor = NSColor.labelColor.cgColor
        addSubview(settings)
        
        let store = Button(.key("Store"))
        store.target = self
        store.action = #selector(self.store)
        store.layer!.borderWidth = 1
        store.layer!.borderColor = NSColor.labelColor.cgColor
        addSubview(store)
        
        let scores = Button(.key("Scores"))
        scores.target = self
        scores.action = #selector(self.scores)
        scores.layer!.borderWidth = 1
        scores.layer!.borderColor = NSColor.labelColor.cgColor
        addSubview(scores)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: title.topAnchor, constant: 35).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: newGame.topAnchor, constant: -70).isActive = true
        
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
        profile.purchases.contains("neon.lines.premium.unlimited") || Date() > Calendar.current.date(byAdding: .hour, value: 12, to: profile.lastGame)!
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
        (NSApp as! App).match()
    }
    
    @objc private func settings() {
        window!.show(Settings())
    }
    
    @objc private func store() {
        window!.show(Store())
    }
    
    @objc private func scores() {
        (NSApp as! App).leaderboards()
    }
}
