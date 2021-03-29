import UIKit

class ViewController: UIViewController {
    private let clockView: RGBClockView = .init()
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(clockView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        clockView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        clockView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        clockView.heightAnchor.constraint(equalTo: clockView.widthAnchor).isActive = true
        clockView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        gradientLayer.colors = [
            UIColor(red:252/255, green:252/255, blue:252/255, alpha:1).cgColor,
            UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        ]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        clockView.start()
    }
}
