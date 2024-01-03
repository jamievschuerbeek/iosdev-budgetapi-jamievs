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
        
        incomes.group(":id") { income in
            income.get(use: show)
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
}
