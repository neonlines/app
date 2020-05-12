import CoreGraphics

extension CGPoint {
    var valid: Bool {
        let distance = pow(x, 2) + pow(y, 2)
        return distance > 50 && distance < 19_600
    }
    
    var radians: CGFloat {
        atan2(x, y)
    }
}
