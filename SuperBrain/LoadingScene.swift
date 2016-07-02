import SpriteKit

class LoadingScene: SKScene {
    
    let label = SKLabelNode(fontNamed:"Chalkduster")
    
    override func didMoveToView(view: SKView) {
        self.label.text = "正在加载..."
        self.label.fontSize = 20
        self.label.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(label)
    }
}
