//
//  AddTodo.swift
//  TodoApp
//
//  Created by Lester  Padul on 31/05/2018.
//  Copyright © 2018 Lester  Padul. All rights reserved.
//

import UIKit

class AddTodo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DoneActionButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
