import Foundation

struct Times {
    struct Item {
        private var current: TimeInterval
        private let max: TimeInterval
        
        init(_ max: TimeInterval) {
            self.max = max
            current = max
        }
        
        mutating func timeout(_ with: TimeInterval) -> Bool {
            current -= with
            guard current <= 0 else { return false }
            current = max
            return true
        }
    }
    
    var move = Item(0.05)
    var lines = Item(0.02)
    var foes = Item(0.02)
    var spawn = Item(0.05)
    var radar = Item(0.5)
    var seconds = Item(1)
    var send = Item(0.02)
    private var last = TimeInterval()
    
    mutating func delta(_ time: TimeInterval) -> TimeInterval {
        guard last > 0 else {
            last = time
            return 0
        }
        let delta = time - last
        last = time
        return delta
    }
}
