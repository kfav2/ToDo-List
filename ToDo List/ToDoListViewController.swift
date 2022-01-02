//
//  ViewController.swift
//  ToDo List
//
//  Created by Korlin Favara on 1/1/22.
//

import UIKit

class ToDoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var toDoArray = ["Learn Swift", "Build Apps", "Change the World", "Eat Lunch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Swift needs data for tableView to do what it needs to
        // This line says you can get the data from self
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    // how many cells are in UITable, returns Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoArray.count
    }
    
    // formatting cells so that they are "re-used", iOS only uses a defined amount of cells on a page. e.g. if table has 1000 elements, when you scroll the cells move and are reused
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
}
