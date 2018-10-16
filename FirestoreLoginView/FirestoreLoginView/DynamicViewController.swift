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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureViewModel()

        self.viewModel.subviews.drive(onNext: { [weak self] views in
            guard let `views` = views, let `self` = self else {
                return
            }
            self.stackView.removeAllArrangedSubviews()

            views.forEach{self.stackView.addArrangedSubview($0)}

        }).disposed(by: disposeBag)
    }

    func configureViewModel() {
        self.viewModel = DynamicViewModel()
    }
}

protocol DecodableOptions {
    var values: [String: Any] { get set }
    var currentKey: CodingUserInfoKey { get }
    static var key: CodingUserInfoKey { get }
}

extension UIStackView {

    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
