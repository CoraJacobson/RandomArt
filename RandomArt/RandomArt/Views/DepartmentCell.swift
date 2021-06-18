//
//  DepartmentCell.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

class DepartmentCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private var nameLabel = UILabel()
    
    // MARK: - Properties
    
    var department: Department? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Override Functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
    }
    
    // MARK: - Private Functions
    
    private func updateView() {
        guard let department = department else { return }
        nameLabel.text = department.displayName
    }
    
    private func setUpView() {
        backgroundColor = .white
        
        layer.cornerRadius = 15
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: Fonts.optimaBold.rawValue, size: 16)
        contentView.addSubview(nameLabel)
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
}
