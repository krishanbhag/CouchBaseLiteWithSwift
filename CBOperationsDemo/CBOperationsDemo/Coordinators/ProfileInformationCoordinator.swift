//
//  ProfileInformationCoordinator.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit

final class ProfileInformationCoordinator: NSObject {
    fileprivate weak var navController: UINavigationController?
    
    var profileComplete: ((ProfileInformationCoordinator) -> Void)?
    
    init(navigationController: UINavigationController) {
        navController = navigationController
    }
    
    func start() -> Void {
        showProfileInfo()
    }
}

private extension ProfileInformationCoordinator {
    func showProfileInfo() -> Void {
        if let profileVC = ProfileInfoViewController.initializeViewController() {
            profileVC.nextHandler = { [weak self]
                pVC in
                if let strongSelf = self {
                    strongSelf.showProfileCompany()
                }
            }
            navController?.pushViewController(profileVC, animated: true)
        }
    }
    func showProfileCompany() -> Void {
//        if let profileCompanyVC = DashboardCoordinator.initializeViewController() {
//            navController?.pushViewController(profileCompanyVC, animated: true)
//        }
    }
}
