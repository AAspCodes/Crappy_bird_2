//
//  OptionsScreen.swift
//  flappymaybe
//
//  Created by pro on 5/29/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//
import SpriteKit
import UIKit

class OptionsScreen: SKScene {
    weak var ViewController: GameViewController?
    var mainMenuLabel:SKSpriteNode!
    var musicBool:SKSpriteNode!
    var soundEffectBool: SKSpriteNode!
    var musicVolumeLabel: SKLabelNode!
    var soundEffectLabel: SKLabelNode!
    var upMusicVolume: SKSpriteNode!
    var downMusicVolume: SKSpriteNode!
    var upSoundEffectVolume: SKSpriteNode!
    var downSoundEffectVolume: SKSpriteNode!
    var changeMusicLabel: SKLabelNode!
    var soundPlayer: SoundPlayer?
    let defaults = UserDefaults.standard
    var isMusicOn: Bool?
    var isSoundEffectOn: Bool?
    var musicNum: Int?
    
    var musicVolume = 10{
        didSet{
            musicVolumeLabel.text = "Music Volume: \(musicVolume)"
        }
    }
    
    var soundEffectVolume = 10 {
        didSet{
            soundEffectLabel.text = "Sound Effect Volume: \(soundEffectVolume)"
        }
    }
    override func didMove(to view: SKView) {
        isMusicOn = defaults.bool(forKey: "isMusicOn")
        isSoundEffectOn = defaults.bool(forKey: "isSoundFXOn")
        musicNum = defaults.integer(forKey: "musicNum")
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -3
        background.position = CGPoint(x: 512, y: 368)
        addChild(background)
        
        mainMenuLabel = SKSpriteNode(imageNamed: "mainMenu")
        mainMenuLabel.scale(to: CGSize(width: 200, height: 75))
        mainMenuLabel.position = CGPoint(x: 125, y: 680)
        mainMenuLabel.name = "mainMenuLabel"
        addChild(mainMenuLabel)
        
        musicVolumeLabel = SKLabelNode(fontNamed: "Chalkduster")
        musicVolumeLabel.text = "Music Volume: 10"
        musicVolumeLabel.fontColor = .red
        musicVolumeLabel.position = CGPoint(x: 100, y: 364)
        musicVolumeLabel.horizontalAlignmentMode = .left
        musicVolumeLabel.verticalAlignmentMode = .center
        musicVolumeLabel.name = "musicVolumeLabel"
        addChild(musicVolumeLabel)
        
        soundEffectLabel = SKLabelNode(fontNamed: "Chalkduster")
        soundEffectLabel.text = "Sound Effect Volume: 10"
        soundEffectLabel.fontColor = .red
        soundEffectLabel.position = CGPoint(x: 100, y: 304)
        soundEffectLabel.horizontalAlignmentMode = .left
        soundEffectLabel.verticalAlignmentMode = .center
        soundEffectLabel.name = "soundEffectLabel"
        addChild(soundEffectLabel)
        
        musicBool = SKSpriteNode(imageNamed: "true")
        if !isMusicOn! {
            musicBool.texture = SKTexture(imageNamed: "false")
        }
        musicBool.position = CGPoint(x: 802, y: 364)
        musicBool.name = "musicBool"
        addChild(musicBool)
        
        soundEffectBool = SKSpriteNode(imageNamed: "true")
        if !isSoundEffectOn! {
            soundEffectBool.texture = SKTexture(imageNamed: "false")
        }
        soundEffectBool.position = CGPoint(x: 802, y: 304)
        soundEffectBool.name = "soundEffectBool"
        addChild(soundEffectBool)
        
        upMusicVolume = SKSpriteNode(imageNamed: "upArrow")
        upMusicVolume.position = CGPoint(x: 600, y: 364)
        upMusicVolume.name = "upMusicVolume"
        addChild(upMusicVolume)
        
        downMusicVolume = SKSpriteNode(imageNamed: "downArrow")
        downMusicVolume.position = CGPoint(x: 50, y: 364)
        downMusicVolume.name = "downMusicVolume"
        addChild(downMusicVolume)
        
        upSoundEffectVolume = SKSpriteNode(imageNamed: "upArrow")
        upSoundEffectVolume.position = CGPoint(x: 600, y: 304)
        upSoundEffectVolume.name = "upSoundEffectVolume"
        addChild(upSoundEffectVolume)
        
        downSoundEffectVolume = SKSpriteNode(imageNamed: "downArrow")
        downSoundEffectVolume.position = CGPoint(x: 50, y: 304)
        downSoundEffectVolume.name = "downSoundEffectVolume"
        addChild(downSoundEffectVolume)
        
        changeMusicLabel = SKLabelNode(fontNamed: "Chalkduster")
        changeMusicLabel.text = "Change Music"
        changeMusicLabel.position = CGPoint(x: 16, y: 16)
        changeMusicLabel.horizontalAlignmentMode = .left
        changeMusicLabel.fontColor = .black
        changeMusicLabel.name = "changeMusicLabel"
        addChild(changeMusicLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        for node in object{
            switch node.name{
            case "mainMenuLabel":
                goToMainMenu()
            case "musicBool":
                musicBoolFlip()
            case "soundEffectBool":
                soundEffectBoolFlip()
            case "upMusicVolume":
                musicVolumeChange(true)
            case "downMusicVolume":
                musicVolumeChange(false)
            case "upSoundEffectVolume":
                soundEffectVolumeChange(true)
            case "downSoundEffectVolume":
                soundEffectVolumeChange(false)
            case "changeMusicLabel":
                changeTheMusic()
            default:
                  break
            }
        }
    }
    
    func changeTheMusic() {
        if musicNum! < 6 {
            musicNum! += 1
        } else {
            musicNum = 0
        }
        
        defaults.set(musicNum, forKey: "musicNum")
        soundPlayer?.playMusic()
    }
    
    func goToMainMenu() {
        let newGame = MainMenu(size: self.size)
        self.ViewController?.mainMenu = newGame
        newGame.soundPlayer = soundPlayer
        let transition = SKTransition.moveIn(with: .down, duration: 0.5)
        self.view?.presentScene(newGame, transition: transition)
    }
    
    func musicBoolFlip() {
        if isMusicOn! {
            isMusicOn = false
            defaults.set(isMusicOn, forKey: "isMusicOn")
            musicBool.texture = SKTexture(imageNamed: "false")
            soundPlayer?.music?.pause()
        } else {
            isMusicOn = true
            defaults.set(isMusicOn,forKey: "isMusicOn")
            musicBool.texture = SKTexture(imageNamed: "true")
            soundPlayer?.music?.play()
        }
    }
    
    func soundEffectBoolFlip() {
        if  isSoundEffectOn!{
            isSoundEffectOn = false
            defaults.set(isSoundEffectOn, forKey: "isSoundFXOn")
            soundEffectBool.texture = SKTexture(imageNamed: "false")
            soundPlayer?.isSoundFXOn = isSoundEffectOn
            soundPlayer?.soundFX?.stop()
            //turn on sound effects
        } else {
            isSoundEffectOn = true
            defaults.set(isSoundEffectOn, forKey: "isSoundFXOn")
            soundEffectBool.texture = SKTexture(imageNamed: "true")
            soundPlayer?.isSoundFXOn = isSoundEffectOn
            soundPlayer?.soundFX?.stop()
            // turn off sound effects
        }
    }
    
    func musicVolumeChange(_ change: Bool) {
        if change{
            if musicVolume < 10{
                musicVolume += 1
                let musicFloatVolume = Float(musicVolume) / 10.0
                soundPlayer?.musicVolume = musicFloatVolume
                defaults.set(musicFloatVolume,forKey: "musicVolume")
                soundPlayer?.music?.setVolume(musicFloatVolume, fadeDuration: 0.0)
            }
        } else if musicVolume > 1 {
            musicVolume -= 1
            let musicFloatVolume = Float(musicVolume) / 10.0
            soundPlayer?.musicVolume = musicFloatVolume
            defaults.set(musicFloatVolume,forKey: "musicVolume")
            soundPlayer?.music?.setVolume(musicFloatVolume, fadeDuration: 0.0)
        }
    }
    
    func soundEffectVolumeChange(_ change: Bool){
        if change{
            if soundEffectVolume < 10{
                soundEffectVolume += 1
                let soundFXVolume = Float(soundEffectVolume / 10)
                soundPlayer?.soundFXVolume = soundFXVolume
                defaults.set(soundFXVolume, forKey: "SoundFXVolume")
                soundPlayer?.soundFX?.setVolume(soundFXVolume, fadeDuration: 0.0)
            }
            
        } else if soundEffectVolume > 1 {
            soundEffectVolume -= 1
            let soundFXVolume = Float(soundEffectVolume / 10)
            soundPlayer?.soundFXVolume = soundFXVolume
            defaults.set(soundFXVolume, forKey: "SoundFXVolume")
            soundPlayer?.soundFX?.setVolume(soundFXVolume, fadeDuration: 0.0)
        }
    }
}
