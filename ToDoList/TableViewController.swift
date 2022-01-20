//
//  ViewController.swift
//  ToDoList
//
//  Created by munira almallki on 12/03/1443 AH.
//

import UIKit
import CoreData

class TableViewController: UITableViewController , AddItemDelegate {
 
    
    var todoItems = [ToDoItemAss]()

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllTodoItems()
    }
        
  
    // Core Data Persistence
    func getUpdatedContext()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
           
      // create item to core data
      func addItem(title: String, notes: String, date: String) {
          let context = getUpdatedContext()
          let note = ToDoItemAss.init(context: context)
          note.title = title
          note.notes = notes
          note.dateToComplete = date
          
          todoItems.append(note)
        do {
          try context.save()
        }catch{
          print(error.localizedDescription)
        }
      }
      
      
      // read item from core data
          func fetchAllTodoItems() {
        let context = getUpdatedContext()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItemAss")
        do {
          
            let results = try context.fetch(request)
          todoItems = results as! [ToDoItemAss]
        } catch {
          print(error.localizedDescription)
        }
    }
    
     // update data from core data
      func updateItem(path: Int){
          let context = getUpdatedContext()
        todoItems[path].completed.toggle()

          do{
              try context.save()
          }catch{
              print(error.localizedDescription)
          }


      }
      //delete item from core data
      func deleteItem(path: Int){
          let context = getUpdatedContext()
          
          context.delete(todoItems[path])
        todoItems.remove(at: path)
          
          do{
              try context.save()
          }catch{
              print(error.localizedDescription)
          }
          
          
      }
      

  // number Of Rows From tableView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return todoItems.count
      
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
      let todoItem = todoItems[indexPath.row]
      cell.titleLabel.text = todoItem.title
      cell.notesLabel.text = todoItem.notes
      
      
      cell.dateLabel.text = todoItem.dateToComplete
      
      if todoItem.completed {
          cell.accessoryType = .checkmark
      } else {
          cell.accessoryType = .none
      }
      
      return cell
  }
  
  
  @IBAction func AddItemPressed(_ segue: UIStoryboardSegue) {
      performSegue(withIdentifier: "show", sender: segue)
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController else {return}
      if let addVC = navController.topViewController as? AddItemViewController{
        addVC.delegate = self
        }
    }
  
   // delete function  from tableView
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      deleteItem(path: indexPath.row)
      tableView.reloadData()
  }

  // update function  from tableView
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    updateItem(path: indexPath.row)
    tableView.reloadData()
  }
    
    // delagate function
    func addItemPressed(title: String, notes: String, date: String) {
    addItem(title: title, notes: notes, date: date)
        tableView.reloadData()
        
        
        dismiss(animated: true, completion: nil)
    }
    
}


