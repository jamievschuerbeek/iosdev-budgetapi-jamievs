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
        expenses.get("date",":year", "month", ":month" , use: findDate)
        expenses.group(":id") { expense in
            expense.get(use: show)
            expense.delete(use: delete)
        }
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Expense]> {
        return Expense.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let expense = try req.content.decode(Expense.self)
        return expense.save(on: req.db).transform(to: .ok)
    }
    
    func show(req: Request) async throws -> Expense {
        guard let expense = try await Expense.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return expense
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let expense = try await Expense.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await expense.delete(on: req.db)
        return .ok
    }
    
    func findDate(req: Request) async throws -> [Expense] {
        //lelijke manier van filteren maar het werkt wel
        let res = try await Expense.query(on: req.db).all()
        let expenses = res.filter { value in
            
            //by far de lelijkste code ooit maar fly.io ondersteunt geen date.formatted for some reason ¯\_(ツ)_/¯
            //jaar
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: value.createdAt!)
            
            //maand
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: value.createdAt!)
            
            if year == req.parameters.get("year") && month == req.parameters.get("month"){
                return true
            }
            return false
        }
        return expenses
    }
}
