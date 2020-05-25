import CoreGraphics

extension CGPoint {
    var valid: Bool {
        let distance = pow(x, 2) + pow(y, 2)
        return distance > 100 && distance < 20_000
    }
    
    var radians: CGFloat {
        atan2(x, y)
    }
}
