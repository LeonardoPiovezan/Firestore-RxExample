//
//  StatusButton.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 18/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import UIKit

class StatusButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            self.updateStatus()
        }
    }

    private func updateStatus() {
        self.backgroundColor = self.isEnabled ? .blue : .gray
    }
}
