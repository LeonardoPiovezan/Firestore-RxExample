//
//  Observable+Rx.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 15/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import RxSwift
import Firebase

extension Observable where Element: DocumentSnapshot {

    func map<T: Decodable>(_ type: T.Type, options: DecodableOptions? = nil) -> Observable<T?> {
        return self.map({ $0.decodeObject(options: options) })
    }
}

protocol DecodableOptions {
    var values: [String: Any] { get set }
    var currentKey: CodingUserInfoKey { get }
    static var key: CodingUserInfoKey { get }
}

