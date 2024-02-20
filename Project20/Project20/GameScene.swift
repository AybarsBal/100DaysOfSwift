//
//  GameScene.swift
//  Project20
//
//  Created by Yakup Aybars Bal on 30.01.2024.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    var explodeButton: SKShapeNode!
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var launchCount = 0 {
        didSet {
            if launchCount == 5 {
                gameTimer?.invalidate()
                let gameOver = SKAction.run { self.gameOver() }
                let wait = SKAction.wait(forDuration: 6.5)
                let sequence = SKAction.sequence([wait, gameOver])
                scene?.run(sequence)
            }
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 36
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        explodeButton = SKShapeNode(circleOfRadius: 50)
        explodeButton.fillColor = .red
        explodeButton.position = CGPoint(x: 950, y: 100)
        explodeButton.name = "explode"
        explodeButton.fillTexture = SKTexture(imageNamed: "ballRed")
        addChild(explodeButton)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
        launchFireworks()
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .red
        case 1:
            firework.color = .cyan
        case 2:
            firework.color = .green
        default:
            break
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            emitter.name = "fuse"
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        launchCount += 1
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            for i in 0...4 {
               createFirework(xMovement: 0, x: 312 + (100 * i), y: bottomEdge)
            }
            
        case 1:
            // fire five, in a fan
            for i in 0...4 {
                createFirework(xMovement: CGFloat(-200 + (100 * i)), x: 312 + (100 * i), y: bottomEdge)
            }
            
        case 2:
            // fire five, from the left to the right
            for i in 0...4 {
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + (100 * i))
            }
            
        case 3:
            // fire five, from the right to the left
            for i in 0...4 {
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + (100 * i))
            }
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: firework)
                fireworks.remove(at: index)
                numExploded += 1
                
                if let fuse = fireworkContainer.childNode(withName: "fuse") {
                    let wait = SKAction.wait(forDuration: 0.2)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([wait, remove])
                    fuse.run(sequence)
                }
                
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2000
        default:
            score += 4000
        }
    }
    
    func gameOver() {
        let gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.text = "Game Over"
        gameOver.name = "gameOver"
        gameOver.fontSize = 48
        gameOver.position = CGPoint(x: 512, y: 378)
        addChild(gameOver)
        
        let playAgain = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.text = "Play Again"
        playAgain.name = "playAgain"
        playAgain.fontSize = 36
        playAgain.position = CGPoint(x: 512, y: 290)
        addChild(playAgain)
        
        let yourScore = SKLabelNode(fontNamed: "Chalkduster")
        yourScore.text = "Final Score: \(score)"
        yourScore.name = "yourScore"
        yourScore.fontSize = 36
        yourScore.position = CGPoint(x: 512, y: 466)
        addChild(yourScore)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "explode" {
                explodeFireworks()
            }
            
            if node.name == "playAgain" {
                let remove = ["playAgain", "gameOver", "yourScore"]
                for item in children {
                    for name in remove {
                        if item.name == name { item.removeFromParent() }
                    }
                }
                score = 0
                launchCount = 0
                launchFireworks()
                gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
}
