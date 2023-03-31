//
//  SettingsTableViewController.swift
//  Game
//
//  Created by Никита Долгих on 11/02/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var switchTimer: UISwitch!
    @IBOutlet weak var switchMusic: UISwitch!
    @IBOutlet weak var timeGameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadSettings()
    }
    @IBAction func changeTimerState(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn
    }
    @IBAction func changeMusicState(_ sender: UISwitch) {
        Settings.shared.currentSettings.musicState = sender.isOn
    }
    
    @IBAction func resetSettings(_ sender: Any) {
        Settings.shared.resetSettings()
        LoadSettings()
    }
    
    func LoadSettings(){
        timeGameLabel.text = "\(Settings.shared.currentSettings.timeForGame) сек"
        switchTimer.isOn = Settings.shared.currentSettings.timerState
        switchMusic.isOn = Settings.shared.currentSettings.musicState
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "SelectTimeVC":
            if let vc = segue.destination as? SelectTimeViewController{
                vc.data = [10,20,30,40,50,60,70,80,90,100,110,120]
            }
        default:
            break
        }
    }
}
