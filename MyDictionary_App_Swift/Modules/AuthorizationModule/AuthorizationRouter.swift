//
//  AuthorizationRouter.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 12.08.2021.

import UIKit

protocol AuthorizationRouterProtocol {
    var presenter: UIViewController? { get set }
    func showCourseList()
    func showRegistration()
}

final class AuthorizationRouter: AuthorizationRouterProtocol {
    
    internal weak var presenter: UIViewController?
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension AuthorizationRouter {
    
    func showCourseList() {        
        Constants.AppDependencies.dependencies.rootWindow.rootViewController = UINavigationController.init(rootViewController: CourseListModule.init(sender: nil).module)
    }
    
    func showRegistration() {
        Constants.AppDependencies.dependencies.rootWindow.rootViewController = UINavigationController.init(rootViewController: RegistrationModule.init(sender: nil).module)
    }
    
}

