//
//  HomeViewController.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/05.
//

import UIKit

import FirebaseCore
import FirebaseFirestore

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        
        let db = Firestore.firestore()
        db.collection("records")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let cities = documents.map { $0["emoji"]! }
                print("Current cities in CA: \(cities)")
            }

    }

}
