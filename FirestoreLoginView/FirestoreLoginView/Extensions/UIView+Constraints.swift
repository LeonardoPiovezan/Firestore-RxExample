//
//  UIView+Constraints.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 15/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import UIKit

extension UIView {

    @discardableResult
    func pinTop(_ offset: CGFloat = 0.0, target: UIView? = nil) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        var constraint: NSLayoutConstraint?

        if let target = target {
            constraint = self.topAnchor.constraint(equalTo: target.topAnchor, constant: offset)
        } else {
            constraint = self.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset)
        }

        constraint?.isActive = true
        return constraint
    }

    @discardableResult
    func constraintHeight(_ toConstant: CGFloat) -> NSLayoutConstraint? {
        let constraint = self.heightAnchor.constraint(equalToConstant: toConstant)
        constraint.isActive = true
        return constraint
    }

    func prepareForConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
