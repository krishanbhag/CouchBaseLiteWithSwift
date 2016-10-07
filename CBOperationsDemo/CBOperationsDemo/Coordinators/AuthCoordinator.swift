//
//  AuthCoordinator.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit

final class AuthCoordinator: NSObject {
    fileprivate weak var navController: UINavigationController?
    
    var authDidComplete: ((AuthCoordinator) -> Void)?
    
    init(navigationController: UINavigationController) {
        navController = navigationController
    }
    
    func start() -> Void {
        showLogin()
    }
}

private extension AuthCoordinator {
    func showLogin() -> Void {
        if let loginVC = LoginViewController.initializeViewController() {
            loginVC.loginSuccess = { [weak self]
                lVC in
                self?.navController?.viewControllers = []
                if let strongSelf = self {
                    strongSelf.authDidComplete?(strongSelf)
                }
            }
            navController?.pushViewController(loginVC, animated: true)
        }
    }
}
