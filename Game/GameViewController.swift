//
//  GameViewController.swift
//  Game
//
//  Created by Никита Долгих on 07/02/2023.
//

import UIKit
import SwiftUI
//import AVFAudio

class GameViewController: UIViewController {
//    var audioPlayer = AVAudioPlayer()
    @IBOutlet var Buttons: [UIButton]!
    
    @IBOutlet weak var NextDigit: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var NewGameButton: UIButton!
    
    lazy var game = Game(countItems: Buttons.count) { [weak self] (status, time) in
        
        guard let self = self else {return}
        
        self.TimerLabel.text = time.SecondsToString()
        self.updateInfoGame(with: status)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.StopGame()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        do{
//            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "FonMusic", ofType: "mp3")!))
//            audioPlayer.prepareToPlay()
//        }catch{
//            
//        }
        
        setupScreen()
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let ButtonIndex = Buttons.firstIndex(of: sender) else {return}
        game.check(index:ButtonIndex)
        
        UpdateUI()
    }
    
    @IBAction func NewGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    private func setupScreen(){
        for index in game.items.indices{
            Buttons[index].setTitle(game.items[index].title, for: .normal)
            //Buttons[index].isHidden = false
            Buttons[index].alpha = 1
            Buttons[index].isEnabled = true
        }
        NextDigit.text = game.nextItem?.title
    }
    private func UpdateUI(){
        for index in game.items.indices{
            // Buttons[index].isHidden = game.items[index].isFound
            Buttons[index].alpha = game.items[index].isFound ? 0 : 1
            Buttons[index].isEnabled = !game.items[index].isFound
            if game.items[index].isErorr{
                UIView.animate(withDuration: 0.3){ [weak self] in
                    self?.Buttons[index].backgroundColor = .red
                } completion: { [weak self] (_) in
                    self?.Buttons[index].backgroundColor = .white
                    self?.game.items[index].isErorr = false
                }
            }
        }
        NextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status:StatusGame){
        switch status {
        case .Start:
            StatusLabel.text = "Игра началась"
            StatusLabel.textColor = .black
            NewGameButton.isHidden = true
//            audioPlayer.play()
        case .Win:
            StatusLabel.text = "Вы выиграли"
            StatusLabel.textColor = .green
            NewGameButton.isHidden = false
//            audioPlayer.stop()
            if game.isNewRecord{
                showAlert()
            }else{
                showAlertActionSheet()
            }
        case .Lose:
            StatusLabel.text = "Вы проиграли"
            StatusLabel.textColor = .red
            NewGameButton.isHidden = false
            showAlertActionSheet()
//            audioPlayer.stop()
        }
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы установили новый рекорд", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
    private func showAlertActionSheet(){
        let alert = UIAlertController(title: "Что вы хотите сделать далее?", message:nil, preferredStyle: .actionSheet)
        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default){[weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default){[weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive){[weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}
