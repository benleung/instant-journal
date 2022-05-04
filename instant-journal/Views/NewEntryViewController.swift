//
//  NewEntryViewController.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/05.
//

import UIKit
import RxSwift

class NewEntryViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation
        navigationItem.title = "New Entry"
        let item = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        item.rx.tap
            .bind(to: Binder(self) { vc, _ in vc.dismiss(animated: true) })
            .disposed(by: disposeBag)
        navigationItem.leftBarButtonItem = item
        
        view.backgroundColor = .white
    }

}
