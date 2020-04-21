import GameplayKit

extension SKScene {
    class Scene: SKScene {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(size: .zero)
            anchorPoint = .init(x: 0.5, y: 0.5)
            scaleMode = .resizeFill
            backgroundColor = .windowBackgroundColor
        }
    }
    
    final class Start: Scene {
        override func didMove(to: SKView) {
            let press = SKLabelNode(attributedText: .init(string: .key("Press.start"),
                                                          attributes: [.font: NSFont.systemFont(ofSize: 18, weight: .bold),
                                                                       .foregroundColor: NSColor.labelColor]))
            press.alpha = 0
            press.verticalAlignmentMode = .center
            addChild(press)
            press.run(.repeatForever(.sequence([.fadeIn(withDuration: 0.5), .wait(forDuration: 1), .fadeOut(withDuration: 0.5)])))
        }
    }
        
    final class Play: Scene {
        private weak var player: GKEntity.Node!
        private var entities = Set<GKEntity>()
        
        override func didMove(to: SKView) {
            let player = GKEntity.Node()
            entities.insert(player)
            self.player = player
            
            let wheel = GKEntity.Wheel()
            entities.insert(wheel)
            
            let camera = SKCameraNode()
            camera.constraints = [.orient(to: player.component(ofType: GKComponent.Sprite.self)!.sprite, offset: .init(constantValue: .pi / -2)),
                                  .distance(.init(upperLimit: 150), to: player.component(ofType: GKComponent.Sprite.self)!.sprite)]
            camera.addChild(wheel.component(ofType: GKComponent.Sprite.self)!.sprite)
            addChild(camera)
            addChild(player.component(ofType: GKComponent.Sprite.self)!.sprite)
            self.camera = camera
        }
        
        override func update(_ delta: TimeInterval) {
            entities.forEach { $0.update(deltaTime: delta) }
        }
        
        func path(_ position: CGPoint) {
            let path = GKEntity.Path(position)
            entities.insert(path)
            addChild(path.component(ofType: GKComponent.Sprite.self)!.sprite)
        }
        
        func remove(_ path: GKEntity.Path) {
            entities.remove(path)
            path.component(ofType: GKComponent.Sprite.self)!.sprite.removeFromParent()
        }
        
        func rotate(_ radians: CGFloat) {
            player.component(ofType: GKComponent.Wheel.self)!.rotate(radians)
        }
    }
}
