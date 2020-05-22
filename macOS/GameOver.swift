import AppKit

final class GameOver: NSView {
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    init(victory: Bool, seconds: Int, ai: Int?) {
        super.init(frame: .zero)
        formatter.numberStyle = .decimal
        
        let title = Label(victory ? .key("Victory") : .key("Game.over"), .bold(40))
        title.textColor = .headerColor
        addSubview(title)
        
        let subtitle = Label(.key("Seconds"), .bold(16))
        addSubview(subtitle)
        
        let label = Label(formatter.string(from: .init(value: seconds))!, .bold(30))
        addSubview(label)
        
        let next = Button(.key("Continue"))
        next.indigo()
        next.target = self
        next.action = #selector(self.next)
        addSubview(next)
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -80).isActive = true
        
        subtitle.rightAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        
        label.leftAnchor.constraint(equalTo: centerXAnchor, constant: 50).isActive = true
        label.centerYAnchor.constraint(equalTo: subtitle.centerYAnchor).isActive = true
        
        next.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        next.topAnchor.constraint(equalTo: centerYAnchor, constant: 160).isActive = true
        
        if game.profile.seconds < seconds {
            max().topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        }
        
        if let ai = ai {
            let aiTitle = Label(.key("Ai.defeated"), .bold(16))
            addSubview(aiTitle)
            
            let aiLabel = Label(formatter.string(from: .init(value: ai))!, .bold(30))
            addSubview(aiLabel)
            
            aiTitle.rightAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
            aiTitle.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 70).isActive = true
            
            aiLabel.leftAnchor.constraint(equalTo: centerXAnchor, constant: 50).isActive = true
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
    
    private func max() -> Label {
        let max = Label(.key("New.max"), .bold(18))
        max.textColor = .indigo
        addSubview(max)
        
        max.leftAnchor.constraint(equalTo: centerXAnchor, constant: 50).isActive = true
        return max
    }
    
    @objc private func next() {
        window!.show(Options())
    }
}
