//
//  Router.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/02.
//

import UIKit
import RxSwift

class Router {

    let rootViewController: UIViewController
    static let shared = Router()

    init(rootViewController: UIViewController = RootViewController()) {
        self.rootViewController = rootViewController
    }
    
    func controller(routingPage: Routing.Page) -> UIViewController {
        switch routingPage {
        case .home:
            let vc = HomeViewController()// FIXME  ViewController
            return vc
        case .profile:
            let vc = ProfileViewController()// FIXME  ViewController
            return vc
        case .newEntry:
            let vc = NewEntryViewController()
            let nav = UINavigationController(rootViewController: vc)// FIXME  ViewController
            nav.modalPresentationStyle = .fullScreen
            nav.navigationBar.isHidden = false
            
            return nav
        }
    }
}
