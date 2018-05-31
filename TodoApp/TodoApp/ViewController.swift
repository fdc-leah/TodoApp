//
//  ViewController.swift
//  TodoApp
//
//  Created by Lester  Padul on 31/05/2018.
//  Copyright © 2018 Lester  Padul. All rights reserved.
//

import UIKit

final class Todo{
    let todoTitle: String
    let date: Date
    
}

var todos = [String]()
class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var todoTbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return todos.count
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        cell.textLabel?.text = todo[indexPath.row]
    }
}

