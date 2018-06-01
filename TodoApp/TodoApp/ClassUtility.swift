//
//  ClassUtility.swift
//  TodoApp
//
//  Created by Lester  Padul on 31/05/2018.
//  Copyright © 2018 Lester  Padul. All rights reserved.
//

import Foundation

struct ClassUtility{
    
     /** To save that to UserDefaults you must first encode it as JSON using JSONEncoder,
        which will send back a Data instance you can send straight to UserDefaults. **/
    public static func encodeAndAddtoUserDefaults(todo: Todo){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todo) {
            todos.append(encoded)
            let defaults = UserDefaults.standard
            defaults.set(todos, forKey: "TodoList")
            defaults.synchronize()
        }
    }
    
    
    /** To save that to UserDefaults you must first encode it as JSON using JSONEncoder,
     which will send back a Data instance you can send straight to UserDefaults. **/
    public static func encodeAndModifyAt(todo: Todo, index: Int){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todo) {
            todos[index] = encoded
            let defaults = UserDefaults.standard
            defaults.set(todos, forKey: "TodoList")
            defaults.synchronize()
        }
    }
    
    /** Reading saved data back into a Person instance is a matter of converting from Data using a JSONDecoder **/
    public static func decodeJSONObj(data: Data) -> Todo{
        let decoder = JSONDecoder()
        let loadedTodo = try? decoder.decode(Todo.self, from: data)
        return loadedTodo!
    }
    
    /** Reading saved data back into a Person instance is a matter of converting from Data using a JSONDecoder **/
    public static func decodeJSONObjReturnTitle(data: Data) -> String{
        return decodeJSONObj(data: data).todoTitle
    }
}
