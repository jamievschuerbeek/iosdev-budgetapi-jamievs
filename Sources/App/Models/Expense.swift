//
//  File.swift
//  
//
//  Created by Jamie Van Schuerbeek on 27/12/2023.
//

import Fluent
import Vapor

final class Expense : Model, Content {
    static let schema = "expenses"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init(){}
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

