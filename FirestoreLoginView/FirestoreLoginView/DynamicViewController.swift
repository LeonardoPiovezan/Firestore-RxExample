//
//  DynamicViewController.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 15/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import UIKit
import Firebase
import RxFirebase
import RxSwift


class DynamicViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    var firestore: Firestore!
    var viewModel: DynamicViewModel!
    let disposeBag = DisposeBag()

    var loadingAlert: UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureFirestore()
        self.configureViewModel()
        self.setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func configureFirestore() {
        if let filePath =  Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let config = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: config)
        }

        self.firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings
    }
    func configureViewModel() {
        self.viewModel = DynamicViewModel(firestore: self.firestore)
    }

    func setupBindings() {
        self.viewModel
            .subviews
            .drive(onNext: { [weak self] views in
                guard let `views` = views, let `self` = self else {
                    return
                }
                self.stackView.removeAllArrangedSubviews()

                views.forEach{self.stackView.addArrangedSubview($0)}

            }).disposed(by: disposeBag)

        self.viewModel
            .loginSuccess
            .subscribe(onNext: { [weak self] _ in
                self?.performSegue(withIdentifier: "login", sender: nil)
            }).disposed(by: disposeBag)

    }

}

