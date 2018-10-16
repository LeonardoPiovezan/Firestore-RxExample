//
//  DynamicViewModel.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 15/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import RxFirebase

class DynamicViewModel {

    let subviews: Driver<[UIView]?>
    private var firestore: Firestore!
    init() {

        if let filePath =  Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let config = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: config)
        }

        self.firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings

        self.subviews = firestore
            .collection("configuration")
            .document("views")
            .rx
            .listen()
            .map(Views.self)
            .map { views in

               return views?.sequence.map { element -> UIView in

                if element["label"] != nil {
                    let label = UILabel()

                    label.frame.size = CGSize(width: 300,  height: 30)
                    label.text = element["label"]
                    return label
                } else if element["textfield"] != nil {
                    let textField = UITextField()
                    textField.frame.size = CGSize(width: 300, height: 30)
                    textField.placeholder = element["textfield"]
                    return textField
                }
                   return UIView()
                }
        }.asDriver(onErrorJustReturn: nil)
    }
}

struct Views: Codable {
    let sequence: [[String:String]]
}
