//
//  GameScene.swift
//  flappymaybe
//
//  Created by pro on 5/7/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import SpriteKit
import GameplayKit
enum Contacts: UInt32{
  case flapper = 1
  case pipe = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  weak var ViewController: GameViewController?
  var flapper: SKSpriteNode!
  var background: SKSpriteNode!
  var floor: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  var finalScoreLabel: SKLabelNode!
  var playAgain: SKSpriteNode!
  var mainMenuLabel: SKSpriteNode!
  var gamerTimer: Timer?
  var soundPlayer: SoundPlayer?
  var isGameOver = true
  var score = 0 {
    didSet{
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.8)
    physicsWorld.speed = 0
    
    background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.zPosition = -1
//    background.blendMode = .replace
    background.name = "background"
    addChild(background)
    
    
    flapper = SKSpriteNode(imageNamed: "flapper")
    flapper.position = CGPoint(x: 300, y: 368)
    flapper.size = CGSize(width: 50, height: 50)
    flapper.physicsBody = SKPhysicsBody(circleOfRadius: 25)
    flapper.physicsBody?.categoryBitMask = Contacts.flapper.rawValue
    flapper.physicsBody?.collisionBitMask = Contacts.pipe.rawValue
    flapper.physicsBody?.contactTestBitMask = Contacts.pipe.rawValue
    flapper.name = "flapper"
    addChild(flapper)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.fontColor = .black
    scoreLabel.position = CGPoint(x: 10, y: 730)
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.text = "Score: 0"
    scoreLabel.zPosition = 2
    addChild(scoreLabel)
    
    let tutorialScreen = SKNode()
    tutorialScreen.name = "tutorialScreen"
    
    
    let tutorialBackgroundScreen = SKSpriteNode(imageNamed: "tutorialScreen")
    tutorialBackgroundScreen.position = CGPoint(x: 512, y: 368)
    tutorialBackgroundScreen.zPosition = 2
    tutorialScreen.addChild(tutorialBackgroundScreen)
    
    
    let beginButton = SKSpriteNode(imageNamed: "beginButton")
    beginButton.position = CGPoint(x: 512, y: 200)
    beginButton.zPosition = 3
    beginButton.name = "beginButton"
    tutorialScreen.addChild(beginButton)
    
    let tutorialText = SKLabelNode(fontNamed: "Chalkduster")
    tutorialText.text = "How to play\nSimply tap the Screen\nWarning:\nWatch Out for pipes!!!"
    tutorialText.verticalAlignmentMode = .center
    tutorialText.horizontalAlignmentMode = .center
    tutorialText.numberOfLines = 4
    tutorialText.position = CGPoint(x: 512, y: 410)
    tutorialText.fontColor = UIColor(ciColor: CIColor(red: 0.58, green: 1.0 , blue: 1.0, alpha: 1.0))
    tutorialScreen.addChild(tutorialText)
    
    addChild(tutorialScreen)
    
  }
  
