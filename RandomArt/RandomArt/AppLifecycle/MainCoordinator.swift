//
//  MainCoordinator.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - General Functions

    func start() {
        setUpAppNavViews()
    }
    
    // MARK: - Private Functions
    
    private func setUpAppNavViews() {
        guard let homeVC = navController.topViewController as? HomeVC else { return }
        homeVC.coordinator = self
    }
}
