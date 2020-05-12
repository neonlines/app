import UIKit

final class Button: Control {
    private(set) weak var label: UILabel!
    private(set) weak var base: UIView!
    
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.isUserInteractionEnabled = false
        base.layer.cornerRadius = 6
        addSubview(base)
        self.base = base
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .preferredFont(forTextStyle: .headline)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        self.label = label
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 18).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 25).isActive = true
        
        base.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -18).isActive = true
        base.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 18).isActive = true
        base.topAnchor.constraint(equalTo: label.topAnchor, constant: -6).isActive = true
        base.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 18).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
    }
}
