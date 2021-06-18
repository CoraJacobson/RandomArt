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
        view.backgroundColor = .artPurple
        
        welcomeLabel.setUpLabel(textString: "Welcome to\nRandomArt", fontName: Fonts.noteworthyBold.rawValue, fontSize: 40, color: .white, view: view)
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        infoLabel.setUpLabel(textString: "randomly experience artwork from the Metropolitan Museum of Art Collection", fontSize: 25, color: .white, view: view)
        infoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30).isActive = true
        
        setUpButton(button: enterButton, text: "Enter", action: #selector(enterTapped))
        enterButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 50).isActive = true
    }
    
    private func setUpButton(button: UIButton, text: String, action: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .artDarkGray
        button.setTitleColor(.white, for: .normal)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.noteworthyBold.rawValue, size: 30)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 60, bottom: 10, right: 60)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 3
        button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
