//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by munira almallki on 12/03/1443 AH.
//

import UIKit

protocol AddItemDelegate: AnyObject{
    func addItemPressed(title: String, notes: String, date: String)
}
class AddItemViewController: UIViewController {
    
    weak var delegate: AddItemDelegate?
    var currentDate: String?
  
    @IBOutlet weak var titleTextField: UITextField!
        @IBOutlet weak var notesTextView: UITextView!
        @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.text = ""

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func AddItem(_ sender: Any) {
        guard let title = titleTextField.text else{return}
        guard let notes = notesTextView.text else{return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        currentDate = dateString
        guard let dateC = currentDate else{return}
        
        
        delegate?.addItemPressed(title: title, notes: notes, date: dateC)
    }
    @IBAction func dateChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        currentDate = dateString
    }
    
}
