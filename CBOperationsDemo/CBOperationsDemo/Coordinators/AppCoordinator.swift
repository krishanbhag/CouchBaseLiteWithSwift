//
//  AppCoordinator.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit

final class AppCoordinator: NSObject {
    fileprivate weak var navController: UINavigationController?
    fileprivate var childCoordinators: [AnyObject] = []
    
    init(navigationController: UINavigationController) {
        navController = navigationController
        navController?.isNavigationBarHidden = true
    }
    
    func start() -> Void {
        if isLoggedIn() {
            showContent()
        } else {
            showAuthentication()
        }
    }
}

private extension AppCoordinator {
    func isLoggedIn() -> Bool {
        return false
    }
    
    func showContent() -> Void {
        guard let nC = navController else {return;}
        let dashCoodinator = DashboardCoordinator(navigationController: nC)
        childCoordinators.append(dashCoodinator)
        dashCoodinator.start()
    }
    
    func showAuthentication() -> Void {
        guard let nC = navController else {return;}
        let authCoodinator = AuthCoordinator(navigationController: nC)
        authCoodinator.authDidComplete = { [weak self]
            authCoodinator in
            self?.deleteChildCoordinator(element: authCoodinator)
            self?.showEditProfileInformation()
        }
        childCoordinators.append(authCoodinator)
        authCoodinator.start()
    }
    
    func deleteChildCoordinator(element: AnyObject) {
        childCoordinators = childCoordinators.filter() { $0 !== element }
    }
    
    func showEditProfileInformation() -> Void {
        guard let nC = navController else {return;}
        let profileInfoCoodinator = ProfileInformationCoordinator(navigationController: nC)
        profileInfoCoodinator.profileComplete = { [weak self]
            pCoodinator in
            self?.navController?.viewControllers = []
            self?.deleteChildCoordinator(element: pCoodinator)
        }
        childCoordinators.append(profileInfoCoodinator)
        profileInfoCoodinator.start()
    }
}
