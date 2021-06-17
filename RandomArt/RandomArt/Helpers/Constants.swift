//
//  Constants.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import Foundation

enum ReuseIdentifier {
    static let departmentCell = "DepartmentCell"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case failedLogin
    case noToken
    case failedResponse
    case noData
    case failedDecoding
    case failedEncoding
    case tryAgain
    case otherError
}

enum CoreDataError: Error {
    case empty
}
