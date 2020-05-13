import UIKit

final class Froob: UIViewController {
    private weak var timer: UILabel!
    private let formatter = DateComponentsFormatter()
    private let expected = Calendar.current.date(byAdding: .hour, value: 12, to: profile.lastGame)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.allowedUnits = [.hour, .minute, .second]
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .preferredFont(forTextStyle: .headline)
        title.text = .key("You.have.a.limit")
        title.textAlignment = .center
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(title)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = .key("Your.next.game.is")
        subtitle.textAlignment = .center
        subtitle.textColor = .secondaryLabel
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(subtitle)
        
        let timer = UILabel()
        timer.translatesAutoresizingMaskIntoConstraints = false
        timer.font = .preferredFont(forTextStyle: .title1)
        timer.textAlignment = .center
        view.addSubview(timer)
        self.timer = timer
        
        let option = UILabel()
        option.translatesAutoresizingMaskIntoConstraints = false
        option.text = .key("Your.can.also")
        option.textAlignment = .center
        option.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(option)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.label.textColor = .black
        done.base.backgroundColor = .indigoLight
        view.addSubview(done)
        
        let store = Button(.key("Go.store"))
        store.target = self
        store.action = #selector(self.store)
        store.label.textColor = .white
        store.base.backgroundColor = .indigoDark
        view.addSubview(store)
        
        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -5).isActive = true
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 40).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -40).isActive = true
        
        subtitle.bottomAnchor.constraint(equalTo: timer.topAnchor, constant: -30).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitle.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 40).isActive = true
        subtitle.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -40).isActive = true
        
        timer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        timer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        option.topAnchor.constraint(equalTo: timer.bottomAnchor, constant: 50).isActive = true
        option.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        option.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 40).isActive = true
        option.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -40).isActive = true
        
        done.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 20).isActive = true
        done.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        store.topAnchor.constraint(equalTo: option.bottomAnchor, constant: 30).isActive = true
        store.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        update()
    }
    
    private func update() {
        let now = Date()
        if now > expected {
            done()
        } else {
            timer.text = formatter.string(from: now, to: expected) ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.update()
            }
        }
    }
    
    @objc private func store() {
        present(Store(), animated: true)
    }
    
    @objc private func done() {
        navigationController?.show(Options())
    }
}
