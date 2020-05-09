import AppKit

final class Score: NSView {
    required init?(coder: NSCoder) { nil }
    init(points: Int) {
        super.init(frame: .zero)
        
        let title = Label(.key("Score"), .bold(16))
        title.textColor = .headerColor
        addSubview(title)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let label = Label(formatter.string(from: .init(value: points))!, .bold(60))
        addSubview(label)
        
        let next = Button(.key("Continue"))
        next.target = self
        next.action = #selector(self.next)
        next.layer!.backgroundColor = .indigoLight
        next.label.textColor = .black
        addSubview(next)
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        next.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        next.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 150).isActive = true
        
        if profile.maxScore < points {
            profile.maxScore = points
            balam.update(profile)
            
            let max = Label(.key("New.max.score"), .bold(16))
            max.textColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .indigoLight : .indigoDark
            addSubview(max)
            
            label.textColor = max.textColor
            
            max.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            max.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        }
        
        (NSApp as! App).score(points)
    }
    
    @objc private func next() {
        window!.show(Options())
    }
}
