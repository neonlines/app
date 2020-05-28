import UIKit

final class GameOver: UIViewController {
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    init(victory: Bool, seconds: Int, ai: Int?) {
        formatter.numberStyle = .decimal
        super.init(nibName: nil, bundle: nil)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .preferredFont(forTextStyle: .largeTitle)
        title.text = victory ? .key("Victory") : .key("Game.over")
        view.addSubview(title)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = .key("Seconds")
        view.addSubview(subtitle)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = formatter.string(from: .init(value: seconds))!
        view.addSubview(label)
        
        let next = Button(.key("Continue"))
        next.target = self
        next.action = #selector(done)
        view.addSubview(next)
        
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -80).isActive = true
        
        subtitle.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 30).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
        label.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 50).isActive = true
        label.centerYAnchor.constraint(equalTo: subtitle.centerYAnchor).isActive = true
        
        next.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        next.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 160).isActive = true
        
        if game.profile.seconds < seconds {
            max().topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        }
        
        if let ai = ai {
            let aiTitle = UILabel()
            aiTitle.translatesAutoresizingMaskIntoConstraints = false
            aiTitle.text = .key("Ai.defeated")
            view.addSubview(aiTitle)
            
            let aiLabel = UILabel()
            aiLabel.translatesAutoresizingMaskIntoConstraints = false
            aiLabel.text = formatter.string(from: .init(value: ai))!
            aiLabel.font = .preferredFont(forTextStyle: .largeTitle)
            view.addSubview(aiLabel)
            
            aiTitle.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 30).isActive = true
            aiTitle.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 70).isActive = true
            
            aiLabel.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 50).isActive = true
            aiLabel.centerYAnchor.constraint(equalTo: aiTitle.centerYAnchor).isActive = true
            
            if game.profile.ai < ai {
                max().topAnchor.constraint(equalTo: aiLabel.bottomAnchor, constant: 5).isActive = true
            }
            
            game.report(ai: ai)
        }
        
        game.report(seconds: seconds)
        
        if victory {
            game.reportDuel()
        }
    }
    
    private func max() -> UILabel {
        let max = UILabel()
        max.translatesAutoresizingMaskIntoConstraints = false
        max.font = .preferredFont(forTextStyle: .headline)
        max.text = .key("New.max")
        view.addSubview(max)
        
        max.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 50).isActive = true
        return max
    }
    
    @objc private func done() {
        navigationController?.show(Options())
    }
}
