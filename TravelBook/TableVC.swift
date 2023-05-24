//
//  TableVC.swift
//  TravelBook
//
//  Created by Ислам Пулатов on 5/24/23.
//

import UIKit

class TableVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        MARK: ADD BUTTON
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
    }
    
    @objc func addButtonClicked() {
        
        performSegue(withIdentifier: "toDetailMapVC", sender: nil)
        
    }
    

}

//  MARK: - Extension`s

extension TableVC : UITableViewDelegate {
    
    
}

extension TableVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = "Ola"
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
}


