import UIKit

final class Prepare: UINavigationController {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(rootViewController: UIViewController())
        viewControllers.first!.view.backgroundColor = .systemBackground
        viewControllers.first!.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        viewControllers.first!.navigationItem.title = .key("New.game")
        
        let ai = Button(.key("Ai"))
        ai.target = self
        ai.action = #selector(self.ai)
        ai.base.backgroundColor = .indigo
        ai.label.textColor = .black
        viewControllers.first!.view.addSubview(ai)
        
        let multiplayer = Button(.key("Multiplayer.game"))
        multiplayer.target = self
        multiplayer.action = #selector(self.multiplayer)
        multiplayer.base.backgroundColor = .indigo
        multiplayer.label.textColor = .black
        viewControllers.first!.view.addSubview(multiplayer)
        
        ai.centerXAnchor.constraint(equalTo: viewControllers.first!.view.centerXAnchor).isActive = true
        ai.bottomAnchor.constraint(equalTo: viewControllers.first!.view.centerYAnchor).isActive = true
        
        multiplayer.centerXAnchor.constraint(equalTo: viewControllers.first!.view.centerXAnchor).isActive = true
        multiplayer.topAnchor.constraint(equalTo: ai.bottomAnchor, constant: 5).isActive = true
    }
    
    @objc private func ai() {
        dismiss(animated: true) {
            (UIApplication.shared.delegate as! Window).newGame(AiView(radius: 2_500))
        }
    }
    
    @objc private func multiplayer() {
        dismiss(animated: true) {
            (UIApplication.shared.delegate as! Window).match()
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
