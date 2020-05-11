import UIKit

final class Launch: UIViewController {
    private weak var press: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let press = UILabel()
        press.translatesAutoresizingMaskIntoConstraints = false
        press.font = .preferredFont(forTextStyle: .headline)
        press.text = .key("Press.to.start")
        press.alpha = 0
        view.addSubview(press)
        self.press = press
        
        let control = Control()
        control.target = self
        control.action = #selector(menu)
        view.addSubview(control)
        
        press.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        press.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        control.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        control.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        control.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        control.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    @objc private func menu() {
        navigationController?.show(Options())
    }
}
