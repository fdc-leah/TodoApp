//
//  ViewController.swift
//  TodoApp
//
//  Created by Lester  Padul on 31/05/2018.
//  Copyright © 2018 Lester  Padul. All rights reserved.
//

import UIKit

struct Todo: Codable {
    let todoTitle: String
    let description: String
    var isDone: Bool
    
}

var todos = [Data]()
var userData = false
var todoIndex = -1
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Get user data if ther is any.
        // Otherwise, add "no user data" to the list to avoid app from crashing.
        userData = UserDefaults.standard.bool(forKey: "userData")
        
        if userData == true {
            if let loadedTodos = UserDefaults.standard.array(forKey: "TodoList") as? [Data] {
                todos = loadedTodos
            }
        }
        
        todoTbl.reloadData();
    }

    override func viewDidAppear(_ animated: Bool) {
        todoTbl.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return todos.count
    }

     public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        let data: Data = todos[indexPath.row]
        let todoDecoded = ClassUtility.decodeJSONObj(data: data)
        cell.textLabel?.text = ClassUtility.decodeJSONObjReturnTitle(data: data)
        
        if todoDecoded.isDone == true{
            cell.imageView?.image = resizeImage(imageName: "check")
        }else{
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") {(action, view, complete) in
            
            // Update isDone value.
            var todo = ClassUtility.decodeJSONObj(data: todos[indexPath.row])
            debugPrint(todo.isDone)
            if !todo.isDone{
                todo.isDone = true
            }else{
                todo.isDone = false
            }
            
            // Update list of arrays
            ClassUtility.encodeAndModifyAt(todo: todo, index: indexPath.row)
            self.todoTbl.reloadData()
            complete(true)
        }
        action.backgroundColor = UIColor(red:0.18, green:0.72, blue:0.18, alpha:1.0)
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modify = modifyAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        let config = UISwipeActionsConfiguration(actions: [delete,modify])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    // Function for modify action.
    func modifyAction(at indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .normal, title: "Modify") {(action, view, complete) in
           
            todoIndex = indexPath.row
            self.performSegue(withIdentifier: "toEditOrAdd", sender: self)
            complete(true)
        }
        
        action.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.40, alpha:1.0)
        return action
    }
    
    // Function for delete action.
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
          let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, complete) in
            todos.remove(at: indexPath.row)
            let defaults = UserDefaults.standard
            defaults.set(todos, forKey: "TodoList")
            defaults.synchronize()
            self.todoTbl.reloadData()
            
            complete(true)
        }
        
        action.backgroundColor = UIColor(red:1.00, green:0.36, blue:0.20, alpha:1.0)
         return action
    }
    
    fileprivate func resizeImage(imageName: String) -> UIImage {
        return UIGraphicsImageRenderer(size:CGSize(width: 30, height: 30)).image { _ in
            UIImage(named:imageName)?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30)))
        }
    }
}

