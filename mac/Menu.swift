import AppKit

final class Menu: NSView {
    private var active = true
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
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
        
        newGame.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        newGame.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        settings.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        settings.topAnchor.constraint(equalTo: newGame.bottomAnchor, constant: 15).isActive = true
        
        store.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        store.topAnchor.constraint(equalTo: settings.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc private func newGame() {
        guard active else { return }
        active = false
        window!.show(View(radius: 2_500))
    }
    
    @objc private func settings() {
        guard active else { return }
        active = false
        window!.show(Settings())
    }
    
    @objc private func store() {
        guard active else { return }
        active = false
        window!.show(Store())
    }
}
