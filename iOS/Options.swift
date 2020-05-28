import UIKit

final class Options: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImageView(image: UIImage(named: "logo")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        view.addSubview(image)
        
        let againstAi = Button(.key("Against.ai"))
        againstAi.indigo()
        againstAi.target = self
        againstAi.action = #selector(ai)
        view.addSubview(againstAi)
        
        let againstOthers = Button(.key("Against.others"))
        againstOthers.red()
        againstOthers.target = self
        againstOthers.action = #selector(multiplayer)
        view.addSubview(againstOthers)
        
        let settings = Button(.key("Settings"))
        settings.minimal()
        settings.target = self
        settings.action = #selector(self.settings)
        view.addSubview(settings)
        
        let store = Button(.key("Store"))
        store.minimal()
        store.target = self
        store.action = #selector(self.store)
        view.addSubview(store)
        
        let scores = Button(.key("Scores"))
        scores.minimal()
        scores.target = self
        scores.action = #selector(self.scores)
        view.addSubview(scores)
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 104).isActive = true
        image.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        againstAi.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        againstAi.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 100).isActive = true
        
        againstOthers.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        againstOthers.topAnchor.constraint(equalTo: againstAi.bottomAnchor, constant: 5).isActive = true
        
        scores.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scores.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        settings.rightAnchor.constraint(equalTo: scores.leftAnchor).isActive = true
        settings.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        store.leftAnchor.constraint(equalTo: scores.rightAnchor).isActive = true
        store.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc private func ai() {
        guard game.playable else {
            navigationController?.show(Froob())
            return
        }
        navigationController!.newGame(AiView(radius: 3_000))
    }
    
    @objc private func multiplayer() {
        guard game.playable else {
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
