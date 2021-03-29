import UIKit

class RGBClockView: UIView {
    
     private var currentTime: Date {
        return Date()
    }
    var timer: Timer?
    let calendar = Calendar.current
    
    private let hourHandView: RGBHandView = .init(type: .hour)
    private let minuteHandView: RGBHandView = .init(type: .minute)
    private let secondHandView: RGBHandView = .init(type: .second)
    private let formatter: DateFormatter
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    init() {
        formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        super.init(frame: .zero)
        
        backgroundColor = .init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        
        addSubview(hourHandView)
        hourHandView.layer.compositingFilter = "lightenBlendMode"
        hourHandView.translatesAutoresizingMaskIntoConstraints = false
        hourHandView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        hourHandView.heightAnchor.constraint(equalTo: hourHandView.widthAnchor, multiplier: 0.5).isActive = true
        hourHandView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        hourHandView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        hourHandView.layer.anchorPoint = .init(x: 0.5, y: 1)
        
        addSubview(minuteHandView)
        minuteHandView.layer.compositingFilter = "lightenBlendMode"
        minuteHandView.translatesAutoresizingMaskIntoConstraints = false
        minuteHandView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        minuteHandView.heightAnchor.constraint(equalTo: minuteHandView.widthAnchor, multiplier: 0.5).isActive = true
        minuteHandView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        minuteHandView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        minuteHandView.layer.anchorPoint = .init(x: 0.5, y: 1)
        
        addSubview(secondHandView)
        secondHandView.translatesAutoresizingMaskIntoConstraints = false
        secondHandView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        secondHandView.heightAnchor.constraint(equalTo: secondHandView.widthAnchor, multiplier: 0.5).isActive = true
        secondHandView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        secondHandView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        secondHandView.layer.anchorPoint = .init(x: 0.5, y: 1)
        
        layer.cornerRadius = bounds.width / 2
        
        bringSubviewToFront(secondHandView)
        bringSubviewToFront(minuteHandView)
        bringSubviewToFront(hourHandView)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClockHands), userInfo: nil, repeats: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func updateClockHands() {
        let hour = calendar.component(.hour, from: currentTime)
        let minute = calendar.component(.minute, from: currentTime)
        hourHandView.transform = CGAffineTransform(rotationAngle: (CGFloat(hour) * 60 + CGFloat(minute)) * 0.5 * CGFloat.pi / 180)
        minuteHandView.transform = CGAffineTransform(rotationAngle: CGFloat(minute) * 6 * CGFloat.pi / 180)
    }
    
    private func resetClockHands() {
        updateClockHands()
        let second = calendar.component(.second, from: currentTime)
        secondHandView.transform = CGAffineTransform(rotationAngle: CGFloat(second) * 6 * CGFloat.pi / 180)
    }
    
    func start() {
        resetClockHands()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let from = atan2(secondHandView.transform.b, secondHandView.transform.a)
        rotateAnimation.toValue = CGFloat(CGFloat.pi * 2.0 + from)
        rotateAnimation.duration = 60
        rotateAnimation.repeatCount = .infinity
        secondHandView.layer.add(rotateAnimation, forKey: "secondHandAnimation")
    }
    
    class RGBHandView: UIView {
        
        enum `Type` {
            case hour
            case minute
            case second
            
            var color: UIColor {
                switch self {
                case .hour: return .init(red: 251/255, green: 1/255, blue: 1/255, alpha: 1)
                case .minute: return .init(red: 48/255, green: 255/255, blue: 0, alpha: 1)
                case .second: return .init(red: 8/255, green: 0, blue: 254/255, alpha: 1)
                }
            }
        }
        
        init(type: Type) {
            super.init(frame: .zero)
            
            let handView = UIView()
            handView.backgroundColor = type.color
            addSubview(handView)
            handView.translatesAutoresizingMaskIntoConstraints = false
            handView.widthAnchor.constraint(equalToConstant: 5).isActive = true
            handView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            handView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
            handView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            handView.layer.cornerRadius = 2.5
            handView.layer.shadowColor = UIColor.white.cgColor
            handView.layer.shadowOffset = .init(width: 0, height: -1)
            handView.layer.shadowOpacity = 0.5
        }
        
        required init?(coder: NSCoder) { fatalError() }
    }
}
