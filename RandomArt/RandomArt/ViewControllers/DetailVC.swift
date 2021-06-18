//
//  DetailVC.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

class DetailVC: UIViewController {
    
    // MARK: - UI Elements
    
    private var imageView = UIImageView()
    private var noImageLabel = UILabel()
    private var objectNameLabel = UILabel()
    private var titleLabel = UILabel()
    private var artistNameLabel = UILabel()
    private var artistBioLabel = UILabel()
    private var dateLabel = UILabel()
    private var mediumLabel = UILabel()
    private var urlLabel = UILabel()
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var department: Department?
    var artwork: Artwork? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        fetchArtwork()
    }
    
    // MARK: - Private Functions
    
    private func fetchArtwork() {
        guard let department = department else { return }
        coordinator?.apiController.fetchArt(department: department, completion: { result in
            switch result {
            case .success(let artwork):
                DispatchQueue.main.async {
                    self.artwork = artwork
                    guard !artwork.primaryImage.isEmpty else {
                        self.noImageLabel.isHidden = false
                        return
                    }
                    self.coordinator?.apiController.fetchImage(imageURL: artwork.primaryImage, completion: { result in
                        switch result {
                        case .success(let image):
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        default:
                            DispatchQueue.main.async {
                                NSLog("Error fetching image")
                            }
                        }
                    })
                }
            default:
                DispatchQueue.main.async {
                    NSLog("Error fetching artwork")
                }
            }
        })
    }
    
    private func updateViews() {
        noImageLabel.isHidden = true
        if artwork?.objectName != "" {
            objectNameLabel.text = artwork?.objectName
        }
        if artwork?.title != "" {
            titleLabel.text = artwork?.title
        }
        if artwork?.medium != "" {
            mediumLabel.text = artwork?.medium
        }
        if artwork?.objectDate != "" {
            dateLabel.text = artwork?.objectDate
        }
        if artwork?.artistDisplayName != "" {
            artistNameLabel.text = artwork?.artistDisplayName
        }
        if artwork?.artistDisplayBio != "" {
            artistBioLabel.text = artwork?.artistDisplayBio
        }
        if artwork?.objectURL != "" {
            urlLabel.text = artwork?.objectURL
        }
    }
    
    private func setUpViews() {
        view.backgroundColor = .systemPink
        title = department?.displayName
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        noImageLabel.setUpLabel(textString: "No image was provided", fontName: Fonts.optimaBold.rawValue, fontSize: 25, view: view)
        noImageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        noImageLabel.isHidden = true
        
        objectNameLabel.setUpLabel(view: view)
        objectNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        
        titleLabel.setUpLabel(fontName: Fonts.optimaBold.rawValue, fontSize: 20, view: view)
        titleLabel.topAnchor.constraint(equalTo: objectNameLabel.bottomAnchor, constant: 5).isActive = true
        
        mediumLabel.setUpLabel(view: view)
        mediumLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        
        dateLabel.setUpLabel(view: view)
        dateLabel.topAnchor.constraint(equalTo: mediumLabel.bottomAnchor, constant: 3).isActive = true
        
        artistNameLabel.setUpLabel(fontName: Fonts.optimaBoldItalic.rawValue, fontSize: 20, view: view)
        artistNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        
        artistBioLabel.setUpLabel(fontName: Fonts.optimaItalic.rawValue, view: view)
        artistBioLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 3).isActive = true
        
        urlLabel.setUpLabel(view: view)
        urlLabel.topAnchor.constraint(equalTo: artistBioLabel.bottomAnchor, constant: 5).isActive = true
    }

}
