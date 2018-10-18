//
//  StackView+Utils.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 18/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import UIKit

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
