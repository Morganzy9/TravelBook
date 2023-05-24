//
//  TableVC.swift
//  TravelBook
//
//  Created by Ислам Пулатов on 5/24/23.
//

import UIKit
import CoreData

class TableVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var idArray = [UUID]()
    var titlesArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        
//        MARK: ADD BUTTON
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
    }
    
    @objc func addButtonClicked() {
        
        performSegue(withIdentifier: "toDetailMapVC", sender: nil)
        
    }
    
    
    @objc func getData() {
        
        idArray.removeAll()
        titlesArray.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        
        
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                        
                    if let title = result.value(forKey: "title") as? String {
                        titlesArray.append(title)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    
                }
                
            }
            
            
        } catch {
            
            print("Error")
            
        }
        
        tableView.reloadData()
        
    }
    

}

//  MARK: - Extension`s

extension TableVC : UITableViewDelegate {
    
    
}

extension TableVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titlesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = titlesArray[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
}


