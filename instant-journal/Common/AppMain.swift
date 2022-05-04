//
//  AppMain.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/02.
//

import UIKit
import RxSwift

final class AppMain: NSObject {
    var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        return tabBarController
    }()
    
    private var input: AppModelInput
    private var output: AppModelOutput
    private var disposeBag: DisposeBag = .init()
    
    override init() {
        let viewModel = AppModel()
        self.input = viewModel
        self.output = viewModel

        super.init()
    }
    
    func prepare() {
        tabBarController.delegate = self
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.backgroundColor = UIColor(red: 250, green: 250, blue: 248, alpha: 1.0)  // Color Constants
        
        // set tabBarController as RootViewController's child
        tabBarController.view.frame = Router.shared.rootViewController.view.bounds
        Router.shared.rootViewController.addChild(tabBarController)
        Router.shared.rootViewController.view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: Router.shared.rootViewController)
        
        // setup tabItem
        setViewControllers(items: AppTabBarItem.allCases)
        
        // bind model
        bindModel()
    }
    
    private func bindModel() {
        output.showEntryInputModal
            .subscribe(onNext: { [weak self] in
                // FIXME WIP
//                self?.tabBarController.present(UIViewController(), animated: true)
//                self?.tabBarController.selectedViewController?.navigationController?.present(UIViewController(), animated: true)
                let vc = Router.shared.controller(routingPage: .newEntry)
//                let nav = UINavigationController(rootViewController: vc)
//                nav.navigationBar.backgroundColor = .lightGray
                
                Router.shared.rootViewController.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - tab bar controller
    private func setViewControllers(items: [AppTabBarItem]) {
        let navs: [UINavigationController] = items.map { item in
            // if routing vc exists
            if let routing = item.routing {
                let vc = Router.shared.controller(routingPage: routing)
                return UINavigationController(rootViewController: vc)
            }
            // routing vc doesn't exist, so return a dummy
            // not expected to be displayed, restricting by UITabBarControllerDelegate
            return UINavigationController()
        }
        self.tabBarController.setViewControllers(navs, animated: false)
        items.forEach { item in
            if let tab = tabBarItem(with: item) {
                item.applyStyle(tabBarItem: tab)
            }
        }
    }
    
    private func tabBarItem(with item: AppTabBarItem) -> UITabBarItem? {
        let index = item.index
        guard tabBarController.tabBar.items?.count ?? 0 > index else { return nil }

        if let item = tabBarController.tabBar.items?[index] {
            return item
        } else {
            return nil
        }
    }
}

extension AppMain: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let appTabBarItem = AppTabBarItem(rawValue: viewController.tabBarItem.tag) else {
            return false
        }
        input.didTapTabItem.onNext(appTabBarItem)
        return appTabBarItem.routing != nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // do nothing
    }
}
