//
//  DepartmentRepresentation.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import Foundation

struct DepartmentRepresentation: Decodable {
    var departmentId: Int
    var displayName: String
}

struct Departments: Decodable {
    var departments: [DepartmentRepresentation]
}
