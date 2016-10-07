//
//  DashboardCoordinator.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit

final class DashboardCoordinator: NSObject {
    fileprivate weak var navController: UINavigationController?
    
    var complete: ((DashboardCoordinator) -> Void)?
    
    init(navigationController: UINavigationController) {
        navController = navigationController
    }
    
    func start() -> Void {
        showDashboard()
    }
}

private extension DashboardCoordinator {
    func showDashboard() -> Void {
//        if let dashVC = DashboardViewController.initializeViewController() {
//            navController?.pushViewController(dashVC, animated: true)
//        }
    }
}

