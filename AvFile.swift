//
//  AvFile.swift
//  flappymaybe
//
//  Created by pro on 5/30/19.
//  Copyright © 2019 tonynomadscoderad. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    let defaults = UserDefaults.standard
    var music: AVAudioPlayer?
    var soundFX: AVAudioPlayer?
    var musicNum: Int?
    var isMusicOn: Bool?
    var isSoundFXOn: Bool?
    var musicVolume: Float?
    var soundFXVolume: Float?
    var hasGameBeenPlayedBefore: Bool?
/// must cut music4. has a weird tone at the end
    func setup(){
        if !hasGameBeenPlayedBefore! {
            musicNum = 0
            isMusicOn = true
            musicVolume = 1.0 as Float
            hasGameBeenPlayedBefore = true
            defaults.set(musicNum , forKey:"musicNum")
            defaults.set(isMusicOn, forKey: "isMusicOn")
            defaults.set(musicVolume, forKey: "musicVolume")
            defaults.set(hasGameBeenPlayedBefore, forKey: "hasGameBeenPlayedBefore")
            firstsetupFX()
        } else {
            musicVolume = defaults.float(forKey: "musicVolume")
            music?.setVolume(musicVolume!, fadeDuration: 0.0)
            isMusicOn = defaults.bool(forKey: "isMusicOn")
            setupFX()
        }
         music?.numberOfLoops = 1000
    }
    
    func playMusic(){
        musicNum = defaults.integer(forKey: "musicNum")
        hasGameBeenPlayedBefore = defaults.bool(forKey: "hasGameBeenPlayedBefore")

        let path = Bundle.main.path(forResource: "music\(musicNum!).caf",ofType: nil)!
        let url = URL(fileURLWithPath: path)
 
        do{
            music = try  AVAudioPlayer(contentsOf: url)
            setup()
            if isMusicOn!{
                music?.play()
            }
        } catch {
            print("could load audio file")
        }
    }
    
    func firstsetupFX() {
        soundFXVolume = Float(1.0)
        isSoundFXOn = true
        defaults.set(soundFXVolume, forKey: "soundFXVolume")
        defaults.set(isSoundFXOn, forKey: "isSoundFXOn")
        soundFX?.setVolume(soundFXVolume!, fadeDuration: 0.0)
    }
    
    func setupFX() {
        soundFXVolume = defaults.float(forKey: "soundFXVolume")
        isSoundFXOn = defaults.bool(forKey: "isSoundFXOn")
        soundFX?.setVolume(soundFXVolume!, fadeDuration: 0.0)
    }
    
    func playFX(_ nameOfFX: String) {
        if isSoundFXOn! {
            let path = Bundle.main.path(forResource: "\(nameOfFX).caf",ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do{
                soundFX = try  AVAudioPlayer(contentsOf: url)
                if nameOfFX == "jump"{
                    soundFX?.setVolume((soundFXVolume! / 2.5), fadeDuration: 0.0)
                } else {
                    soundFX?.setVolume(soundFXVolume!, fadeDuration: 0.0)
                }
                soundFX?.play()
            } catch {
                print("could load audio file")
            }
        }
    }
}
