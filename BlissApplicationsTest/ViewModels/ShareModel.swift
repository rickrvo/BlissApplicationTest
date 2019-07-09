//
//  ShareModel.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation

class ShareModel: Codable {
    let status: String?
}

extension ShareModel {
    enum CodingKeys: String, CodingKey {
        case  status
    }
}
