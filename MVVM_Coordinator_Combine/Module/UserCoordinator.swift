//
//  UserCoordinator.swift
//  MVVM_Coordinator_Combine
//
//  Created by VA on 28/02/22.
//

import Foundation
import UIKit

class UserCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userListViewController = UserListViewController()
        userListViewController.coordinator = self
        navigationController.show(userListViewController, sender: nil)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let userDetailViewController = UserDetailViewController()
        navigationController.show(userDetailViewController, sender: nil)
    }
}
