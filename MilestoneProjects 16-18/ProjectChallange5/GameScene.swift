//
//  GameScene.swift
//  ProjectChallange5
//
//  Created by Yakup Aybars Bal on 26.01.2024.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var bulletLabel: SKLabelNode!
    var reloadBox: SKSpriteNode!
    var countdownLabel: SKLabelNode!
    var alertLabel: SKLabelNode!
    var playAgainLabel: SKLabelNode!
    
    var gamerTimer: Timer!
    var countDownTimer: Timer!
    var currentTarget = String()
    
    var highScore = 0
    var bullets = 6 {
        didSet {
            bulletLabel.text = "Bullet: \(bullets)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var remainingTime = 30 {
        didSet {
            countdownLabel.text = "\(remainingTime)..."
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        scene?.backgroundColor = .brown
        
        for i in 0...2 { createRow(at: CGPoint(x: 512, y: 668 - (i * 200))) }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 36
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: 56)
        addChild(scoreLabel)
        
        bulletLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletLabel.text = "Bullet: 6"
        bulletLabel.fontSize = 36
        bulletLabel.horizontalAlignmentMode = .left
        bulletLabel.position = CGPoint(x: 20, y: 106)
        addChild(bulletLabel)
        
        reloadBox = SKSpriteNode(color: UIColor(red: 0.8, green: 0.1, blue: 0.3, alpha: 1), size: CGSize(width: 180, height: 64))
        reloadBox.position = CGPoint(x: 900, y: 80)
        reloadBox.name = "reload"
        addChild(reloadBox)
        
        let reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.text = "Reload"
        reloadLabel.zPosition = 2
        reloadLabel.fontSize = 24
        reloadLabel.position = CGPoint(x: 900, y: 72)
        addChild(reloadLabel)
        
        countdownLabel = SKLabelNode(fontNamed: "Chalkduster")
        countdownLabel.text = "60..."
        countdownLabel.fontSize = 36
        countdownLabel.position = CGPoint(x: 512, y: 106)
        addChild(countdownLabel)
        
        startGame()
        
        let defaults = UserDefaults.standard
        
        if let scoreData = defaults.value(forKey: "highScore") as? Data {
            let decoder = JSONDecoder()
            
            do {
                highScore = try decoder.decode(Int.self, from: scoreData)
            } catch {
                print("Loading error")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if bullets > 0 { bullets -= 1 }
        
        if bullets < 3 { bulletLabel.fontColor = UIColor(red: 0.6, green: 0.1, blue: 0.2, alpha: 1)}
        
        for node in tappedNodes {
            if node.name == "reload" {
                bullets = 6
                bulletLabel.fontColor = .white
            }
            
            if bullets > 0 {
                if node.name == "player" {
                    destroyTarget(node)
                    score += 15
                } else if node.name == "mouse" || node.name == "penguinGood" {
                    destroyTarget(node)
                    score -= 20
                } else if node.name == "penguinEvil" {
                    destroyTarget(node)
                    score += 5
                } else if node.name == "sliceBomb"{
                    destroyTarget(node)
                    score -= 30
                }
            }
            
            if node.name == "Play Again" {
                score = 0
                remainingTime = 5
                bullets = 6
                gamerTimer.invalidate()
                countDownTimer.invalidate()
                startGame()
                
                for node in children {
                    if node.name == "gameOver" || node.name == "Play Again" || node.name == "table" || node.name == "finalScore" {
                        node.removeFromParent()
                    }
                }
                
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x > 1100 || node.position.x < -30 {
                node.removeFromParent()
            }
        }
        
        if remainingTime < 1 {
            
            for node in children {
                if node.physicsBody?.categoryBitMask == 2 {
                    node.removeFromParent()
                }
            }
            
            bullets = 6
            bulletLabel.fontColor = .white
            
            gamerTimer.invalidate()
            countDownTimer.invalidate()
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.name = "gameOver"
            addChild(gameOver)
            
            let table = SKSpriteNode(color: .darkGray, size: CGSize(width: 600, height: 450))
            table.position = CGPoint(x: 512, y: 384)
            table.name = "table"
            addChild(table)
            
            let finalScore = SKLabelNode(fontNamed: "Chalkduster")
            if score > highScore {
                finalScore.text = "New high score: \(score)"
                highScore = score
                save()
            } else if score <= highScore {
                finalScore.text = "Final score: \(score)"
                scoreLabel.text = "High Score: \(highScore)"
            }
            finalScore.fontSize = 48
            finalScore.name = "finalScore"
            finalScore.position = CGPoint(x: 512, y: 478)
            addChild(finalScore)
            
            playAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
            playAgainLabel.text = "Play Again"
            playAgainLabel.name = "Play Again"
            playAgainLabel.position = CGPoint(x: 512, y: 270)
            playAgainLabel.fontSize = 48
            addChild(playAgainLabel)

        }
        
        alertLabel = SKLabelNode(fontNamed: "Chalkduster")
        if bullets < 1 {
            alertLabel.text = "RELOAD!!"
            alertLabel.name = "alert"
            alertLabel.fontColor = .red
            alertLabel.zPosition = 1
            alertLabel.fontSize = 80
            alertLabel.position = CGPoint(x: 512, y: 384)
            addChild(alertLabel)
        } else if bullets > 0 {
            for node in children {
                if node.name == "alert" { node.removeFromParent() }
            }
        }
    }
    
    func createRow(at position: CGPoint) {
        let row = RowSlot()
        row.configure(at: position)
        addChild(row)
    }
    
    @objc func createTarget() {
        var yPoints = [644, 444, 244]
        
        yPoints.shuffle()
        createSprite(y: yPoints[0])
        
        if Int.random(in: 0...12) > 4 { createSprite(y: yPoints[1])}
        if Int.random(in: 0...12) > 8 { createSprite(y: yPoints[2])}
        
        
    }
    
    func createSprite(y: Int) {
        let possibleTargets = ["mouse", "penguinEvil", "penguinGood", "player", "sliceBomb"]
        currentTarget = possibleTargets.randomElement()!
        
        let sprite = SKSpriteNode(imageNamed: currentTarget)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.name = currentTarget
        sprite.physicsBody?.collisionBitMask = 1
        sprite.physicsBody?.categoryBitMask = 2
        sprite.physicsBody?.linearDamping = 0
        
        func yPosition(i: Int, v: Int) {
            if y == 444 {
                sprite.position = CGPoint(x: 1050, y: y + i)
                sprite.physicsBody?.velocity = CGVector(dx: -400 - v, dy: 0)
            } else {
                sprite.position = CGPoint(x: -20, y: y + i)
                sprite.physicsBody?.velocity = CGVector(dx: 400 + v, dy: 0)
            }
        }
        
        if currentTarget == "mouse" || currentTarget == "player" {
            sprite.size = CGSize(width: 70, height: 70)
            yPosition(i: -30, v: 180)
        } else if currentTarget == "penguinEvil" || currentTarget == "penguinGood" {
            sprite.size = CGSize(width: 148, height: 148)
            yPosition(i: 10, v: -180)
        } else {
            sprite.size = CGSize(width: 100, height: 100)
            yPosition(i: -20, v: 0)
        }
        
        
        
        addChild(sprite)
    }
    
    @objc func countdown() {
        remainingTime -= 1
    }
    
    func startGame() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        gamerTimer = Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        bulletLabel.fontColor = .white
    }
    
    func destroyTarget(_ target: SKNode) {
        target.removeFromParent()
        let emitter = SKEmitterNode(fileNamed: "explosion")!
        emitter.position = target.position
        addChild(emitter)
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        }
    }
}

