//
//  Artwork.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import Foundation

struct ObjectIDs: Decodable {
    var objectIDs: [Int64]
}

struct Artwork: Decodable {
    var objectID: Int
    var primaryImage: String
    var objectName: String
    var title: String
    var artistDisplayName: String
    var artistDisplayBio: String
    var objectDate: String
    var medium: String
    var objectURL: String
}
