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

    var subviews: Driver<[UIView]?>!
    var loginSuccess = PublishSubject<Void>()
    private var firestore: Firestore!
    private var disposeBag = DisposeBag()
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginbutton: StatusButton!

    init(firestore: Firestore) {

        self.firestore = firestore

        self.subviews = firestore
            .collection("configuration")
            .document("views")
            .rx
            .listen()
            .map(Views.self)
            .map { views in
                return views?.sequence.map { element -> UIView in
                    self.disposeBag = DisposeBag()
                    return self.getViewFor(element: element)
                }
            }.asDriver(onErrorJustReturn: nil)
    }


    private func getViewFor(element: [String:String]) -> UIView {
        if element["label"] != nil {
            let label = UILabel()

            label.frame.size = CGSize(width: 300,  height: 30)
            label.text = element["label"]
            return label
        } else if element["textField"] != nil {
            let textField = UITextField()
            textField.frame.size = CGSize(width: 300, height: 30)
            textField.placeholder = element["textField"]

            if element["type"] == "email" {
                self.setupEmailField(textField)
            } else if element["type"] == "password" {
                self.setupPasswordTextField(textField)
            }
            return textField
        } else if element["button"] != nil {
            let button = StatusButton()
            button.frame.size = CGSize(width: 250, height: 50)
            button.backgroundColor = .red
            button.setTitle(element["button"]!, for: .normal)

            self.setupLoginButton(button)
            return button
        }
        return UIView()
    }
    func setupEmailField(_ textField: UITextField) {
        self.emailTextField = textField
    }

    func setupPasswordTextField(_ textField: UITextField) {
        self.passwordTextField = textField
    }

    func setupLoginButton(_ button: StatusButton) {
        self.loginbutton = button
        self.setUpBinding()
    }

    func setUpBinding() {

        guard let _ = self.emailTextField,
            let _ = self.passwordTextField,
            let _ = self.loginbutton else {
            return
        }
        let isEmailValid = self.emailTextField.rx.text.map { text -> Bool in
            guard let email = text else {
                return false
            }
            return email.isValidEmail
        }

        let isPasswordValid =  self.passwordTextField.rx.text.map { text -> Bool in
            guard let password = text else {
                return false
            }
            return password.count > 5
        }
        let isButtonEnabled = Observable.combineLatest(isEmailValid, isPasswordValid) { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }


        isButtonEnabled
            .bind(to: self.loginbutton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        let buttonTap = self.loginbutton.rx.tap.asObservable()

        buttonTap
            .delay(5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.loginSuccess.onNext(())
            }).disposed(by: self.disposeBag)

    }
}
