//
//  DocumentSnapshot+Utils.swift
//  FirestoreLoginView
//
//  Created by Leonardo Piovezan on 15/10/18.
//  Copyright © 2018 Leonardo Piovezan. All rights reserved.
//

import Firebase

extension DocumentSnapshot {

    func decodeObject<T: Decodable>(options: DecodableOptions? = nil) -> T? {
        guard self.exists,
            let currentValue = self.data(),
            JSONSerialization.isValidJSONObject(currentValue) else {
                return nil
        }

        let decoder = JSONDecoder()

        if let options = options {
            decoder.userInfo[options.currentKey] = options.values
        }

        if let data = try?  JSONSerialization.data(withJSONObject: currentValue, options: []) {
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error {
                print("\n\nError parsing object: \(error.localizedDescription)")
                return nil
            }
        }

        return nil
    }
}
