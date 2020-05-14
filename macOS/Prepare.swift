import AppKit

final class Prepare: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        
        let title = Label(.key("Choose.your.enemy"), .bold(16))
        addSubview(title)
        
        let ai = Button(.key("Ai"))
        ai.target = self
        ai.action = #selector(self.ai)
        ai.layer!.backgroundColor = .indigoLight
        ai.label.textColor = .black
        addSubview(ai)
        
        let multiplayer = Button(.key("Multiplayer.game"))
        multiplayer.target = self
        multiplayer.action = #selector(self.multiplayer)
        multiplayer.layer!.backgroundColor = .indigoLight
        multiplayer.label.textColor = .black
        addSubview(multiplayer)
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: ai.topAnchor, constant: -40).isActive = true
        
        ai.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ai.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        multiplayer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        multiplayer.topAnchor.constraint(equalTo: ai.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc private func ai() {
        profile.lastGame = .init()
        window!.show(Game(radius: 2_500, match: nil))
    }
    
    @objc private func multiplayer() {
        (NSApp as! App).match()
    }
}
