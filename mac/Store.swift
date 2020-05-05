import AppKit

final class Store: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let restore = Button(.key("Restore"))
        restore.target = self
        restore.action = #selector(self.done)
        addSubview(restore)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.label.textColor = .black
        done.layer!.backgroundColor = .indigoLight
        addSubview(done)
        
        let separator = Separator()
        addSubview(separator)
        
        let scroll = Scroll()
        addSubview(scroll)
        
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor, constant: 54).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        restore.rightAnchor.constraint(equalTo: done.leftAnchor, constant: -40).isActive = true
        restore.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -10).isActive = true
        
        done.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        done.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -10).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
    }
    
    @objc private func done() {
        window!.show(Menu())
    }
}