  func beginGame(){
    for node in children{
      if node.name == "tutorialScreen"{
        node.removeFromParent()
      }
    }
    isGameOver = false
    physicsWorld.speed = 1.0
    
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      let startingPipeLocations = [800, 1100]
      for xPosition in  startingPipeLocations{
        self.createPipe(pipeX: xPosition)
      }
    }
    gamerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.createPipe), userInfo: nil, repeats: true)

  }/// need polishing!!!!
  
  func didBegin(_ contact: SKPhysicsContact) {
    gameOver()
  }
  func pipeValues(pipe: SKSpriteNode, _ name: String) {
    pipe.name = name
    pipe.xScale = 0.8
    pipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe.size.width, height: pipe.size.height))
    pipe.physicsBody?.isDynamic = false
    pipe.physicsBody?.categoryBitMask = Contacts.pipe.rawValue
    pipe.physicsBody?.collisionBitMask = Contacts.flapper.rawValue
    pipe.physicsBody?.contactTestBitMask = Contacts.flapper.rawValue
  }
  
  @objc func createPipe(pipeX: Int){
    var px = 0
    if pipeX < 10000{
      px = pipeX
    } else {
      px = 1100
    }
    
    let topPipe = SKSpriteNode(imageNamed: "topPipe")
    let bottomPipe = SKSpriteNode(imageNamed: "bottomPipe")
    
    let midpoint = Int.random(in: 125...638)
    pipeValues(pipe: topPipe, "pipe")
    pipeValues(pipe: bottomPipe, "notyet" )
    
    topPipe.position = CGPoint(x: px, y: (midpoint + 500))
    bottomPipe.position = CGPoint(x: px, y: midpoint - 500)
    addChild(topPipe)
    addChild(bottomPipe)
    let moveLeft = SKAction.moveBy(x: -30.0, y: 0.0, duration: 0.2)
    let moveleftForever = SKAction.repeatForever(moveLeft)
    topPipe.run(moveleftForever)
    bottomPipe.run(moveleftForever)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !isGameOver {
      flapper.physicsBody?.velocity.dy += 800
      soundPlayer?.playFX("jump")
    } else {
      guard let touch = touches.first else {return}
      let location = touch.location(in: self)
      let objects = nodes(at: location)
      
      for node in objects{
        let name = node.name
        if name == "playAgain" {
          restartGame()
        } else if name == "mainMenuLabel"{
          goToMainMenu()
        } else if name == "beginButton" {
          beginGame()
        }
      }
    }
  }
  
  func gameOver() {
    physicsWorld.speed = 0.0
    soundPlayer?.playFX("fail")
    gamerTimer?.invalidate()//stop producing more pipes
    flapper.physicsBody?.isDynamic = false//flapper stops moving
    flapper.physicsBody?.isResting = true
    for node in children{// stops all the pipes from moving
      if node.name == "pipe" || node.name == "notyet" {
        node.physicsBody?.isResting = true
        node.removeAllActions()
      }
    }
    
    finalScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    finalScoreLabel.text = "      Game Over! \n Your final score is: \(score)"
    finalScoreLabel.fontColor = .black
    finalScoreLabel.position = CGPoint(x: 512, y: 468)
    finalScoreLabel.horizontalAlignmentMode = .center
    finalScoreLabel.verticalAlignmentMode = .center
    finalScoreLabel.numberOfLines = 2
    finalScoreLabel.zPosition = 2
    finalScoreLabel.name = "finalScoreLabel"
    addChild(finalScoreLabel)
    
    playAgain = SKSpriteNode(imageNamed: "playAgain")
    playAgain.position = CGPoint(x: 512, y: 268)
    playAgain.zPosition = 2
    playAgain.name = "playAgain"
    addChild(playAgain)
    
    mainMenuLabel = SKSpriteNode(imageNamed: "mainMenu")
    mainMenuLabel.position = CGPoint(x: 512, y: 128)
    mainMenuLabel.zPosition = 2
    mainMenuLabel.name = "mainMenuLabel"
    addChild(mainMenuLabel)
    isGameOver = true
    
    let highscore = UserDefaults.standard.integer(forKey: "HighScore")
    if score > highscore{
      UserDefaults.standard.set(score, forKey: "HighScore")
      soundPlayer?.playFX("achievement")
    }
    displayHighScore()
  }
  
  func displayHighScore(){
    let highscore = UserDefaults.standard.integer(forKey: "HighScore")
    
    let highScoreLabel = SKLabelNode(fontNamed: "ChalkDuster")
    highScoreLabel.text = "the HighScore is: \(highscore)"
    highScoreLabel.fontColor = .red
    highScoreLabel.position = CGPoint(x: 750, y: 364)
    highScoreLabel.name = "highScoreLabel"
    highScoreLabel.zPosition = 2
    addChild(highScoreLabel)
    
  }
  
  func restartGame() {
//    isGameOver = false
    playAgain.removeFromParent()
    finalScoreLabel.removeFromParent()
    
    flapper.physicsBody?.isDynamic = true
    flapper.position = CGPoint(x: 300, y: 368)// thease three lines return flapper to start location
    
    for node in children{ // this func removes the pipes, final score label, and the play again button
      let name = node.name
      if name != "flapper" && name != "scoreLabel" && name != "background" {
        node.removeFromParent()
      }
    }
    score = 0
    beginGame()
  }
  
  override func update(_ currentTime: TimeInterval) {
    if !isGameOver{
      for node in children{
        if node.position.x < -100 {
          node.removeFromParent()
        }
        if node.name == "flapper"{
          let flappy = node
//          print(flappy.position)
          guard let flappyVertSpeed:CGFloat = flappy.physicsBody?.velocity.dy else { fatalError("flappy has no speed")
          }
          
          if flappyVertSpeed > CGFloat(0.0) {
            flappy.zRotation = .pi / 4
          } else {
            flappy.zRotation = .pi / -4
          }
          if flappy.position.y > 764 || flapper.position.y < 4{
            gameOver()
          }
        }
        if node.name == "notyet" && node.position.x < 340{
          score += 1
          node.name = "pipe"
          soundPlayer?.playFX("point")
        }
      }
    }
  }
  
  func goToMainMenu() {
    let newGame = MainMenu(size: self.size)
    self.ViewController?.mainMenu = newGame
    newGame.soundPlayer = soundPlayer
    let transition = SKTransition.moveIn(with: .up, duration: 0.5)
    self.view?.presentScene(newGame, transition: transition)
  }
}
