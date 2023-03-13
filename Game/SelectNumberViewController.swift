//
//  SelectNumberViewController.swift
//  Game
//
//  Created by Никита Долгих on 21/02/2023.
//

import UIKit

class SelectNumberViewController: UIViewController {
    var data:[Int] = []
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
extension SelectNumberViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Settings.shared.currentSettings.numberForGame = data[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
}
