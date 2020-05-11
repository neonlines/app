import UIKit

final class Launch: UIView {
    private weak var press: UILabel!

    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let press = UILabel()
        press.translatesAutoresizingMaskIntoConstraints = false
        press.font = .preferredFont(forTextStyle: .headline)
        press.text = .key("Press.to.start")
        press.alpha = 0
        addSubview(press)
        self.press = press
        
        press.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        press.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.press.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 2, animations: { [weak self] in
                self?.press.alpha = 0
            }) { [weak self] _ in
                self?.animate()
            }
        }
    }
    
    override func touchesEnded(_: Set<UITouch>, with: UIEvent?) {
        window!.show(Options())
        isUserInteractionEnabled = false
    }
}
