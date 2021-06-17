//
//  Coordinator.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

protocol Coordinator {
    var navController: UINavigationController { get set }
    func start()
}
