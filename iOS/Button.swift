import UIKit

final class Button: Control {
    private weak var label: UILabel!
    
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        self.label = label
        
    }
    
    func indigo() {
        large(.indigoDark)
    }
    
    func red() {
        large(.init(red: 0.9, green: 0, blue: 0, alpha: 1))
    }
    
    func minimal() {
        label.textColor = .init(white: 0.5, alpha: 1)
        label.font = .bold(12)
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 20).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    }
    
    func small() {
        label.textColor = .white
        label.font = .bold(12)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.isUserInteractionEnabled = false
        base.layer.cornerRadius = 6
        base.backgroundColor = .indigoDark
        addSubview(base)
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 22).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 22).isActive = true
        
        base.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        base.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    func clean() {
        label.textColor = .indigoDark
        label.font = .bold(12)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.isUserInteractionEnabled = false
        base.layer.cornerRadius = 6
        base.backgroundColor = .init(white: 0.9, alpha: 1)
        addSubview(base)
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 17).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 26).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 17).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 26).isActive = true
        
        base.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        base.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    private func large(_ color: UIColor) {
        label.textColor = .white
        label.font = .bold(14)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.isUserInteractionEnabled = false
        base.layer.cornerRadius = 10
        base.backgroundColor = color
        addSubview(base)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        base.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        base.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
    }
}
