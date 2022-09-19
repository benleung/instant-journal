//
//  AppTabBarItem.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/02.
//

import UIKit

// raw
enum AppTabBarItem: Int, CaseIterable {
    case home = 0
    case newEntry = 1
    case profile = 2

    var routing: Routing.Page? {
        switch self {
        case .home:
            return .home
        case .newEntry:
            return nil // should not transit viewcontroller
        case .profile:
            return .profile
        }
    }

    var index: Int {
        return self.rawValue
    }

    func applyStyle(tabBarItem: UITabBarItem) {
        switch self {
        case .home:
            tabBarItem.title = nil
            tabBarItem.image = UIImage(systemName: "house")
            tabBarItem.selectedImage = UIImage(systemName: "house.fill")

        case .newEntry:
            tabBarItem.title = nil
            tabBarItem.image = UIImage(systemName: "plus.circle")

        case .profile:
            tabBarItem.title = nil
            tabBarItem.image = UIImage(systemName: "person")
            tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        }
        tabBarItem.tag = index
    }
}
