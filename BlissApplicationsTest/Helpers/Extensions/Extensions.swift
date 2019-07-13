//
//  Extensions.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 13/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation

func toJSON(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}
