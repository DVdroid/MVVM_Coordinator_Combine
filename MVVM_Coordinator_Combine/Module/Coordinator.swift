//
//  Coordinator.swift
//  MVVM_Coordinator_Combine
//
//  Created by VA on 28/02/22.
//


import UIKit

protocol Coordinator:AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
