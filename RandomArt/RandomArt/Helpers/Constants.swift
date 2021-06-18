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

enum Fonts: String {
    case noteworthyBold = "Noteworthy-Bold"
    case optimaReg = "Optima-Regular"
    case optimaBold = "Optima-Bold"
    case optimaBoldItalic = "Optima-BoldItalic"
    case optimaItalic = "Optima-Italic"
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
    case failedRequestSetUp
    case tryAgain
    case otherError
}

enum CoreDataError: Error {
    case empty
}
