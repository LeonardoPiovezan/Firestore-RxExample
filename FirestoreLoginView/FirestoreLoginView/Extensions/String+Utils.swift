//
//  String+Utils.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 18/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
