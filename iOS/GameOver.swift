import UIKit

class GameOver: UIViewController {
    final class Victory: GameOver {
        required init?(coder: NSCoder) { nil }
        override init(seconds: Int) {
            super.init(seconds: seconds)
            titleLabel.text = .key("Victory")
            titleLabel.textColor = .indigoLight
            image.image = UIImage(named: "victory")!
            
            game.reportDuel()
        }
    }
    
    final class Defeat: GameOver {
        required init?(coder: NSCoder) { nil }
        override init(seconds: Int) {
            super.init(seconds: seconds)
            titleLabel.text = .key("Defeat")
            titleLabel.textColor = .red
            image.image = UIImage(named: "defeat")!
        }
    }
    
    final class Over: GameOver {
        required init?(coder: NSCoder) { nil }
        init(seconds: Int, ai: Int) {
            super.init(seconds: seconds)
            titleLabel.text = .key("Game.over")
            titleLabel.textColor = .indigoDark
            image.image = UIImage(named: "over")!
            
            let item = Item(title: .key("Ai.defeated"), counter: formatter.string(from: .init(value: ai))!, record: game.profile.ai < ai)
            view.addSubview(item)
            
            item.centerXAnchor.constraint(equalTo: self.item.centerXAnchor).isActive = true
            item.topAnchor.constraint(equalTo: self.item.bottomAnchor).isActive = true
            
            game.report(ai: ai)
        }
    }
    
    private weak var titleLabel: UILabel!
    private weak var item: Item!
    private weak var image: UIImageView!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    init(seconds: Int) {
        super.init(nibName: nil, bundle: nil)
        formatter.numberStyle = .decimal
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .bold(16)
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        view.addSubview(image)
        self.image = image
        
        let skin = UIImageView(image: UIImage(named: Skin.make(id: game.profile.skin).texture)!)
        skin.translatesAutoresizingMaskIntoConstraints = false
        skin.contentMode = .center
        skin.clipsToBounds = true
        view.addSubview(skin)
        
        let dates = DateComponentsFormatter()
        dates.allowedUnits = [.minute, .second]
        dates.zeroFormattingBehavior = .pad
        
        let item = Item(title: .key("Duration"), counter: dates.string(from: .init(seconds))!, record: game.profile.seconds < seconds)
        view.addSubview(item)
        self.item = item
        
        let next = Button(.key("Continue"))
        next.indigo()
        next.target = self
        next.action = #selector(done)
        view.addSubview(next)
        
        titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        skin.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        skin.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        skin.widthAnchor.constraint(equalToConstant: 32).isActive = true
        skin.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        item.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30).isActive = true
        item.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        
        next.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        next.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        game.report(seconds: seconds)
    }
    
    @objc private func done() {
        navigationController?.show(Options())
    }
}

private final class Item: UIView {
    required init?(coder: NSCoder) { nil }
    init(title: String, counter: String, record: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .bold(14)
        titleLabel.textColor = .init(white: 0.7, alpha: 1)
        addSubview(titleLabel)
        
        let counterLabel = UILabel()
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.text = counter
        counterLabel.font = .regular(12)
        counterLabel.textColor = .black
        addSubview(counterLabel)
        
        let separator = Separator()
        addSubview(separator)
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        counterLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -60).isActive = true
        counterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        separator.rightAnchor.constraint(equalTo: counterLabel.rightAnchor, constant: -10).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        if record {
            let record = UILabel()
            record.translatesAutoresizingMaskIntoConstraints = false
            record.font = .medium(12)
            record.text = .key("New.max")
            record.textColor = .indigoDark
            addSubview(record)
            
            record.leftAnchor.constraint(equalTo: counterLabel.rightAnchor, constant: 5).isActive = true
            record.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
