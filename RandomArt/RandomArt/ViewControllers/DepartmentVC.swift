//
//  DepartmentVC.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit
import CoreData

class DepartmentVC: UIViewController {
    
    // MARK: - UI Elements
    
    private var infoLabel = UILabel()
    private var subView = UIView()
    private var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var datasource: UICollectionViewDiffableDataSource<Int, Department>!
    private var fetchedResultsController: NSFetchedResultsController<Department>!
    private let moc = CoreDataStack.shared.mainContext
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        configureDatasource()
        initFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Private Functions
    
    private func setUpViews() {
        view.backgroundColor = .blue
        title = "Departments"
        
        infoLabel.setUpLabel(textString: "Please select a department", fontSize: 25, color: .white, view: view)
        infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        subView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20).isActive = true
        subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        subView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        subView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: subView.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView?.register(DepartmentCell.self, forCellWithReuseIdentifier: ReuseIdentifier.departmentCell)
        collectionView.delegate = self
        subView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: subView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: subView.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: subView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: subView.rightAnchor).isActive = true
    }
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, department) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.departmentCell, for: indexPath) as? DepartmentCell else { fatalError("Cannot create cell") }
            cell.department = department
            return cell
        })
    }
    
    private func initFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Department> = Department.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "displayName", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Unable to fetch departments from main context: \(error)")
        }
    }

}

extension DepartmentVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Department>()
            diffableDataSourceSnapshot.appendSections([0])
            diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
            datasource?.apply(diffableDataSourceSnapshot, animatingDifferences: view.window != nil)
    }
}

extension DepartmentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedDepartment = datasource.itemIdentifier(for: indexPath) else { return }
        coordinator?.presentDetailVC(department: selectedDepartment)
    }
}
