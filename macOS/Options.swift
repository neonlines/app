import AppKit

final class Options: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let image = NSImageView(image: NSImage(named: "AppIcon")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let title = Label(.key("Neon.lines"), .bold(20))
        title.textColor = UI.darkMode ? .indigoLight : .indigoDark
        addSubview(title)
        
        let newGame = Button(.key("New.game"))
        newGame.target = self
        newGame.action = #selector(self.newGame)
        newGame.layer!.backgroundColor = .indigoLight
        newGame.label.textColor = .black
        addSubview(newGame)
        
        let settings = Button(.key("Settings"))
        settings.target = self
        settings.action = #selector(self.settings)
        addSubview(settings)
        
        let store = Button(.key("Store"))
        store.target = self
        store.action = #selector(self.store)
        addSubview(store)
        
        let scores = Button(.key("Scores"))
        scores.target = self
        scores.action = #selector(self.scores)
        addSubview(scores)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: title.topAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: newGame.topAnchor, constant: -50).isActive = true
        
        newGame.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        newGame.topAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        
        settings.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        settings.topAnchor.constraint(equalTo: newGame.bottomAnchor, constant: 15).isActive = true
        
        store.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        store.topAnchor.constraint(equalTo: settings.bottomAnchor, constant: 10).isActive = true
        
        scores.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scores.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc private func newGame() {
        guard profile.purchases.contains("neon.lines.premium.unlimited") else {
            if Date() > Calendar.current.date(byAdding: .hour, value: 12, to: profile.lastGame)! {
                window!.show(Prepare())
            } else {
                window!.show(Froob())
            }
            return
        }
        window!.show(Prepare())
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
