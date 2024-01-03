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
    
    @Field(key: "amount")
    var amount: Float
    
    @Timestamp(key: "created_at", on: .create)
        var createdAt: Date?
    
    init(){}
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

