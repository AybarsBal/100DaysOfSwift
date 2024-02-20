//
//  GameScene.swift
//  Project17
//
//  Created by Yakup Aybars Bal on 25.01.2024.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    var playAgain: SKLabelNode!
    var gameOver: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var gameTimer: Timer?
    
    let possibleEnemys = ["ball", "hammer", "tv"]
    var isGameOver = false
    var isPlayerTouched = false
    var enemyCount = 0
    var level = 1
    var highScore = 0
    var timerCount = 1.0 {
        didSet {
            level += 1
            if level > 9 { levelLabel.text = "Max Level!!"  } else { levelLabel.text = "Level: \(level)" }
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: \(level)"
        levelLabel.position = CGPoint(x: 16, y: 700)
        levelLabel.horizontalAlignmentMode = .left
        addChild(levelLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: timerCount, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.value(forKey: "highScore") as? Data {
            let decoder = JSONDecoder()
            
            do {
                highScore = try decoder.decode(Int.self, from: savedScore)
            } catch {
                print("Loading score error!")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }

    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemys.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.name = "Enemy"
        
        enemyCount += 1
        
        if enemyCount.isMultiple(of: 5) {
            gameTimer?.invalidate()
            
            if timerCount > 0.2 { timerCount -= 0.1 }
            gameTimer = Timer.scheduledTimer(timeInterval: timerCount, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        gameTimer?.invalidate()
        
        isGameOver = true
        
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        if score > highScore {
            highScoreLabel.text = "New Highscore: \(score)!!!"
            highScore = score
            save()
        } else if score <= highScore {
            highScoreLabel.text = "Final Score: \(score)"
            scoreLabel.text = "High Score: \(highScore)"
        }
        highScoreLabel.fontSize = 40
        highScoreLabel.name = "Score Label"
        highScoreLabel.position = CGPoint(x: 512, y: 526)
        addChild(highScoreLabel)
        
        gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.text = "Game Over"
        gameOver.fontSize = 48
        gameOver.name = "Game Over"
        gameOver.position = CGPoint(x: 512, y: 440)
        addChild(gameOver)
        
        playAgain = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.position = CGPoint(x: 512, y: 360)
        playAgain.text = "Play Again"
        playAgain.fontSize = 36
        playAgain.name = "Play Again"
        addChild(playAgain)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        let object = nodes(at: location)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        if object.contains(player) {
            isPlayerTouched = true
        }
        
        if isPlayerTouched {
            player.position = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        if let playAgain = playAgain {
            if object.contains(playAgain) {
                resetGame()
                
                gameTimer = Timer.scheduledTimer(timeInterval: timerCount, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
        }
        isPlayerTouched = false
    }
    
    func resetGame() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        for node in children {
            if node.name == "Play Again" || node.name == "Game Over" || node.name == "Enemy" || node.name == "Score Label"{
                node.removeFromParent()
            }
        }
        
        score = 0
        isGameOver = false
        timerCount = 1.0
        level = 1
        enemyCount = 0
        levelLabel.text = "Level: 1"
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        }
            
        
    }
}
