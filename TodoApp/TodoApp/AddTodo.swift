//
//  AddTodo.swift
//  TodoApp
//
//  Created by Lester  Padul on 31/05/2018.
//  Copyright © 2018 Lester  Padul. All rights reserved.
//

import UIKit

class AddTodo: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var todoDesc: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var editFlag = false
    var isTaskDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        
        configureTodoDescTextView()
        
        // Make TodoTextView be selected when trying to add new task.
        todoTextField.becomeFirstResponder()
        
        funcForEdit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func DoneActionButton(_ sender: UIBarButtonItem) {
        
        guard let taskTitle = todoTextField.text, !taskTitle.isEmpty else {
            dismiss(animated: true)
            return
        }
        
        //         Initialize Todo object and append it to the List.
        let todo = Todo(todoTitle: taskTitle, description: todoDesc.text, isDone: isTaskDone)
        
        if(editFlag == false){
            
            // Call the method that is in ClassUtility to encode it as JSON Object.
            ClassUtility.encodeAndAddtoUserDefaults(todo: todo)
            dismiss(animated: true)
        } else {
            
            // Call the method that is in ClassUtility to encode it as JSON Object.
            ClassUtility.encodeAndModifyAt(todo: todo, index: todoIndex)
            dismiss(animated: true)
        }
    }
    // MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification){
        
        // Animate the churva
        UIView.animate(withDuration: 0.3) {
            
            // This'll gonna reset the constraint after changing the constant of constraint.
            self.view.layoutIfNeeded()
        }
        
    }
    
    func funcForEdit() {
        
        // Get the Todo object from the list and decode it.
        if todoIndex >= 0{
            let todo = ClassUtility.decodeJSONObj(data: todos[todoIndex])
            todoTextField.text = todo.todoTitle
            todoDesc.text = todo.description
            isTaskDone = todo.isDone
            editFlag = true
        }else{
            editFlag = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if todoDesc.text == "Task description here..." {
            todoDesc.text?.removeAll()
            todoDesc.textColor = UIColor.black
            UIView.animate(withDuration: 0.3) {
                
                // Updates the position of views as needed to satisfy changes in constraints.
                self.view.layoutIfNeeded()
            }
        }else {
            todoDesc.textColor = UIColor.black
        }
    }
    
    
    func configureTodoDescTextView() {
        todoDesc!.layer.borderWidth = 1
        todoDesc!.layer.cornerRadius = 5.0
        todoDesc!.layer.borderColor = UIColor.lightGray.cgColor
        todoDesc.delegate = self
    }
}
