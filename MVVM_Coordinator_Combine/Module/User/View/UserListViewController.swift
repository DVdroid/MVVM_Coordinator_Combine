//
//  UserListViewController.swift
//  MVVM_Coordinator_Combine
//
//  Created by VA on 28/02/22.
//

import UIKit
import Combine

enum Section {
    case `default`
}

typealias TableDataSource = UITableViewDiffableDataSource<Section, String>

final class UserListViewController: UIViewController {
    
    private lazy var viewModel = UserViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    weak var coordinator: UserCoordinator?
    
    lazy var dataSource: TableDataSource = {
        let dataSource = TableDataSource(tableView: self.tableView) { [weak self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item
            
            return cell
        }
        
        return dataSource
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        self.tableView.delegate = self
        title = "User List"
        
        viewModel.$requestState.sink { [weak self] state in
            
            switch state {
            case .loading:
                print("Call in progress...")
                
            case .finished(let result):
                switch result {
                case .success(let users):
                    self?.update(with: users)
                case .failure(let error):
                    self?.update(with: error.localizedDescription)
                }
            }
        }.store(in: &cancellable)
        
        viewModel.fetchUserData()
    }
    
    private func update(with data: [String]) {
        reloadTableView(with: data)
        self.tableView.isHidden = false
        print("Table view reloaded...")
    }
    
    private func reloadTableView(with data: [String]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, String>()
        snapShot.appendSections([.default])
        snapShot.appendItems(data)
        dataSource.apply(snapShot)
    }
    
    private func update(with error: String) {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = error
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16),
        ])
        
        print("View updated with error label")
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.coordinator?.didSelectRow(at: indexPath)
    }
}

