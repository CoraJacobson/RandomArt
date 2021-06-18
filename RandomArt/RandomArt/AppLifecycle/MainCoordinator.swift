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
    var apiController = ApiController()
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public Functions

    func start() {
        setUpAppNavViews()
    }
    
    func presentDepartmentVC() {
        let departmentVC = DepartmentVC()
        departmentVC.coordinator = self
        navController.pushViewController(departmentVC, animated: true)
    }
    
    func presentDetailVC(department: Department) {
        let detailVC = DetailVC()
        detailVC.coordinator = self
        detailVC.department = department
        navController.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func setUpAppNavViews() {
        guard let homeVC = navController.topViewController as? HomeVC else { return }
        homeVC.coordinator = self
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .artPurple
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts.noteworthyBold.rawValue, size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}
