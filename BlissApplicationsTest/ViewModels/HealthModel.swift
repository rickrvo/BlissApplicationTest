//
//  HealthModel.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation

class HealthModel: Codable {
    let status: String?
}

extension HealthModel {
    enum CodingKeys: String, CodingKey {
        case  status
    }
}
