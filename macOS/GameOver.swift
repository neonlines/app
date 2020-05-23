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
        
        let item = Item(title: .key("Duration"), counter: formatter.string(from: .init(value: seconds))!, record: true)
        addSubview(item)
        self.item = item
        
        title.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -200).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        item.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        item.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        
        next.topAnchor.constraint(equalTo: centerYAnchor, constant: 200).isActive = true
        next.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        
//        let subtitle = Label(.key("Seconds"), .bold(16))
//        addSubview(subtitle)
//
//        let label = Label(formatter.string(from: .init(value: seconds))!, .bold(30))
//        addSubview(label)
//
        
//
//        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -80).isActive = true
//
//        subtitle.rightAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
//        subtitle.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
//
//        label.leftAnchor.constraint(equalTo: centerXAnchor, constant: 50).isActive = true
//        label.centerYAnchor.constraint(equalTo: subtitle.centerYAnchor).isActive = true
//
//        next.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        next.topAnchor.constraint(equalTo: centerYAnchor, constant: 160).isActive = true
//
//        if game.profile.seconds < seconds {
//            max().topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
//        }
//
//        if let ai = ai {
//            let aiTitle = Label(.key("Ai.defeated"), .bold(16))
//            addSubview(aiTitle)
//
//            let aiLabel = Label(formatter.string(from: .init(value: ai))!, .bold(30))
//            addSubview(aiLabel)
//
//            aiTitle.rightAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
//            aiTitle.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 70).isActive = true
//
//            aiLabel.leftAnchor.constraint(equalTo: centerXAnchor, constant: 50).isActive = true
//            aiLabel.centerYAnchor.constraint(equalTo: aiTitle.centerYAnchor).isActive = true
//
//            if game.profile.ai < ai {
//                max().topAnchor.constraint(equalTo: aiLabel.bottomAnchor, constant: 5).isActive = true
//            }
//
////            game.report(ai: ai)
//        } else {
//            if victory {
////                game.reportDuel()
//            }
//        }
////        game.report(seconds: seconds)
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
