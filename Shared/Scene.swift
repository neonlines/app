import GameplayKit

class Scene: SKScene {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init(size: .zero)
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
    }
    
    final class Start: Scene {
        override func didMove(to: SKView) {
            let press = SKLabelNode(attributedText: .init(string: .key("Press.start"),
                                                          attributes: [.font: NSFont.systemFont(ofSize: 18, weight: .bold),
                                                                       .foregroundColor: NSColor.white]))
            press.alpha = 0
            press.verticalAlignmentMode = .center
            addChild(press)
            press.run(.repeatForever(.sequence([.fadeIn(withDuration: 0.5), .wait(forDuration: 1), .fadeOut(withDuration: 0.5)])))
        }
    }
    
    final class Play: Scene {
        private var entities = Set<GKEntity>()
        
        override func didMove(to: SKView) {
            let player = Node()
            entities.insert(player)
            let camera = SKCameraNode()
            camera.constraints = [.distance(.init(upperLimit: 100), to: player.component(ofType: Sprite.self)!.sprite)]
            addChild(camera)
            self.camera = camera
            addChild(player.component(ofType: Sprite.self)!.sprite)
//            player.component(ofType: SpriteWalk.self)!.move(memory.game.location.position)
        }
    }
}
