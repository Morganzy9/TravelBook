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
    
    var noteArray = [String]()
    
    var choosenTitle = ""
    var choosenTitleId : UUID?
    
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
        
        choosenTitle = ""
        
        performSegue(withIdentifier: "toDetailMapVC", sender: nil)
        
    }
    
    
    @objc func getData() {
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        
        
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                idArray.removeAll(keepingCapacity: false)
                titlesArray.removeAll(keepingCapacity: false)
                noteArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                         
                    if let title = result.value(forKey: "title") as? String {
                        titlesArray.append(title)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    
                    if let note = result.value(forKey: "note") as? String {
                        noteArray.append(note)
                    }
                    
                    tableView.reloadData()
                    
                }
                
            }
            
            
        } catch {
            
            print("Error")
            
        }
        
        
        
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
        
        content.secondaryText = noteArray[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = titlesArray[indexPath.row]
        choosenTitleId = idArray[indexPath.row]
        
        performSegue(withIdentifier: "toDetailMapVC", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailMapVC" {
            
            let destination = segue.destination as? ViewController
            
            destination?.selectedTitle = choosenTitle
            destination?.selectedTitleId = choosenTitleId
            
        }
        
    }
    
    
    
    
    
}


