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
        title.font = .preferredFont(forTextStyle: .title2)
        title.textColor = traitCollection.userInterfaceStyle == .dark ? .indigoLight : .indigoDark
        view.addSubview(title)
        
        let newGame = Button(.key("New.game"))
        newGame.target = self
        newGame.action = #selector(self.newGame)
        newGame.label.textColor = .black
        newGame.base.backgroundColor = .indigoLight
        view.addSubview(newGame)
        
        let settings = Button(.key("Settings"))
        settings.target = self
        settings.action = #selector(self.settings)
        view.addSubview(settings)
        
        let store = Button(.key("Store"))
        store.target = self
        store.action = #selector(self.store)
        view.addSubview(store)
        
        let scores = Button(.key("Scores"))
        scores.target = self
        scores.action = #selector(self.scores)
        view.addSubview(scores)
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: title.topAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true

        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: newGame.topAnchor, constant: -80).isActive = true
        
        newGame.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newGame.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        settings.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settings.topAnchor.constraint(equalTo: newGame.bottomAnchor, constant: 10).isActive = true
        
        store.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        store.topAnchor.constraint(equalTo: settings.bottomAnchor, constant: 5).isActive = true
        
        scores.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scores.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 5).isActive = true
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
