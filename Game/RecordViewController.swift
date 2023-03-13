//
//  RecordViewController.swift
//  Game
//
//  Created by Никита Долгих on 14/02/2023.
//

import UIKit

class RecordViewController: UIViewController {
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        if record != 0{
            recordLabel.text = "Ваш рекорд - \(record)"
        }else{
            recordLabel.text = "Рекорд не установлен"
        }
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
