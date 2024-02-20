//
//  GameScene.swift
//  Project26
//
//  Created by Yakup Aybars Bal on 14.02.2024.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player: SKSpriteNode!
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false
    
    enum CollisionTypes: UInt32 {
        case zero = 0
        case player = 1
        case block = 2
        case star = 4
        case vortex = 8
        case finish = 16
        case portal = 32 // Challenge 3
    }
    
    var currentLevel = 1 // Challenge 2
    var portals = [SKSpriteNode]() // Challenge 3
    var isPortalsActive = true // Challenge 3
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        loadLevel()
        createPlayer()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        didFinishLevel()
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(currentLevel)", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for(row, line) in lines.reversed().enumerated() {
            for(column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row ) + 32)
                
                //challenge1
                loadNodes(letter: letter, position: position)
            }
        }
    }
    
    func createPlayer(to position: CGPoint = CGPoint(x: 96, y: 672)) { // location added for challenge 3
        player = SKSpriteNode(imageNamed: "player")
        player.name = "player"
        player.position = position
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.portal.rawValue // challenge 3
        player.physicsBody?.collisionBitMask = CollisionTypes.block.rawValue
        addChild(player)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "portal" { // challenge 3
            guard isPortalsActive == true else { return }
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                for portal in (self?.portals)! {
                    if node.position != portal.position {
                        self?.createPlayer(to: portal.position)
                    }
                }
                self?.isGameOver = false
                self?.isPortalsActive = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.isPortalsActive = true
                }
            }
            
        }else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            //challenge 2
            didFinishLevel()
        }
    }
    
    // MARK: - Hack for play on simulator
    
    var lastTouchPosition: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
        for node in nodes(at: location) {
            if node.name == "nextLevel" {
                nextLevel()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
#if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
#else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -7 , dy: accelerometerData.acceleration.x * 7)
        }
#endif
    }
    
    // MARK: - Challenges
    
    // Challenge1
    func createNode(name: String, position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: name)
        node.name = name
        node.position = position
        if node.name == "portal" { portals.append(node)}
        return node
    }
    func addPhysicsBody(node: SKSpriteNode, body: SKPhysicsBody, categoryBM: CollisionTypes, contactTestBM: CollisionTypes = CollisionTypes.player, collisionBM : CollisionTypes = CollisionTypes.zero) {
        if node.name == "vortex" || node.name == "portal"{ node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1))) }
        node.physicsBody = body
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = categoryBM.rawValue
        node.physicsBody?.contactTestBitMask = contactTestBM.rawValue
        node.physicsBody?.collisionBitMask = collisionBM.rawValue
        addChild(node)
    }
    func loadNodes(letter: String.Element, position: CGPoint) {
        switch letter {
        case "x":
            let node = createNode(name: "block", position: position)
            addPhysicsBody(node: node,
                           body: SKPhysicsBody(rectangleOf: node.size),
                           categoryBM: CollisionTypes.block,
                           contactTestBM: CollisionTypes.block,
                           collisionBM: CollisionTypes.block)
        case "v":
            let node = createNode(name: "vortex", position: position)
            addPhysicsBody(node: node, body: SKPhysicsBody(circleOfRadius: node.size.width / 2), categoryBM: CollisionTypes.vortex)
        case "s":
            let node = createNode(name: "star", position: position)
            addPhysicsBody(node: node, body: SKPhysicsBody(circleOfRadius: node.size.width / 2), categoryBM: CollisionTypes.star)
        case "f":
            let node = createNode(name: "finish", position: position)
            addPhysicsBody(node: node, body: SKPhysicsBody(circleOfRadius: node.size.width / 2), categoryBM: CollisionTypes.finish)
        case " ":
            print()
        case "p": // challenge 3
            let node = createNode(name: "portal", position: position)
            node.size = CGSize(width: 52, height: 52)
            addPhysicsBody(node: node, body: SKPhysicsBody(circleOfRadius: node.size.width / 2), categoryBM: CollisionTypes.portal)
        default:
            fatalError("Unknown level letter: \(letter)")
        }
    }
    
    //challenge 2
    
    func didFinishLevel() {
        isGameOver = true
        let levelComplete = SKLabelNode(fontNamed: "Chalkduster")
        levelComplete.name = "levelCompleted"
        if currentLevel < 2 {
            levelComplete.text = "Level Completed"
        } else {
            levelComplete.text = "Game Over"
        }
        levelComplete.horizontalAlignmentMode = .center
        levelComplete.fontSize = 60
        levelComplete.zPosition = 3
        levelComplete.position = CGPoint(x: 512, y: 404)
        addChild(levelComplete)
        
        let nextLevel = SKLabelNode(fontNamed: "Chalkduster")
        nextLevel.name = "nextLevel"
        if currentLevel < 2 {
            nextLevel.text = "Next Level"
        } else {
            nextLevel.text = "Restart Game"
        }
        nextLevel.horizontalAlignmentMode = .center
        nextLevel.fontSize = 48
        nextLevel.zPosition = 3
        nextLevel.position = CGPoint(x: 512, y: 324)
        addChild(nextLevel)
    }
    
    func nextLevel() {
        let removeItemsForLevel = ["block", "vortex", "star", "finish", "portal", "player", "nextLevel", "levelCompleted"]
        for node in children {
            guard let name = node.name else { continue }
            if removeItemsForLevel.contains(name) {
                node.removeFromParent()
            }
        }
        if currentLevel < 2 {
            currentLevel += 1
        } else {
            currentLevel = 1
        }
        isGameOver = false
        score = 0
        loadLevel()
        createPlayer()
    }
}
