//
//  GameScene.swift
//  Project11
//
//  Created by Yakup Aybars Bal on 15.01.2024.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    // Challenge 3
    var ballLeft: SKLabelNode!
    var leftedBall = 5 {
        didSet {
            ballLeft.text = "\(leftedBall) Balls left!"
            
            if leftedBall <= 0 {
                ballLeft.text = "Game Over"
                ballLeft.colorBlendFactor = 1
                ballLeft.color = .red
            }
        }
    }
    
    // Challenge 1
    var ballArray = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow" ]
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        var bouncerX = 0
        for _ in 0...4 {
            makeBouncer(at: CGPoint(x: bouncerX, y: 0))
            bouncerX += 256
        }
        
        var slotX = 128
        var isGood = true
        for _ in 0...3 {
            makeSlot(at: CGPoint(x: slotX, y: 0), isGood: isGood)
            slotX += 256
            isGood.toggle()
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        // Challenge 3
        ballLeft = SKLabelNode(fontNamed: "Chalkduster")
        ballLeft.position = CGPoint(x: 512, y: 700)
        ballLeft.text = "5 Balls left!"
        addChild(ballLeft)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1),
                                                      green: CGFloat.random(in: 0...1),
                                                      blue: CGFloat.random(in: 0...1),
                                                      alpha: 1),
                                       size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.name = "box" // Challenge 3
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                
                addChild(box)
            } else {
                if location.y >= 580 { // Challenge 2
                    let ball = SKSpriteNode(imageNamed: "ball\(ballArray.randomElement()!)") // Challenge 1
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        let spin = SKAction.rotate(byAngle: .pi , duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotBase.position = position
        slotGlow.position = position
        addChild(slotGlow)
        addChild(slotBase)
        
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            leftedBall += 1  // Challenge 3
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            leftedBall -= 1  // Challenge 3
        }
    }
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
        
        // Challenge 3
        if nodeA.name == "box" {
            nodeA.removeFromParent()
        } else if nodeB.name == "box" {
            nodeB.removeFromParent()
        }
    }
    
}
