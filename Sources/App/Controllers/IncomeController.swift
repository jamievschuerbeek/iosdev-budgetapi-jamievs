//
//  File.swift
//  
//
//  Created by Jamie Van Schuerbeek on 03/01/2024.
//

import Fluent
import Vapor

struct IncomeController : RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let incomes = routes.grouped("incomes")
        incomes.get(use: index)
        incomes.post(use: create)
        incomes.get("date",":year", "month", ":month" , use: findDate)
        incomes.group(":id") { income in
            income.get(use: show)
            income.delete(use: delete)
        }
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Income]> {
        return Income.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let income = try req.content.decode(Income.self)
        return income.save(on: req.db).transform(to: .ok)
    }
    
    func show(req: Request) async throws -> Income {
        guard let income = try await Income.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return income
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let income = try await Income.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await income.delete(on: req.db)
        return .ok
    }
    
    func findDate(req: Request) async throws -> [Income] {
        let res = try await Income.query(on: req.db).all()
        let income = res.filter { value in
            
            
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
        return income
    }
}
