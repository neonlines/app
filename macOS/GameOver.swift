import AppKit

class GameOver: NSView {
    final class Victory: GameOver {
        required init?(coder: NSCoder) { nil }
        override init(seconds: Int) {
            super.init(seconds: seconds)
            titleLabel.stringValue = .key("Victory")
            titleLabel.textColor = .indigoLight
            image.image = NSImage(named: "victory")!
            
            game.reportDuel()
        }
    }
    
    final class Defeat: GameOver {
        required init?(coder: NSCoder) { nil }
        override init(seconds: Int) {
            super.init(seconds: seconds)
            titleLabel.stringValue = .key("Defeat")
            titleLabel.textColor = .red
            image.image = NSImage(named: "defeat")!
        }
    }
    
    final class Over: GameOver {
        required init?(coder: NSCoder) { nil }
        init(seconds: Int, ai: Int) {
            super.init(seconds: seconds)
            titleLabel.stringValue = .key("Game.over")
            titleLabel.textColor = .indigoDark
            image.image = NSImage(named: "over")!
            
            let item = Item(title: .key("Ai.defeated"), counter: formatter.string(from: .init(value: ai))!, record: game.profile.aiPerMatch < ai)
            addSubview(item)
        
            item.centerXAnchor.constraint(equalTo: self.item.centerXAnchor).isActive = true
            item.topAnchor.constraint(equalTo: self.item.bottomAnchor).isActive = true
            
            game.report(ai: ai)
        }
    }
    
    private weak var titleLabel: Label!
    private weak var item: Item!
    private weak var image: NSImageView!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    private init(seconds: Int) {
        super.init(frame: .zero)
        formatter.numberStyle = .decimal
        
        let titleLabel = Label("", .bold(16))
        addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        self.image = image
        
        let skin = NSImageView(image: NSImage(named: Skin.make(id: game.profile.skin).texture)!)
        skin.translatesAutoresizingMaskIntoConstraints = false
        skin.imageScaling = .scaleNone
        addSubview(skin)
        
        let dates = DateComponentsFormatter()
        dates.allowedUnits = [.minute, .second]
        dates.zeroFormattingBehavior = .pad
        
        let item = Item(title: .key("Duration"), counter: dates.string(from: .init(seconds))!, record: game.profile.seconds < seconds)
        addSubview(item)
        self.item = item
        
        let next = Button(.key("Continue"))
        next.indigo()
        next.target = self
        next.action = #selector(self.next)
        addSubview(next)
        
        titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -200).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        skin.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        skin.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        skin.widthAnchor.constraint(equalToConstant: 32).isActive = true
        skin.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        item.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        item.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        
        next.topAnchor.constraint(equalTo: centerYAnchor, constant: 200).isActive = true
        next.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        game.report(seconds: seconds)
    }
    
    @objc private func next() {
        window!.show(Options())
    }
}

private final class Item: NSView {
    required init?(coder: NSCoder) { nil }
    init(title: String, counter: String, record: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = Label(title, .bold(14))
        titleLabel.textColor = .init(white: 0.7, alpha: 1)
        addSubview(titleLabel)
        
        let counterLabel = Label(counter, .regular(12))
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
            let record = Label(.key("New.max"), .medium(12))
            record.textColor = .indigoDark
            addSubview(record)
            
            record.leftAnchor.constraint(equalTo: counterLabel.rightAnchor, constant: 5).isActive = true
            record.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
