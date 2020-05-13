import UIKit

final class Score: UIViewController {
    required init?(coder: NSCoder) { nil }
    init(points: Int) {
        super.init(nibName: nil, bundle: nil)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .preferredFont(forTextStyle: .headline)
        title.text = .key("Score")
        view.addSubview(title)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = formatter.string(from: .init(value: points))!
        view.addSubview(label)
        
        let next = Button(.key("Continue"))
        next.target = self
        next.action = #selector(done)
        next.base.backgroundColor = .indigoLight
        next.label.textColor = .black
        view.addSubview(next)
        
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        next.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        next.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 150).isActive = true
        
        if profile.maxScore < points {
            profile.maxScore = points
            balam.update(profile)
            
            let max = UILabel()
            max.translatesAutoresizingMaskIntoConstraints = false
            max.text = .key("New.max.score")
            max.textColor = UI.darkMode ? .indigoLight : .indigoDark
            view.addSubview(max)
            
            label.textColor = max.textColor
            
            max.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            max.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        }
        
        (UIApplication.shared.delegate!.window as! Window).score(points)
    }
    
    @objc private func done() {
//        window!.show(Options())
    }
}
