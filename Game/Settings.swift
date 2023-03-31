//
//  Settings.swift
//  Game
//
//  Created by Никита Долгих on 13/02/2023.
//

import Foundation

enum KeysUserDefaults{
    static let SettingsGame = "SettingsGame"
    static let recordGame = "recordGame"
}

struct SettingsGame:Codable{
    var timerState:Bool
    var musicState:Bool
    var timeForGame:Int
}

class Settings{
    static var shared = Settings()
    
    private let defaultSettings = SettingsGame(timerState: true, musicState: true, timeForGame: 30)
    var currentSettings:SettingsGame{
        get{
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.SettingsGame) as? Data{
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            }else{
                if let data = try? PropertyListEncoder().encode(defaultSettings){
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.SettingsGame)
                }
                return defaultSettings
            }
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.SettingsGame)
            }
        }
    }
    func resetSettings(){
        currentSettings = defaultSettings
    }
}
