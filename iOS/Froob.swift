import UIKit

final class Froob: UIViewController, Refreshable {
    private weak var timer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .medium(14)
        title.text = .key("You.have.a.limit")
        title.textColor = .init(white: 0.4, alpha: 1)
        title.textAlignment = .center
        title.numberOfLines = 0
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(title)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = .key("Your.next.game.is")
        subtitle.textAlignment = .center
        subtitle.font = .medium(14)
        subtitle.textColor = .indigoLight
        subtitle.numberOfLines = 0
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(subtitle)
        
        let timer = UILabel()
        timer.translatesAutoresizingMaskIntoConstraints = false
        timer.font = .init(descriptor: UIFont.bold(30).fontDescriptor.addingAttributes([.featureSettings: [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType, .typeIdentifier: kMonospacedNumbersSelector]]]), size: 0)
        timer.textColor = .indigoDark
        view.addSubview(timer)
        self.timer = timer
        
        let option = UILabel()
        option.translatesAutoresizingMaskIntoConstraints = false
        option.text = .key("Your.can.also")
        option.textAlignment = .center
        option.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        option.numberOfLines = 0
        option.font = .regular(14)
        option.textColor = .init(white: 0.3, alpha: 1)
        view.addSubview(option)
        
        let store = Button(.key("Go.store"))
        store.target = self
        store.action = #selector(self.store)
        store.indigo()
        view.addSubview(store)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.minimal()
        view.addSubview(done)
        
        title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 40).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -40).isActive = true
        
        subtitle.bottomAnchor.constraint(equalTo: timer.topAnchor, constant: -10).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitle.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 40).isActive = true
        subtitle.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -40).isActive = true
        
        timer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        timer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        option.bottomAnchor.constraint(equalTo: store.topAnchor, constant: -50).isActive = true
        option.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        option.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 40).isActive = true
        option.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -40).isActive = true
        
        store.bottomAnchor.constraint(equalTo: done.topAnchor, constant: -5).isActive = true
        store.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        done.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        done.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        update()
    }
    
    func refresh() {
        done()
    }
    
    private func update() {
        guard let time = game.timer else {
            done()
            return
        }
        timer.text = time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.update()
        }
    }
    
    @objc private func store() {
        present(Store(refreshable: self), animated: true)
    }
    
    @objc private func done() {
        navigationController?.show(Options())
    }
}
