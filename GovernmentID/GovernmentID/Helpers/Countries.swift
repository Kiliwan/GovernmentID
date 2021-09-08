//
//  Countries.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 17.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Foundation

enum Countries: String {
    case che
    case jpn
    
    func server_url() -> String {
        switch self {
        case .che: return "http://3.17.138.33:3001"
        case .jpn: return "http://18.190.25.49:3001"
        }
    }
}
