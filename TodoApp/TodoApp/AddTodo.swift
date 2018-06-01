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
    @IBOutlet weak var bottomConstraints: UITextView!
    var editFlag = false
    var isTaskDone = false
    var keyboardHeight: CGFloat = 0.0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
        
        adjustFrames()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if todoDesc.text.isEmpty{
            todoDesc.text = "Task description here..."
            todoDesc.textColor = UIColor.lightGray
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
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 300
        {
            adjustFrames()
        }
    }
    func adjustFrames() {
        
        var newFrame = todoDesc.frame
        
        let fixedWidth = todoDesc.frame.size.width
        let newSize = todoDesc.sizeThatFits(CGSize(width: fixedWidth, height: view.bounds.size.height - keyboardHeight))
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.todoDesc.frame = newFrame
        
    }
    func configureTodoDescTextView() {
        todoDesc!.layer.borderWidth = 1
        todoDesc!.layer.cornerRadius = 5.0
        todoDesc!.layer.borderColor = UIColor.lightGray.cgColor
        todoDesc.delegate = self
    }
    
    @objc func keyboardWillShow(with notification: Notification) {
        
         guard  let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.3) {
                
                // This'll gonna reset the constraint after changing the constant of constraint.
                self.view.layoutIfNeeded()
            }
    }
    
    
    
    @objc func DismissKeyboard(){
        //Causes the view to resign from the status of first responder.
        view.endEditing(true)
    }
}
