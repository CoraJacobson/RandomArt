//
//  HomeVC.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }

}
