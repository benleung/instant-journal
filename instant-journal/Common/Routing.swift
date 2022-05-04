//
//  Routing.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/02.
//

import UIKit

//public protocol Transitionable {
//    func transition(
//        _ rxStore: RxStore,
//        transitionStyle: Routing.TransitionStyle,
//        from: UIViewController?,
//        to routingPage: Routing.Page) -> UIViewController?
//}

struct Routing {
    enum Page {
        case home
        case profile
        case newEntry
    }
}
