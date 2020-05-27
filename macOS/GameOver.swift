import AppKit

class GameOver: NSView {
    final class Victory: GameOver {
        required init?(coder: NSCoder) { nil }
        override init(seconds: Int) {
            super.init(seconds: seconds)
            title.stringValue = .key("Victory")
            title.textColor = .indigoLight
            
            let image = NSImageView(image: NSImage(named: "victory")!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.imageScaling = .scaleNone
            addSubview(image)
            
            let skin = NSImageView(image: NSImage(named: Skin.make(id: game.profile.skin).texture)!)
            skin.translatesAutoresizingMaskIntoConstraints = false
            skin.imageScaling = .scaleNone
            addSubview(skin)
            
            image.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            image.widthAnchor.constraint(equalToConstant: 150).isActive = true
            image.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            skin.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
            skin.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
            skin.widthAnchor.constraint(equalToConstant: 32).isActive = true
            skin.heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            game.reportDuel()
        }
    }
    
    final class Defeat: GameOver {
        required init?(coder: NSCoder) { nil }
        override init(seconds: Int) {
            super.init(seconds: seconds)
            title.stringValue = .key("Defeat")
            title.textColor = .red
            
            let image = NSImageView(image: NSImage(named: "defeat")!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.imageScaling = .scaleNone
            addSubview(image)
            
            let skin = NSImageView(image: NSImage(named: Skin.make(id: game.profile.skin).texture)!)
            skin.translatesAutoresizingMaskIntoConstraints = false
            skin.imageScaling = .scaleNone
            addSubview(skin)
            
            image.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            image.widthAnchor.constraint(equalToConstant: 150).isActive = true
            image.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            skin.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
            skin.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
            skin.widthAnchor.constraint(equalToConstant: 32).isActive = true
            skin.heightAnchor.constraint(equalToConstant: 32).isActive = true
        }
    }
    
    final class Over: GameOver {
        required init?(coder: NSCoder) { nil }
        init(seconds: Int, ai: Int) {
            super.init(seconds: seconds)
            title.stringValue = .key("Game.over")
            title.textColor = .indigoDark
            
            let image = NSImageView(image: NSImage(named: "over")!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.imageScaling = .scaleNone
            addSubview(image)
            
            let skin = NSImageView(image: NSImage(named: Skin.make(id: game.profile.skin).texture)!)
            skin.translatesAutoresizingMaskIntoConstraints = false
            skin.imageScaling = .scaleNone
            addSubview(skin)
            
            let item = Item(title: .key("Ai.defeated"), counter: formatter.string(from: .init(value: ai))!, record: game.profile.ai < ai)
            addSubview(item)
            
            image.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            image.widthAnchor.constraint(equalToConstant: 150).isActive = true
            image.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            skin.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
            skin.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
            skin.widthAnchor.constraint(equalToConstant: 32).isActive = true
            skin.heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            item.centerXAnchor.constraint(equalTo: self.item.centerXAnchor).isActive = true
            item.topAnchor.constraint(equalTo: self.item.bottomAnchor).isActive = true
            
            game.report(ai: ai)
        }
    }
    
    private weak var title: Label!
    private weak var item: Item!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    private init(seconds: Int) {
        super.init(frame: .zero)
        formatter.numberStyle = .decimal
        
        let title = Label("", .bold(16))
        addSubview(title)
        self.title = title
        
        let next = Button(.key("Continue"))
        next.indigo()
        next.target = self
        next.action = #selector(self.next)
        addSubview(next)
        
        let dates = DateComponentsFormatter()
        dates.allowedUnits = [.minute, .second]
        dates.zeroFormattingBehavior = .pad
        
        let item = Item(title: .key("Duration"), counter: dates.string(from: .init(seconds))!, record: game.profile.seconds < seconds)
        addSubview(item)
        self.item = item
        
        title.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -200).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
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
        
        let title = Label(title, .bold(14))
        title.textColor = .init(white: 0.7, alpha: 1)
        addSubview(title)
        
        let counter = Label(counter, .regular(12))
        counter.textColor = .black
        addSubview(counter)
        
        let separator = Separator()
        addSubview(separator)
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        counter.rightAnchor.constraint(equalTo: rightAnchor, constant: -60).isActive = true
        counter.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        separator.rightAnchor.constraint(equalTo: counter.rightAnchor, constant: -10).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        if record {
            let record = Label(.key("New.max"), .medium(12))
            record.textColor = .indigoDark
            addSubview(record)
            
            record.leftAnchor.constraint(equalTo: counter.rightAnchor, constant: 5).isActive = true
            record.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
}
