//
//  Game.swift
//  Game
//
//  Created by Никита Долгих on 07/02/2023.
//

import Foundation
import AVFAudio

enum StatusGame{
    case Start
    case Win
    case Lose
}

class Game {
    
    
    struct Item{
        var title:String
        var isFound:Bool = false
        var isErorr = false
    }
    private var NumberForGame:Int
    let data = Array(1...99)
    
    var items:[Item]=[]
    
    private var countItems:Int
    
    var nextItem:Item?
    var audioPlayer = AVAudioPlayer()
    var isNewRecord = false
    var status:StatusGame = .Start{
        didSet{
            if status != .Start{
                if status == .Win{
                    let newRecord = TimeForGame - secondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    if record == 0 || newRecord < record{
                        UserDefaults.standard.set(newRecord, forKey: KeysUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                StopGame()
            }
        }
    }
    private var TimeForGame:Int
    private var secondsGame:Int{
        didSet{
            if secondsGame == 0{
                status = .Lose
            }
            updateTimer(status,secondsGame)
        }
    }
    
    private var timer:Timer?
    private var updateTimer:((StatusGame, Int)->Void)
    
    init(countItems:Int, updateTimer:@escaping (_ status:StatusGame,_ seconds:Int)->Void){
        self.countItems = countItems
        self.TimeForGame = Settings.shared.currentSettings.timeForGame
        self.NumberForGame = Settings.shared.currentSettings.numberForGame
        self.secondsGame = self.TimeForGame
        self.updateTimer = updateTimer
        setupGame()
    }
    
    
    private func setupGame(){
        isNewRecord = false
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItems{
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        nextItem = items.shuffled().first
        updateTimer(status,secondsGame)
        if Settings.shared.currentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.secondsGame -= 1
            })
        }
        if Settings.shared.currentSettings.musicState{
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "FonMusic", ofType: "mp3")!))
                audioPlayer.prepareToPlay()
            }catch{

            }
            audioPlayer.play()
        }
    }
    
    func newGame(){
        status = .Start
        self.secondsGame = self.TimeForGame
        setupGame()
    
    }
    func check(index:Int){
        guard status == .Start else {return}
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            })
        }
        else {
            items[index].isErorr = true
        }
        
        if nextItem == nil{
            status = .Win
        }
    }
    func StopGame(){
        timer?.invalidate()
    }
}

extension Int{
    func SecondsToString()->String{
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
