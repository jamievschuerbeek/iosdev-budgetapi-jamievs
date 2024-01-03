//
//  File.swift
//
//
//  Created by Jamie Van Schuerbeek on 01/01/2024.
//

import Fluent
import Vapor

final class Income : Model, Content {
    static var schema = "incomes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "amount")
    var amount: Float
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init(){}
    
    init(id: UUID? = nil, title: String, amount: Float) {
        self.id = id
        self.title = title
        self.amount = amount
    }
}

