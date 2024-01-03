//
//  File.swift
//  
//
//  Created by Jamie Van Schuerbeek on 27/12/2023.
//

import Fluent

struct CreateExpenses : Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("expenses")
            .id()
            .field("title", .string, .required)
            .field("amount", .float, .required)
            .field("created_at", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("expenses").delete()
    }
    
    
}
