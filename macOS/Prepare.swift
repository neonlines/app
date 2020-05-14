import AppKit

final class Prepare: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let title = Label(.key("New.game"), .bold(16))
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
        
        let cancel = Button(.key("Cancel"))
        cancel.target = self
        cancel.action = #selector(self.cancel)
        addSubview(cancel)
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: ai.topAnchor, constant: -100).isActive = true
        
        ai.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ai.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        multiplayer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        multiplayer.topAnchor.constraint(equalTo: ai.bottomAnchor, constant: 20).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: multiplayer.bottomAnchor, constant: 25).isActive = true
    }
    
    @objc private func ai() {
        (NSApp as! App).newGame(nil)
    }
    
    @objc private func multiplayer() {
        (NSApp as! App).match()
    }
    
    @objc private func cancel() {
        window!.show(Options())
    }
}
