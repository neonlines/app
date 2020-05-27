import UIKit

final class Options: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImageView(image: UIImage(named: "logo")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        view.addSubview(image)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .key("Neon.lines")
        title.font = .preferredFont(forTextStyle: .headline)
        view.addSubview(title)
        
        let newGame = UILabel()
        newGame.translatesAutoresizingMaskIntoConstraints = false
        newGame.text = .key("New.game")
        newGame.font = .preferredFont(forTextStyle: .subheadline)
        newGame.textColor = .secondaryLabel
        view.addSubview(newGame)
        
        let againstAi = Button(.key("Against.ai"))
        againstAi.target = self
        againstAi.action = #selector(ai)
        againstAi.label.textColor = .black
        view.addSubview(againstAi)
        
        let againstOthers = Button(.key("Against.others"))
        againstOthers.target = self
        againstOthers.action = #selector(multiplayer)
        againstOthers.label.textColor = .black
        view.addSubview(againstOthers)
        
        let settings = Button(.key("Settings"))
        settings.target = self
        settings.action = #selector(self.settings)
        settings.base.layer.borderWidth = 1
        settings.base.layer.borderColor = UIColor.label.cgColor
        view.addSubview(settings)
        
        let store = Button(.key("Store"))
        store.target = self
        store.action = #selector(self.store)
        store.base.layer.borderWidth = 1
        store.base.layer.borderColor = UIColor.label.cgColor
        view.addSubview(store)
        
        let scores = Button(.key("Scores"))
        scores.target = self
        scores.action = #selector(self.scores)
        scores.base.layer.borderWidth = 1
        scores.base.layer.borderColor = UIColor.label.cgColor
        view.addSubview(scores)
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: title.topAnchor, constant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 120).isActive = true
        image.heightAnchor.constraint(equalToConstant: 120).isActive = true

        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: newGame.topAnchor, constant: -80).isActive = true
        
        newGame.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newGame.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        
        againstAi.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        againstAi.topAnchor.constraint(equalTo: newGame.bottomAnchor, constant: 15).isActive = true
        
        againstOthers.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        againstOthers.topAnchor.constraint(equalTo: againstAi.bottomAnchor, constant: 5).isActive = true
        
        settings.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settings.topAnchor.constraint(equalTo: againstOthers.bottomAnchor, constant: 50).isActive = true
        
        store.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        store.topAnchor.constraint(equalTo: settings.bottomAnchor, constant: 5).isActive = true
        
        scores.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scores.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 5).isActive = true
    }
    
    private var playable: Bool {
        game.profile.purchases.contains("neon.lines.premium.unlimited") || Date() > Calendar.current.date(byAdding: .hour, value: 12, to: game.profile.lastGame)!
    }
    
    @objc private func ai() {
        guard playable else {
            navigationController?.show(Froob())
            return
        }
        navigationController!.newGame(AiView(radius: 3_000))
    }
    
    @objc private func multiplayer() {
        guard playable else {
            navigationController?.show(Froob())
            return
        }
        game.match()
    }

    @objc private func settings() {
        present(Settings(), animated: true)
    }

    @objc private func store() {
        present(Store(), animated: true)
    }

    @objc private func scores() {
        game.leaderboards()
    }
}
