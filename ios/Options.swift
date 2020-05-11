import UIKit

final class Options: UIView {
    private var active = true
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let image = UIImageView(image: UIImage(named: "logo")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .key("Neon.lines")
        title.font = .preferredFont(forTextStyle: .largeTitle)
        title.textColor = traitCollection.userInterfaceStyle == .dark ? .indigoLight : .indigoDark
        addSubview(title)
        
        let newGame = Button(.key("New.game"))
        newGame.target = self
        newGame.action = #selector(self.newGame)
        newGame.label.textColor = .black
        newGame.base.backgroundColor = .indigoLight
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
    
    private func startGame() {
        profile.lastGame = .init()
        balam.update(profile)
//        window!.show(View(radius: 2_500))
    }

    @objc private func newGame() {
        guard profile.purchases.contains("neon.lines.premium.unlimited") else {
            if Date() > Calendar.current.date(byAdding: .hour, value: 12, to: profile.lastGame)! {
                startGame()
            } else {
//                window!.show(Froob())
            }
            return
        }
        startGame()
    }

    @objc private func settings() {
//        window!.show(Settings())
    }

    @objc private func store() {
//        window!.show(Store())
    }

    @objc private func scores() {
        (UIApplication.shared.delegate as! Window).leaderboards()
    }
}
