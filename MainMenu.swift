//
//  MainMenu.swift
//  flappymaybe
//
//  Created by pro on 5/29/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//
import SpriteKit

class MainMenu: SKScene {
    weak var ViewController: GameViewController?
    var startLabel: SKSpriteNode!
    var optionsLabel: SKSpriteNode!
    var soundPlayer: SoundPlayer?
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 385)
        addChild(background)
        
        startLabel = SKSpriteNode(imageNamed: "start")
        startLabel.position = CGPoint(x: 512, y: 368)
        addChild(startLabel)
        
        optionsLabel = SKSpriteNode(imageNamed: "options")
        optionsLabel.position = CGPoint(x: 512, y: 168)
        addChild(optionsLabel)
        
        if soundPlayer == nil {
            soundPlayer = SoundPlayer()
            soundPlayer?.playMusic()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(startLabel){
            moveToGame()
        } else if objects.contains(optionsLabel){
            moveToOptions()
        }
    }
    
    func moveToGame() {
        let newGame = GameScene(size: self.size)
        self.ViewController?.gameScene = newGame
        newGame.soundPlayer = soundPlayer
        let transition = SKTransition.moveIn(with: .down, duration: 0.5)
        self.view?.presentScene(newGame, transition: transition)
    }
    
    func moveToOptions(){
        let newGame = OptionsScreen(size: self.size)
        self.ViewController?.optionsScreen = newGame
        newGame.soundPlayer = soundPlayer
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        self.view?.presentScene(newGame, transition: transition)
    }
}
