//
//  ExpenseController.swift
//
//
//  Created by Jamie Van Schuerbeek on 27/12/2023.
//

import Fluent
import Vapor

struct ExpenseController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let expenses = routes.grouped("expenses")
        expenses.get(use: index)
        expenses.post(use: create)
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Expense]> {
        return Expense.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let expense = try req.content.decode(Expense.self)
        return expense.save(on: req.db).transform(to: .ok)
    }
}
