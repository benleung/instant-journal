//
//  AppModel.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/02.
//

import Foundation
import RxSwift
import RxCocoa

protocol AppModelInput {
    var didTapTabItem: AnyObserver<AppTabBarItem> { get }
}

protocol AppModelOutput {
    var showEntryInputModal: Observable<Void> { get }
}

typealias AppModelType = AppModelInput & AppModelOutput

final class AppModel: AppModelType {
    private let disposeBag: DisposeBag = .init()
    
    // Input
    @ObserverWrapper var didTapTabItem: AnyObserver<AppTabBarItem>
    
    // Output
    @PublishWrapper var showEntryInputModal: Observable<Void>
    
    init() {
        // Input
        _didTapTabItem.subscribe(onNext: { [weak self] appTabBarItem in
            if appTabBarItem == .newEntry {
                self?._showEntryInputModal.accept(())
            }
        }).disposed(by: disposeBag)
    }
}
