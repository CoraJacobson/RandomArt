//
//  HomeVC.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - UI Elements
    
    private var welcomeLabel = UILabel()
    private var infoLabel = UILabel()
    private var enterButton = UIButton()
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc func enterTapped() {
        coordinator?.apiController.fetchDepartments(completion: { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.coordinator?.presentDepartmentVC()
                }
            default:
                print("Error fetching departments")
            }
        })
    }
    
    // MARK: - Private Functions
    
    private func setUpViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .purple
        
        welcomeLabel.setUpLabel(textString: "Welcome to\nRandomArt", fontName: Fonts.noteworthyBold.rawValue, fontSize: 40, color: .white, view: view)
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        infoLabel.setUpLabel(textString: "randomly experience artwork from the Metropolitan Museum of Art Collection", fontSize: 25, color: .white, view: view)
        infoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30).isActive = true
        
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.backgroundColor = .darkGray
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.setTitle("Enter", for: .normal)
        enterButton.titleLabel?.font = UIFont(name: Fonts.noteworthyBold.rawValue, size: 30)
        enterButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        enterButton.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        view.addSubview(enterButton)
        enterButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 50).isActive = true
        enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
